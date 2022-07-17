import malisipi.mui as m
import custom_widget

mut app:=m.create(m.WindowConfig{ title:"Counter - MUI Example", height:100, width:400 })

custom_widget.load_my_custom_widget_into_app(mut app)

custom_widget.my_custom_widget(mut app, m.Widget{ id:"count_button", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"Custom Widget" })

app.run()
