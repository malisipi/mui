import malisipi.mui as m

fn toggle_menu(event_details m.EventDetails,mut app &m.Window, mut app_data voidptr){
	unsafe{
		if app.get_object_by_id("menu_frame")[0]["x_raw"].str.int()==0 {
            go m.move_object(mut app, "menu_frame", ["-300", "0"], 0.2)
        } else {
            go m.move_object(mut app, "menu_frame", ["0", "0"], 0.2)
        }
	}
}

fn menu_open(event_details m.EventDetails,mut app &m.Window, mut app_data voidptr){
    toggle_menu(event_details, mut app, mut app_data)
    unsafe {
        app.get_object_by_id("text")[0]["text"].str="You clicked "+app.get_object_by_id(event_details.target_id)[0]["text"].str
    }
}

mut app:=m.create(m.WindowConfig{ title:"Animated Side Menu - MUI Example", height:600, width:800 })

app.frame(m.Widget{ id:"menu_frame", x:"-300", y:"0", width:"300", height:"100%y" })
app.button(m.Widget{ id:"menu_1", x:"10", y:"60", width:"280", height:"30", text:"Welcome", icon:false, frame:"menu_frame", onclick:menu_open })
app.button(m.Widget{ id:"menu_2", x:"10", y:"90", width:"280", height:"30", text:"Edit", icon:false, frame:"menu_frame", onclick:menu_open })
app.button(m.Widget{ id:"menu_3", x:"10", y:"120", width:"280", height:"30", text:"About", icon:false, frame:"menu_frame", onclick:menu_open })
app.button(m.Widget{ id:"menu_open", x:"10", y:"10", width:"30", height:"30", text:"↩", icon:true, onclick:toggle_menu })
app.label(m.Widget{ id:"text", x:"# 10", y:"# 10", width:"300", height:"25", text_align:2 text:"" })

app.run()
