import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Frame - MUI Example", height:400, width:400 })

app.frame(m.Widget{ id:"f1", x:"5%x", y:"5%y", width:"90%x", height:"90%y" })
app.image(m.Widget{ id:"vlogo", x: "0", y:"0", width:"100%x", height:"100%y", frame:"f1" path:"v-logo--black.png"})


app.run()

