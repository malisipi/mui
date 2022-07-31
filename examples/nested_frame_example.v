import malisipi.mui as m
import gx

mut app:=m.create(m.WindowConfig{ title:"Nested Frame - MUI Example", height:500, width:500, scrollbar:true, view_area:[1000,1000] })

app.frame(m.Widget{ id:"f1", x:"5%x", y:"5%y", width:"90%x", height:"90%y", background: gx.Color{r: 0, g: 255, b: 0}})
app.frame(m.Widget{ id:"f2", x:"5%x", y:"25%y", width:"50%x", height:"50%y", frame:"f1" background: gx.Color{r: 0, g: 0, b: 255} })
app.image(m.Widget{ id:"vlogo", x: "20%x", y:"#10%y", width:"80%x", height:"60%y", frame:"f2" path:"v-logo--black.png"})

app.run()

