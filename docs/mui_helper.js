import loadWASM from "./app.js";

window.mui = {
    module: null,
    latest_file: null,
    canvas: null,
    task_result: "0",
    open_file_dialog: async () => {
        let input = document.createElement("input");
        input.type = "file";
        await new Promise((promise_resolve, promise_reject) => {
            input.addEventListener("change", async e => {
                mui.latest_file = e.target.files[0];
                let array_buffer = await mui.latest_file.arrayBuffer();
                mui.module.FS.writeFile(mui.latest_file.name, new Uint8Array(array_buffer));
                promise_resolve();
            });
            input.click();
        });
        mui.task_result = "1";
        return mui.latest_file.name;
    },
    save_file_dialog: async () => {
        mui.latest_file = {name: prompt("File Name of that will be saved")};
        try {
            mui.module.FS.unlink(mui.latest_file.name);
        } catch (error) {}
        mui.task_result = "1";
        mui.watch_file_until_action();
    },
    download_file: (filename, uia) => {
        let blob = new Blob([uia], {
            type: "application/octet-stream"
        });
        let url = window.URL.createObjectURL(blob);
        let downloader = document.createElement("a");
        downloader.href = url;
        downloader.download = filename;
        downloader.click();
        downloader.remove();
        setTimeout(() => {
            window.URL.revokeObjectURL(url);
        }, 1000);
    },
    watch_file_until_action: async () => {
        let the_file_name = mui.latest_file.name;
        let watcher = setInterval(() => {
            if(mui.module.FS.analyzePath(the_file_name).exists){
                clearInterval(watcher);
                mui.download_file(the_file_name, mui.module.FS.readFile(the_file_name));
                mui.module.FS.unlink(the_file_name);
            }
        }, 500);
    },
    beep: () => {
        var context = new AudioContext();
        var oscillator = context.createOscillator();
        oscillator.type = "sine";
        oscillator.frequency.value = 400;
        oscillator.connect(context.destination);
        oscillator.start(); 
        setTimeout(function () {
            oscillator.stop();
        }, 150);        
    },
    ext_keyboard_keys: {
        left: [10001, "←"],
        up: [10002, "↑"],
        right: [10003, "→"],
        down: [10004, "↓"]
    },
    send_key: (keycode) => {
        var e = document.createEventObject ? document.createEventObject() : document.createEvent("Events");
        if (e.initEvent) e.initEvent("keypress", true, true);

        e.keyCode = keycode;
        e.which = keycode;
        e.charCode = keycode;
        mui.module.JSEvents.eventHandlers.filter(e => e.eventTypeString == "keypress")[0].handlerFunc(e);
    },
    set trigger(val){
        if (val == "openfiledialog"){
            mui.open_file_dialog();
        } else if (val == "savefiledialog"){
            mui.save_file_dialog();
        } else if (val == "keyboard-hide"){
            mui.canvas.focus();
            navigator.virtualKeyboard?.hide();
        } else if (val == "keyboard-show"){
            mui.canvas.focus();
            navigator.virtualKeyboard?.show();
        } else if (val == "beep") {
            mui.beep();
        };
    },
    init_control_helpers: () => {
        let mui_styles = document.createElement("style");
        mui_styles.innerHTML = `
        #canvas{
			position:fixed;
			top:0;
			left:0;
			width:100%;
			height:100%;
		}

        .keyboard_helper {
            position: fixed;
            bottom: -1000px;
            right: 10px;
            background: #222;
            padding: 5px;
            border-radius: 5px;
            display: flex;
            gap: 5px;
        }

        .keyboard_helper[show_ext] {
            bottom: calc(env(keyboard-inset-height, 0px) + 10px);
        }

        .keyboard_helper > button {
            border-radius: 4px;
            padding: 10px;
            border: none;
            color: #fff;
            background: #111;
            width: 40px;
            height: 40px;
        }
        `;
        document.head.append(mui_styles);
        let keyboard_helper = document.createElement("div");
        navigator.virtualKeyboard?.addEventListener("geometrychange", (e, _keyboard_helper = keyboard_helper) => {
            if(navigator.virtualKeyboard?.boundingRect.height > 0){
                _keyboard_helper.setAttribute("show_ext", true);
            } else {
                if(_keyboard_helper.hasAttribute("show_ext")){
                    _keyboard_helper.removeAttribute("show_ext");
                };
            }
        });

        document.addEventListener("keydown", e => {
            console.log(e);
            if(e.key == "Backspace" && e.code == ""){
                mui.send_key(8);
            }
        })

        if(!!navigator?.userAgentData?.mobile){
            if(!!navigator.virtualKeyboard?.overlaysContent){
                navigator.virtualKeyboard.overlaysContent = true;
            };
            
            keyboard_helper.className = "keyboard_helper";
            document.body.append(keyboard_helper);
            
            for(let key_index in mui.ext_keyboard_keys){
                let key_info = mui.ext_keyboard_keys[key_index];
                let the_key = document.createElement("button");
                the_key.addEventListener("click", (e, inf=key_info[0]) => {
                    e.target.blur();
                    mui.send_key(inf);
                });
                the_key.innerText = key_info[1];
                keyboard_helper.append(the_key);
            }
        };
    }
};

document.addEventListener("DOMContentLoaded", async () => {
    mui.init_control_helpers();
    mui.canvas = document.getElementById("canvas");
    mui.module = await loadWASM();
});