import malisipi.mui as m

const(
	buttons = ["🖊️", "💾", "📀", "📷", "⌨️", "💳", "🔋", "🔑"]
)

fn click_handler(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	m.messagebox(
		"You clicked a button",
		"You clicked a button that have the " + buttons[event_details.target_id.replace("tool_","").int()] + " emoji.",
		"ok",
		"info"
	)
}

mut app:=m.create(m.WindowConfig{ title:"Draggable Frame - MUI Example", height:200, width:400 })

app.frame(id:"toolbox", x:25, y:25, width:50, height:125, draggable:true, click_events:false)
app.label(id:"toolbox_title", x:0, y:0, width:"100%x", height:25, text:"TB", frame: "toolbox")
app.frame(id:"toolbox_frame", x:0, y:25, width:"100%x", height:"100%y -25", draggable:false, click_events:true, frame:"toolbox")

for button_index, button in buttons {
	app.button(id:"tool_${button_index}", text:button, icon:true, x:button_index%2*25, y:(button_index/2)*25, width:25, height:25, frame:"toolbox_frame", onclick:click_handler)
}

app.run()

