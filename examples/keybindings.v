import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Keybindings - MUI Example", height:400, width:400 })

app.label(m.Widget{ id:"label", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text_size:20, text_align:0,
    text:"Keybindings:\n   Ctrl+P:Print Hello! to console\n   Ctrl+C:Change the text\n   Ctrl+Q:Quit application",
    text_multiline:true })

app.keybindings["ctrl|p"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){   print("Hello!\n")   }

app.keybindings["ctrl|c"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){   unsafe {
    app.get_object_by_id("label")[0]["text"].str="The text changed!"
}   }

app.keybindings["ctrl|q"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){   app.destroy()   }

app.run()
