module mui

pub fn messagebox(title string, text string, dialog_type string, icon_type string) int {
    C.emscripten_run_script(cstr("alert('"+title+"\\n"+text+"')"))
	return 0
}

[unsafe]
pub fn inputbox(title string, text string, default_text string) string {
    unsafe {
        return C.emscripten_run_script_string(cstr("prompt('"+title+"\\n"+text+"','"+default_text+"')")).vstring()
    }
}

[unsafe]
pub fn passwordbox(title string, text string) string {
    unsafe {
        return C.emscripten_run_script_string(cstr("alert('"+title+"\\n"+text+"')")).vstring()
    }
}

pub fn openfiledialog(title string) string {
    return ""
}

pub fn savefiledialog(title string) string {
    return ""
}

pub fn selectfolderdialog(title string) string {
    return ""
}

[unsafe]
pub fn colorchooser(title string, default_color string) string {
    unsafe {
        return C.emscripten_run_script_string(cstr("prompt('"+title+"','"+default_color+"')")).vstring()
    }
}

pub fn notifypopup(title string, text string, icon_type string){
    C.emscripten_run_script(cstr("alert('"+title+"\\n"+text+"')"))
}

pub fn beep(){}
