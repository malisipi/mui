import malisipi.mui as m

fn change_text (mut app &m.Window) {
    unsafe {
        app.get_object_by_id("label")[0]["text"].str="The text changed!"
    }
}

mut app:=m.create(title:"Keybindings - MUI Example", height:400, width:800)

app.label(id:"label", x:"5%x", y:"5%y", width:"90%x", height:"90%y -20", text_size:20, text_align:0,
    text:"Keybindings:\n   Ctrl+P:Print Hello! to console\n   Ctrl+C:Change the text\n   Ctrl+Q:Quit application\n   Shift+A:Print Shift+A\n   Shift+Alt+T: Print Shift+Alt+T\n   Ctrl+Shift+Alt+Y: Print Combo x4",
    text_multiline:true)

app.textbox(id:"textbox", x:"5%x", y:"# 5%y", width:"90%x", height:20 text:"Chars shouldn't be show up there when you're pressing shortcuts")

unsafe {
    app.keybindings["ctrl|p"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
        print("Hello!\n")
    }

    app.keybindings["shift|a"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
        print("Shift+A\n")
    }

    app.keybindings["shift|alt|t"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
        print("Shift+Alt+T\n")
    }

    app.keybindings["ctrl|shift|alt|y"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
        print("Combo x4\n")
    }

    app.keybindings["ctrl|c"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
        change_text(mut app);
    }

    app.keybindings["ctrl|q"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
        app.destroy()
    }
}

app.run()
