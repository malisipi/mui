import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Resize Event - MUI Examples",
    resized_fn: fn (e m.EventDetails, mut app &m.Window, mut a voidptr){
        m.messagebox("You resized the window!",e.value,"ok","info")
    }
})

app.run()
