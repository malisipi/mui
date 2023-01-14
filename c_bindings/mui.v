import malisipi.mui
import json

type IntString = int | string

fn C._vinit(int, &&char)

[export: "mui_init"]
fn mui_init(argc int, argv &&char){
	C._vinit(argc, argv)
}

[export: "mui_create"]
fn mui_create(pconf &char) &mui.Window {
	unsafe {
		jconf := json.decode(map[string]IntString, pconf.vstring()) or {println("Crashed -> json") exit(0)}
		mut wconf := mui.WindowConfig{}
		if jconf["title"].type_name() == "string" { wconf.title = jconf["title"] as string }
		if jconf["width"].type_name() == "int" { wconf.width = jconf["width"] as int }
		if jconf["height"].type_name() == "int" { wconf.height = jconf["height"] as int }
		return mui.create(wconf)
	}
}

[export: "mui_change_object_property"]
fn mui_change_object_property(mut window &mui.Window, id &char, pconf &char){
	unsafe {
		jconf := json.decode(map[string]string, pconf.vstring()) or {println("Crashed -> json") exit(0)}
		property := jconf["property"]
		value := jconf["value"]
		window.get_object_by_id(id.vstring())[0][property] = mui.WindowData{str: value}
	}
}

fn mui_widget(_type string, mut window &mui.Window, pconf &char, onclk mui.OnEvent){
	unsafe {
		jconf := json.decode(map[string]IntString, pconf.vstring()) or {println("Crashed -> json") exit(0)}
		mut wconf := mui.Widget{}

		if jconf["id"].type_name() == "string" { wconf.id = jconf["id"] as string }
		if jconf["x"].type_name() == "string" { wconf.x = jconf["x"] as string }
		if jconf["y"].type_name() == "string" { wconf.y = jconf["y"] as string }
		if jconf["width"].type_name() == "string" { wconf.width = jconf["width"] as string }
		if jconf["height"].type_name() == "string" { wconf.height = jconf["height"] as string }
		if jconf["text"].type_name() == "string" { wconf.text = jconf["text"] as string }
		wconf.onclick = onclk

		match _type {
			"button" {
				window.button(wconf)
			} "label" {
				window.label(wconf)
			} else {
				println(":: Invalid/Unsupported widget type")
			}
		}

	}
}

[export: "mui_button"]
fn mui_button(mut window &mui.Window, pconf &char, onclk mui.OnEvent){
	mui_widget("button", mut window, pconf, onclk)
}

[export: "mui_label"]
fn mui_label(mut window &mui.Window, pconf &char){
	mui_widget("label", mut window, pconf, mui.empty_fn)
}

[export: "mui_run"]
fn mui_run(mut window &mui.Window){
	window.run()
}
