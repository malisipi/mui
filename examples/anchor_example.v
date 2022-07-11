import malisipi.mui as m

fn main(){

	mut app:=m.create(m.WindowConfig{ title:"MUI", font:"roboto.ttf" })
	app.rect(m.Widget{ id:"rect", x:"10%x", y:"10%y", width:"30%x", height:"30%y" })
	app.rect(m.Widget{ id:"rect", x:"# 10%x", y:"10%y", width:"30%x", height:"30%y" })
	app.rect(m.Widget{ id:"rect", x:"10%x", y:"# 10%y", width:"30%x", height:"30%y" })
	app.rect(m.Widget{ id:"rect", x:"# 10%x", y:"# 10%y", width:"30%x", height:"30%y" })
	app.run()

}
