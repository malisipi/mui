import malisipi.mui.webview
import malisipi.mui as m

struct AppData {
mut:
	does_webview_started	bool
}

fn webview_runner(){
	mut a:=C.webview_create(1, C.NULL)
	C.webview_set_title(a, c"Title")
	C.webview_set_size(a, 800, 600, C.WEBVIEW_HINT_NONE)
	C.webview_navigate(a, c"data:text/html, Hello World")
	C.webview_run(a)
	C.webview_destroy(a)
}

fn start_webview(event_details m.EventDetails,mut app &m.Window, mut app_data AppData){
	if !app_data.does_webview_started {
		app_data.does_webview_started=true
		go webview_runner()
	} else {
		m.messagebox("Heyyy!", "Multiple webview is not possible for now", "ok", "warning")
	}
}

mut app:=m.create(m.WindowConfig{ title:"Webview - MUI Example", height:100, width:400, app_data:&AppData{} })

app.button(m.Widget{ id:"count_button", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"Start Webview", onclick:start_webview })

app.run()
