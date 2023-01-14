import malisipi.mui.webview
import malisipi.mui as m
import json

struct AppData {
mut:
	web			webview.Webview_t
	wv_state	bool
}

fn call_v(seq &char, req &char, mut app_data &AppData) {
	unsafe {
		args:=json.decode([]string,req.vstring())or{return}
		println(args)
		if args==["Unbind"] {
			app_data.web.unbind("call_v")
		}
		app_data.web.rturn(seq, json.encode("Hello World"))
	}
}

fn webview_runner(mut app_data AppData){
	app_data.web=webview.create(1)
	app_data.web.set_title("Title")
	app_data.web.set_size(800, 600)
	app_data.web.load_html_file("./www/index.html")
	app_data.web.bind("call_v", call_v, mut app_data)
	app_data.web.init("alert('This code will work at the initialization of the new page');")
	app_data.web.run()
	app_data.web.destroy()
	app_data.wv_state=false
}

fn eval_code(event_details m.EventDetails,mut app &m.Window, mut app_data AppData){
	if app_data.wv_state {
		app_data.web.eval("alert('The location was visited: '+location.href);")
	} else {
		m.messagebox("Heyyy!", "You should start webview before", "ok", "warning")
	}
}

fn start_webview(event_details m.EventDetails,mut app &m.Window, mut app_data AppData){
	if app_data.wv_state==false {
		app_data.wv_state=true
		go webview_runner(mut &app_data)
	} else {
		m.messagebox("Heyyy!", "Multiple webview is not possible for now", "ok", "warning")
	}
}

mut app:=m.create(m.WindowConfig{ title:"Webview - MUI Example", height:200, width:400, app_data:&AppData{} })

app.button(m.Widget{ id:"start_webview", x:"5%x", y:"5%y", width:"90%x", height:"45%y", text:"Start Webview", onclick:start_webview })
app.button(m.Widget{ id:"eval_code", x:"5%x", y:"50%y", width:"90%x", height:"45%y", text:"Eval Code", onclick:eval_code })

app.run()
