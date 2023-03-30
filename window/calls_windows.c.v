module window

#include "@VMODROOT/window/mui_window.h"
#flag windows -ldwmapi

fn C.FreeConsole()
fn C.AllocConsole()
fn C.GetConsoleWindow() voidptr
fn C.ShowWindow(voidptr, bool)
fn C.mui_prefer_dark_titlebar(voidptr, bool)
fn C.SetWindowLong(voidptr, int, int)
fn C.GetWindowLong(voidptr, int) int
fn C.SetLayeredWindowAttributes(voidptr, int, int, int)