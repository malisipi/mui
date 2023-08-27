import malisipi.mui as m
import gx

fn change_color(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	unsafe {
		if event_details.trigger == "keyboard" { return }
		app.get_object_by_id(event_details.target_id)[0]["bg"].clr = gx.Color {r: 255, g:0, b:0}
	}
}

fn set_original_color(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	unsafe {
		app.get_object_by_id(event_details.target_id)[0]["bg"].clr = app.color_scheme[1]
	}
}

mut app:=m.create(title: "Changing background of Button", width: 290, height: 120)
app.button(id:"button", x: 20, y:20, width: 250 text:"I'mma button" onclick: change_color, onunclick: set_original_color)
app.button(id:"button2", x: 20, y:80, width: 250 text:"I'mma second button" onclick: change_color, onunclick: set_original_color)

app.run()
