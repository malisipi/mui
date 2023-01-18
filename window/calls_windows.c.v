module window

#include "@VMODROOT/window/mui_window.h"
#flag windows -ldwmapi

fn C.FreeConsole()
fn C.AllocConsole()
fn C.GetConsoleWindow() voidptr
fn C.ShowWindow(voidptr, bool)
fn C.prefer_dark_titlebar(voidptr, bool)
