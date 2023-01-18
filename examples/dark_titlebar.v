import malisipi.mui as m
import malisipi.mui.window as w
import time

fn add_user(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	async_fn := fn [mut app] (){
		w.prefer_dark_titlebar(app.window_handle(), true)
		time.sleep(time.second * 2)
		w.prefer_dark_titlebar(app.window_handle(), false)
	}
	go async_fn()
}

mut app:=m.create(title: "Dark Titlebar")

app.button(id:"button", x: 20, y:20, width: 250 text:"Use dark titlebar" onclick:add_user)

app.run()
