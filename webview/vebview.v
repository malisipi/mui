module webview

#include "@VMODROOT/webview/webview/webview.h"
#pkgconfig gtk+-3.0
#pkgconfig webkit2gtk-4.0
#flag -I./webview/
#flag @VMODROOT/webview/webview.o

type Webview_t = voidptr
fn C.webview_create(debug int, window voidptr) Webview_t
fn C.webview_destroy(w Webview_t)
fn C.webview_run(w Webview_t)
fn C.webview_set_title(w Webview_t, title &char)
fn C.webview_set_size(w Webview_t, width int, height int, hints int)
fn C.webview_set_html(w Webview_t, html &char)
fn C.webview_navigate(w Webview_t, url &char)
fn C.webview_bind(w Webview_t, func_name &char, func fn(&char, &char, mut &voidptr), arg voidptr)
fn C.webview_return(w Webview_t, seq &char, status int, result &char)
fn C.webview_get_window(w Webview_t) voidptr
fn C.webview_eval(w Webview_t, code &char)
