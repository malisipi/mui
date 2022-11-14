import malisipi.mui as m
import rand

fn move_image(event_details m.EventDetails,mut app &m.Window, mut app_data voidptr){
	unsafe{
		go m.move_object(mut app, "image", [rand.int_in_range(0,500) or {0},rand.int_in_range(0,500) or {0}], 1)
	}
}

mut app:=m.create(m.WindowConfig{ title:"Transition - MUI Example", height:600, width:600 })

app.image(id:"image", x:300, y:300, height:100, width:100, path:"v-logo.png")
app.button(id:"move", x:30, y:30, height:30, width:70, text:"Move", onclick:move_image)

app.run()
