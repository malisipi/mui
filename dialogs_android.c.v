module mui

pub fn messagebox(title string, text string, dialog_type string, icon_type string) int {
	return 0
}

[unsafe]
pub fn inputbox(title string, text string, default_text string) string {
    return ""
}

[unsafe]
pub fn passwordbox(title string, text string) string {
    return ""
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
    return ""
}

pub fn notifypopup(title string, text string, icon_type string){}

pub fn beep(){}
