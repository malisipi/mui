import malisipi.mui as m

fn do_another_process(mut app &m.Window){
    app.create_dialog(m.Modal{typ:"textbox",default_entry:"Hank Anderson",title:"What is your name?"})
    app.create_dialog(m.Modal{typ:"password",default_entry:app.wait_and_get_answer(),title:"What is your name? (Again)"})
    app.create_dialog(m.Modal{typ:"color",default_entry:"#229977",title:app.wait_and_get_answer()})
	app.create_dialog(m.Modal{typ:"messagebox",message:"Hello, "+app.wait_and_get_answer(),title:"Hi!"})
    print(app.wait_and_get_answer())
}

fn run_dialog(event_details m.EventDetails,mut app &m.Window, app_data voidptr){
	go do_another_process(mut app)
}

mut app:=m.create(m.WindowConfig{ title:"Built-in Dialogs - MUI Example", height:600, width:300 })

app.button(m.Widget{ id:"button", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"Hello", onclick:run_dialog })

app.run()

