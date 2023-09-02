[translated]
module main

import malisipi.mui
import json
import mfb as gg

__global (
	event_init mui.OnEvent
	event_quit mui.OnEvent
	event_onclick mui.OnEvent
	event_onchange mui.OnEvent
	event_onunclick mui.OnEvent
	event_onresize mui.OnEvent
)

type IntString = int | string

fn C._vinit(int, &&char)

[export: "mui_v_init"]
fn mui_init(argc int, argv &&char){
	C._vinit(argc, argv)
	mui_clear_registered_events()
}

[export: "mui_get_null_object"]
fn mui_get_null_object() &map[string]mui.WindowData {
	return &mui.null_object
}

[export: "mui_create"]
fn mui_create(pconf &char, app_data voidptr) &mui.Window {
	unsafe {
		jconf := json.decode(map[string]IntString, pconf.vstring()) or {println("Crashed -> json") exit(0)}
		mut wconf := mui.WindowConfig{app_data: app_data, draw_mode:.system_native, init_fn: event_init, quit_fn: event_quit, resized_fn: event_onresize}
		if jconf["title"].type_name() == "string" { wconf.title = jconf["title"] as string }
		if jconf["width"].type_name() == "int" { wconf.width = jconf["width"] as int }
		if jconf["height"].type_name() == "int" { wconf.height = jconf["height"] as int }
		return mui.create(wconf)
	}
}

[export: "mui_set_object_property_char"]
fn mui_set_object_property_char(mut window &mui.Window, object &map[string]mui.WindowData, property &char, value &char){
	unsafe {
		v_property := property.vstring()
		v_value := value.vstring()
		match v_property {
			"path" {
				object["image"] = mui.WindowData{img: window.gg.create_image(v_value.clone()) or { gg.Image{} }}
			} else {
				object[property.vstring()] = mui.WindowData{str: v_value.clone()}
			}
		}
	}
}

[export: "mui_set_object_property_int"]
fn mui_set_object_property_int(mut window &mui.Window, object &map[string]mui.WindowData, property &char, value int){
	unsafe {
		object[property.vstring()] = mui.WindowData{num: value}
	}
}

[export: "mui_set_object_property_bool"]
fn mui_set_object_property_bool(mut window &mui.Window, object &map[string]mui.WindowData, property &char, value bool){
	unsafe {
		object[property.vstring()] = mui.WindowData{bol: value}
	}
}

[export: "mui_get_object_property_char"]
fn mui_get_object_property_char(mut window &mui.Window, object &map[string]mui.WindowData, property &char, value &char) &char {
	unsafe {
		v_property := property.vstring()
		match v_property {
			"path" {
				return c""
			} else {
				return &char(object[v_property].str.str)
			}
		}
	}
}

[export: "mui_get_object_property_int"]
fn mui_get_object_property_int(mut window &mui.Window, object &map[string]mui.WindowData, property &char, value int) int {
	unsafe {
		return object[property.vstring()].num
	}
}

[export: "mui_get_object_property_bool"]
fn mui_get_object_property_bool(mut window &mui.Window, object &map[string]mui.WindowData, property &char, value bool) bool {
	unsafe {
		return object[property.vstring()].bol
	}
}

fn mui_widget(_type string, mut window &mui.Window, pconf &char, connected_object &map[string]mui.WindowData){
	unsafe {
		jconf := json.decode(map[string]IntString, pconf.vstring()) or {println("Crashed -> json") exit(0)}
		mut wconf := mui.Widget{}

		if jconf["id"].type_name() == "string" { wconf.id = jconf["id"] as string }
		if jconf["x"].type_name() == "string" { wconf.x = jconf["x"] as string }
		if jconf["y"].type_name() == "string" { wconf.y = jconf["y"] as string }
		if jconf["width"].type_name() == "string" { wconf.width = jconf["width"] as string }
		if jconf["height"].type_name() == "string" { wconf.height = jconf["height"] as string }
		if jconf["text"].type_name() == "string" { wconf.text = jconf["text"] as string }
		if jconf["vertical"].type_name() == "string" { wconf.vertical = (jconf["vertical"] as string) == "true" }
		if jconf["icon"].type_name() == "string" { wconf.icon = (jconf["icon"] as string) == "true" }
		if jconf["path"].type_name() == "string" { wconf.path = jconf["path"] as string }
		if jconf["link"].type_name() == "string" { wconf.link = jconf["link"] as string }
		if jconf["codefield"].type_name() == "string" { wconf.codefield = (jconf["codefield"] as string) == "true" }
		wconf.onclick = event_onclick
		wconf.onchange = event_onchange
		wconf.onunclick = event_onunclick
		mui_clear_registered_events()
		if _type=="scrollbar" {
			wconf.connected_widget = connected_object
		}

		match _type {
			"button" {
				window.button(wconf)
			} "label" {
				window.label(wconf)
			} "textbox" {
				window.textbox(wconf)
			} "textarea" {
				window.textarea(wconf)
			} "password" {
				window.password(wconf)
			} "scrollbar" {
				window.scrollbar(wconf)
			} "slider" {
				window.slider(wconf)
			} "image" {
				window.image(wconf)
			} "link" {
				window.link(wconf)
			} "checkbox" {
				window.checkbox(wconf)
			} "switch" {
				window.switch(wconf)
			} else {
				println(":: Invalid/Unsupported widget type -> ${_type}")
			}
		}

	}
}

