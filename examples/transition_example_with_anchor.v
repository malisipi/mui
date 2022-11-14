import malisipi.mui as m

fn move_image(event_details m.EventDetails,mut app &m.Window, mut app_data voidptr){
	unsafe{
		go m.move_object(mut app, "image", ["# 25", "10%y +25"], 5)
	}
}

mut app:=m.create(m.WindowConfig{ title:"Transition With Anchor - MUI Example", height:600, width:600 })

app.image(id:"image", x:"5%x +15", y:"# 25", height:100, width:100, path:"v-logo.png")
app.button(id:"move", x:30, y:30, height:30, width:70, text:"Move", onclick:move_image)

app.run()
