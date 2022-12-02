import malisipi.mui as m

mut app := m.create(m.WindowConfig{title: "Custom Background - MUI Example", color: [200,200,0], background:[255,255,255], height:400, width:600})

app.label(m.Widget{ id:"text", x:"10%x", y:"50", width:"80%x", height:"50" text:"Example Text" })
app.button(m.Widget{ id:"button", x:"10%x", y:"110", width:"80%x", height:"50", text:"Example Button" })

app.run()