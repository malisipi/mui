import loadWASM from "./app.js";

window.mui = {
    module: null,
    latest_file: null,
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
        //document.body.append(downloader);
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
    set trigger(val){
        if (val == "openfiledialog"){
            mui.open_file_dialog();
        } else if (val =="savefiledialog"){
            mui.save_file_dialog();
        }
    }
};

(async () => {
    mui.module = await loadWASM();
})();