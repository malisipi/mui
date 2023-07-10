import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Frame - MUI Example", height:600, width:600 })

app.frame(id:"f1", x:"5%x", y:"5%y", width:300, height:300, draggable:true, click_events:true)
app.textbox(id:"username", x:10, y:10, text:"Hello", frame:"f1")
app.image(id:"vlogo", x: 50, y:50, width:128, height:128, frame:"f1" path:"v-logo--black.png")

app.run()

