import malisipi.mui as m
import custom_widget

mut app:=m.create(m.WindowConfig{ title:"Counter - MUI Example", height:100, width:400 })

custom_widget.load_into_app(mut app)

custom_widget.new(mut app, m.Widget{ id:"custom_button", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"Custom Widget" })

app.run()
