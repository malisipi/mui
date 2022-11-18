module window

fn C.FreeConsole()
fn C.AllocConsole()
fn C.GetConsoleWindow() voidptr
fn C.ShowWindow(voidptr, bool)

pub fn hide_console_window(){
	$if windows {
		C.FreeConsole()
		C.AllocConsole()
		hwnd:=C.GetConsoleWindow()
		C.ShowWindow(hwnd, false)
	}
}