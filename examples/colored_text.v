import malisipi.mui as m
import gx

mut app:=m.create(m.WindowConfig{ title:"Messagebox - MUI Examples", width:400, height:300, color:m.theme_light })

app.label(id:"text", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"This is yellow text")
unsafe {
	app.get_object_by_id("text")[0]["fg"].clr=gx.Color{r:255, g:255, b:0}
}

app.run()
