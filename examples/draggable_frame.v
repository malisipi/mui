import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Frame - MUI Example", height:400, width:400 })

app.frame(id:"f1", x:"5%x", y:"5%y", width:300, height:300, draggable:true)
app.textbox(id:"username", x:0, y:0, text:"Hello", frame:"f1")
//app.image(id:"vlogo", x: "0", y:"0", width:"100%x", height:"100%y", frame:"f1" path:"v-logo--black.png")

app.run()

