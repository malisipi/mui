import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Quit Dialog - MUI Examples", ask_quit:true,
    quit_fn: fn (e m.EventDetails, mut app &m.Window, mut a voidptr){
        m.messagebox("Goodbye!","Bye","ok","info")
    }
})

app.run()
