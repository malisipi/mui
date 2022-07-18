module mui

#include "@VMODROOT/tinyfiledialogs/tinyfiledialogs.h"
#flag @VMODROOT/tinyfiledialogs/tinyfiledialogs.c
#flag windows -lole32
#flag windows -lcomdlg32

fn C.tinyfd_messageBox(a &char, b &char, c &char, d &char, e int) int

fn C.tinyfd_inputBox(a &char, b &char, c &char) &char

fn C.tinyfd_openFileDialog(a &char, b &char, c &char, d &char, e &char, f &char) &char

fn C.tinyfd_saveFileDialog(a &char, b &char, c &char, d &char, e &char) &char

fn C.tinyfd_selectFolderDialog(a &char, b &char) &char

fn C.tinyfd_colorChooser(a &char, b &char, c &char, d &char) &char

fn C.tinyfd_notifyPopup(a &char, b &char, c &char)

fn C.tinyfd_beep()

// dialog_type => "ok", "okcancel", "yesno", "yesnocancel"
// icon_type   => "info", "warning", "error"
// 0 -> cancel/no, 1 -> ok/yes, 2 -> no (yesnocancel)
pub fn messagebox(title string, text string, dialog_type string, icon_type string) int {
	return C.tinyfd_messageBox(cstr(title), cstr(text), cstr(dialog_type), cstr(icon_type), 0)
}

pub fn inputbox(title string, text string, default_text string) string {
	temp := unsafe { C.tinyfd_inputBox(cstr(title), cstr(text), cstr(default_text)) }
	if temp != &char(0) {
		return unsafe{ temp.vstring() }
	} else {
		return ""
	}
}

pub fn passwordbox(title string, text string) string {
	temp := unsafe { C.tinyfd_inputBox(cstr(title), cstr(text), voidptr(0)) }
	if temp != &char(0) {
		return unsafe{ temp.vstring() }
	} else {
		return ""
	}
}

pub fn openfiledialog(title string) string {
	temp := unsafe { C.tinyfd_openFileDialog(cstr(title), cstr(''), 0, cstr(''), cstr(''), cstr('')) }
	if temp != &char(0) {
		return unsafe{ temp.vstring() }
	} else {
		return ""
	}
}

pub fn savefiledialog(title string) string {
	temp := unsafe { C.tinyfd_saveFileDialog(cstr(title), cstr(''), 0, cstr(''), cstr('')) }
	if temp != &char(0) {
		return unsafe{ temp.vstring() }
	} else {
		return ""
	}
}

pub fn selectfolderdialog(title string) string {
	temp := C.tinyfd_selectFolderDialog(cstr(title), cstr(""))
	if temp != &char(0) {
		return unsafe{ temp.vstring() }
	} else {
		return ""
	}
}

pub fn colorchooser(title string, default_color string) string {
	temp := C.tinyfd_colorChooser(cstr(title), cstr(default_color), cstr(""), cstr(""))
	if temp != &char(0) {
		return unsafe{ temp.vstring() }
	} else {
		return ""
	}
}

pub fn notifypopup(title string, text string, icon_type string){ // "info", "warning", "error"
	C.tinyfd_notifyPopup(cstr(title), cstr(text), cstr(icon_type))
}

pub fn beep(){
	C.tinyfd_beep()
}
