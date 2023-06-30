module mui

pub fn messagebox(title string, text string, dialog_type string, icon_type string) int {
    C.emscripten_run_script(cstr("alert('"+title+"\\n"+text+"')"))
	return 0
}

pub fn inputbox(title string, text string, default_text string) string {
    unsafe {
        return C.emscripten_run_script_string(cstr("prompt('"+title+"\\n"+text+"','"+default_text+"')")).vstring()
    }
}

pub fn passwordbox(title string, text string) string {
    unsafe {
        return C.emscripten_run_script_string(cstr("alert('"+title+"\\n"+text+"')")).vstring()
    }
}

pub fn openfiledialog(title string) string {
    unsafe {
        C.emscripten_run_script(c"mui.trigger = \"openfiledialog\"")
        for ;C.emscripten_run_script_string(c"mui.task_result").vstring() != "1"; {
            C.emscripten_sleep(500)
        }
        C.emscripten_run_script(c"mui.task_result = \"0\"")
        return C.emscripten_run_script_string(c"mui.latest_file.name").vstring()
    }
}

pub fn savefiledialog(title string) string {
    unsafe {
        C.emscripten_run_script(c"mui.trigger = \"savefiledialog\"")
        for ;C.emscripten_run_script_string(c"mui.task_result").vstring() != "1"; {
            C.emscripten_sleep(500)
        }
        C.emscripten_run_script(c"mui.task_result = \"0\"")
        return C.emscripten_run_script_string(c"mui.latest_file.name").vstring()
    }
}

pub fn selectfolderdialog(title string) string {
    return ""
}

pub fn colorchooser(title string, default_color string) string {
    unsafe {
        return C.emscripten_run_script_string(cstr("prompt('"+title+"','"+default_color+"')")).vstring()
    }
}

pub fn notifypopup(title string, text string, icon_type string){
    C.emscripten_run_script(cstr("alert('"+title+"\\n"+text+"')"))
}

pub fn beep(){}
