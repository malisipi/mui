import malisipi.mui as m
import malisipi.mui.mwm

/* define app data */
struct AppData {
mut:
	wm	mwm.MuiWindowManager
}

/* define button handler */
fn button_handler(event_details m.EventDetails, mut active_window &m.Window, mut app AppData){
	unsafe {
		if app.wm.active_ui=="logon_ui" {
			app.wm.active_ui = "main_page"
			app.wm.uis["main_page"].get_object_by_id("username")[0]["text"].str = "Your username: " + active_window.get_object_by_id("username")[0]["text"].str.replace("\0","")
			app.wm.uis["main_page"].get_object_by_id("password")[0]["text"].str = "Your password: " + active_window.get_object_by_id("password")[0]["text"].str.replace("\0","")
		} else {
			app.wm.active_ui = "logon_ui"
		}
		active_window.destroy()
	}
}

/* fn main() */
/* create appdata*/
mut app := AppData{
	wm: mwm.new_window_manager()
}
app.wm.active_ui = "logon_ui"

/* logon ui */
mut logon_ui := m.create(title:"Logon UI (MWM) - MUI Example", height:150, width:400, app_data: &app)

logon_ui.textbox(id:"username", x:"5%x", y:"5%y", width:"90%x", height:"30%y" placeholder:"Enter your username")
logon_ui.password(id:"password", x:"5%x", y:"35%y", width:"90%x", height:"30%y" placeholder:"Enter your password")
logon_ui.button(id:"login", x:"5%x", y:"65%y", width:"90%x", height:"30%y", text:"Log in", onclick: button_handler)

app.wm.uis["logon_ui"] = logon_ui

/* main page */
mut main_page := m.create(title:"Main Page (MWM) - MUI Example", height:150, width:400, app_data: &app)

main_page.label(id:"username", x:"5%x", y:"5%y", width:"90%x", height:"30%y")
main_page.label(id:"password", x:"5%x", y:"35%y", width:"90%x", height:"30%y")
main_page.button(id:"logout", x:"5%x", y:"65%y", width:"90%x", height:"30%y", text:"Log out", onclick: button_handler)

app.wm.uis["main_page"] = main_page

/* start multi-window manager (mwm) */
app.wm.run()
