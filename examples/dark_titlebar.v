import malisipi.mui as m
import malisipi.mui.window as w
import sokol.sapp

[unsafe]
fn add_user(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	$if windows {
		w.prefer_dark_titlebar(sapp.win32_get_hwnd())
	}
}

mut app:=m.create(title: "Dark Titlebar")

app.button(id:"button", x: 20, y:20, width: 250 text:"Use dark titlebar" onclick:add_user)

app.run()