[export: "mui_button"]
fn mui_button(mut window &mui.Window, pconf &char){
	mui_widget("button", mut window, pconf, &mui.null_object)
}

[export: "mui_label"]
fn mui_label(mut window &mui.Window, pconf &char){
	mui_widget("label", mut window, pconf, &mui.null_object)
}

[export: "mui_checkbox"]
fn mui_checkbox(mut window &mui.Window, pconf &char){
	mui_widget("checkbox", mut window, pconf, &mui.null_object)
}

[export: "mui_switch"]
fn mui_switch(mut window &mui.Window, pconf &char){
	mui_widget("switch", mut window, pconf, &mui.null_object)
}

[export: "mui_textbox"]
fn mui_textbox(mut window &mui.Window, pconf &char){
	mui_widget("textbox", mut window, pconf, &mui.null_object)
}

[export: "mui_textarea"]
fn mui_textarea(mut window &mui.Window, pconf &char){
	mui_widget("textarea", mut window, pconf, &mui.null_object)
}

[export: "mui_password"]
fn mui_password(mut window &mui.Window, pconf &char){
	mui_widget("password", mut window, pconf, &mui.null_object)
}

[export: "mui_link"]
fn mui_link(mut window &mui.Window, pconf &char){
	mui_widget("link", mut window, pconf, &mui.null_object)
}

[export: "mui_image"]
fn mui_image(mut window &mui.Window, pconf &char){
	mui_widget("image", mut window, pconf, &mui.null_object)
}

[export: "mui_scrollbar"]
fn mui_scrollbar(mut window &mui.Window, pconf &char, connected_object &map[string]mui.WindowData){
	mui_widget("scrollbar", mut window, pconf, connected_object)
}

[export: "mui_slider"]
fn mui_slider(mut window &mui.Window, pconf &char){
	mui_widget("slider", mut window, pconf, &mui.null_object)
}

[export: "mui_get_object_by_id"]
fn mui_get_object_by_id(mut window &mui.Window, id &char) voidptr {
	unsafe {
		return &window.get_object_by_id(id.vstring())[0]
	}
}

pub struct ParsedEventDetails{
pub mut:
	event			&char		// click, value_change, unclick, keypress, files_drop, resize
	trigger			&char		// mouse_left, mouse_right, mouse_middle, keyboard
	value			&char		= c"true"
	target_type		&char		= c"window" //window, menubar, and widget_types
	target_id		&char		= c""
}

[export: "mui_parse_event_details"]
fn mui_parse_event_details(event_details mui.EventDetails) ParsedEventDetails {
	return ParsedEventDetails {
		event: &char(event_details.event.str)
		trigger: &char(event_details.trigger.str)
		value: &char(event_details.value.str)
		target_type: &char(event_details.target_type.str)
		target_id: &char(event_details.target_id.str)
	}
}

[export: "mui_run"]
fn mui_run(mut window &mui.Window){
	window.run()
}

[export: "mui_messagebox"]
fn mui_messagebox(title &char, message &char, _type &char, icon &char) int {
	unsafe {
		return mui.messagebox(
			title.vstring(),
			message.vstring(),
			_type.vstring(),
			icon.vstring()
		)
	}
	return 0
}

[export: "mui_openfiledialog"]
fn mui_openfiledialog(title &char) &char {
	unsafe {
		return &char(mui.openfiledialog(title.vstring()).str)
	}
	return c""
}

[export: "mui_savefiledialog"]
fn mui_savefiledialog(title &char) &char {
	unsafe {
		return &char(mui.savefiledialog(title.vstring()).str)
	}
	return c""
}

[export: "mui_selectfolderdialog"]
fn mui_selectfolderdialog(title &char) &char {
	unsafe {
		return &char(mui.selectfolderdialog(title.vstring()).str)
	}
	return c""
}

[export: "mui_inputbox"]
fn mui_inputbox(title &char, text &char, default_text &char) &char {
	unsafe {
		return &char(mui.inputbox(
			title.vstring(),
			text.vstring(),
			default_text.vstring()
		).str)
	}
	return c""
}

[export: "mui_beep"]
fn mui_beep(){
	mui.beep()
}

[export: "mui_destroy"]
fn mui_destroy(mut window &mui.Window){
	window.destroy()
}

[export: "mui_register_fn"]
fn mui_register_fn(typ &char, evt mui.OnEvent){
	unsafe {
		_type := typ.vstring()
		match _type {
			"init" {
				event_init = evt
			} "quit" {
				event_quit = evt
			} "click" {
				event_onclick = evt
			} "unclick" {
				event_onunclick = evt
			} "change" {
				event_onchange = evt
			} "resize" {
				event_onresize = evt
			} else {
				println(":: Unsupported Event Type -> ${_type}")
			}
		}
	}
}

fn mui_clear_registered_events(){
	event_init = mui.empty_fn
	event_quit = mui.empty_fn
	event_onclick = mui.empty_fn
	event_onunclick = mui.empty_fn
	event_onchange = mui.empty_fn
	event_onresize = mui.empty_fn
}