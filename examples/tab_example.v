import malisipi.mui as m

fn increase_count(event_details m.EventDetails,mut app &m.Window, app_data voidptr){
	unsafe{
		app.get_object_by_id("count")[0]["text"].str=(app.get_object_by_id("count")[0]["text"].str.int()+1).str()
	}
}

mut app:=m.create(m.WindowConfig{ title:"Tabbed View - MUI Example", height:100, width:400 })

unsafe {
	app.tab_view(m.Widget{ id:"tab_view", x:"5%x", y:"5%y", width:"90%x", height:"90%y", active_tab:"frame_count_label", tabs:[
		["Label","frame_count_label"],
		["Button","frame_count_button"]
	]})
}
app.label(m.Widget{ id:"count", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"0", frame:"frame_count_label" })
app.button(m.Widget{ id:"count_button", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"Count", onclick:increase_count, frame:"frame_count_button" })

app.run()
