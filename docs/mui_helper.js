import loadWASM from "./app.js";

window.mui = {
    module: null,
    latest_file: null,
    task_result: "0",
    results: {
        open_file_dialog: "2"
    },
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
        mui.task_result = mui.results.open_file_dialog;
        return mui.latest_file.name;
    },
    set trigger(val){
        if(val == "openfiledialog"){
            mui.open_file_dialog();
        };
    }
};

(async () => {
    mui.module = await loadWASM();
})();