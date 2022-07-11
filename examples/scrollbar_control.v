import malisipi.mui as m

mut app:=m.create(m.WindowConfig{title:"Scrollbar Test - MUI Examples", width:400, height:400, view_area:[600,600], scrollbar:true})

app.rect(m.Widget{ id:"test", x: "0", y:"0", width:600, height:600})

app.run()
