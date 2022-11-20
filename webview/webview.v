module webview

import os

#include "@VMODROOT/webview/webview/webview.h"
#flag -I./webview/
#flag @VMODROOT/webview/webview.o
$if gcc || mingw {
	#flag -lstdc++
}

type Webview_t = voidptr
fn C.webview_create(debug int, window voidptr) Webview_t
fn C.webview_terminate(w Webview_t)
fn C.webview_destroy(w Webview_t)
fn C.webview_run(w Webview_t)
fn C.webview_set_title(w Webview_t, title &char)
fn C.webview_set_size(w Webview_t, width int, height int, hints int)
fn C.webview_set_html(w Webview_t, html &char)
fn C.webview_navigate(w Webview_t, url &char)
fn C.webview_bind(w Webview_t, func_name &char, func fn(&char, &char, mut &voidptr), mut arg voidptr)
fn C.webview_unbind(w Webview_t, func_name &char)
fn C.webview_return(w Webview_t, seq &char, status int, result &char)
fn C.webview_get_window(w Webview_t) voidptr
fn C.webview_eval(w Webview_t, code &char)
fn C.webview_init(w Webview_t, code &char)
fn C.webview_dispatch(w Webview_t, funct fn(w Webview_t, args voidptr), args voidptr)

[unsafe]
fn init() {
	mut static does_init:=false
	if !does_init {
		$if windows {
			C._putenv(c"--allow-file-access-from-files")
		}
	}
	does_init=true
}

pub fn create(debug int) Webview_t {
	$if windows {
		unsafe {
			init()
		}
	}
	return C.webview_create(debug, C.NULL)
}

pub fn (webview Webview_t) destroy (){
	C.webview_destroy(webview)
}

pub fn (webview Webview_t) terminate (){
	C.webview_terminate(webview)
}

pub fn (webview Webview_t) run (){
	C.webview_run(webview)
}

pub fn (webview Webview_t) set_title (title string){
	C.webview_dispatch(webview, fn [title](webview Webview_t, void voidptr){
		C.webview_set_title(webview, &char(title.str))
	}, voidptr(0))
}

pub fn (webview Webview_t) set_size (width int, height int){
	C.webview_dispatch(webview, fn [width, height](webview Webview_t, void voidptr){
		C.webview_set_size(webview, width, height, C.WEBVIEW_HINT_NONE)
	}, voidptr(0))
}

pub fn (webview Webview_t) set_html (html string){
	C.webview_dispatch(webview, fn [html](webview Webview_t, void voidptr){
		C.webview_set_html(webview, &char(html.str))
	}, voidptr(0))
}

pub fn (webview Webview_t) navigate (url string) {
	C.webview_dispatch(webview, fn [url](webview Webview_t, void voidptr){
		C.webview_navigate(webview, &char(url.str))
	}, voidptr(0))
}

pub fn (webview Webview_t) get_window () voidptr {
	return C.webview_get_window(webview)
}

pub fn (webview Webview_t) eval(code string) {
	C.webview_dispatch(webview, fn [code](webview Webview_t, void voidptr){
		C.webview_eval(webview, &char(code.str))
	}, voidptr(0))
}

pub fn (webview Webview_t) load_html_file (file string){
	webview.navigate("file://"+os.abs_path(file))
}

pub fn (webview Webview_t) bind (func_name string, func fn(&char, &char, mut &voidptr), mut app_data voidptr){
	C.webview_bind(webview, &char(func_name.str), func, mut app_data)
}

pub fn (webview Webview_t) unbind (func_name string){
	C.webview_unbind(webview, &char(func_name.str))
}

pub fn (webview Webview_t) rturn (seq &char, the_string string){ //this is not a typo: return is reserved keyword by V.
	C.webview_return(webview, seq, 0, &char(the_string.str))
}

pub fn (webview Webview_t) init (code string){
	C.webview_init(webview, &char(code.str))
}
