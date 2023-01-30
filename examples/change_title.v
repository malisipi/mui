import malisipi.mui as m

fn change_title(event_details m.EventDetails,mut app &m.Window, mut app_data voidptr){
	app.set_title("This Is Changed Title - MUI Example")
}

mut app:=m.create(m.WindowConfig{ title:"Change Title - MUI Example", height:100, width:400 })

app.button(id:"button", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"Change Title", onclick:change_title)

app.run()
