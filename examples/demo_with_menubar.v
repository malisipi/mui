import malisipi.mui as m

const (
	countries=["United States","Canada","United Kingdom", "Australia"]
)

[unsafe]
fn add_user(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	unsafe{
		if app.get_object_by_id("progress")[0]["perc"].num<100{
			app.get_object_by_id("table")[0]["h_raw"].str=(app.get_object_by_id("table")[0]["h_raw"].str.int()+30).str()
			app.get_object_by_id("progress")[0]["perc"].num=app.get_object_by_id("progress")[0]["perc"].num+10
			app.get_object_by_id("table")[0]["table"].tbl << [
				app.get_object_by_id("name")[0]["text"].str,
				app.get_object_by_id("last_name")[0]["text"].str,
				app.get_object_by_id("age")[0]["text"].str,
				countries[app.get_object_by_id("country")[0]["s"].num],
			]
			m.messagebox("MUI Demo","Successfully Completed.","ok","info")
			app.clear_values(["name","last_name","age","password","online_reg","subscribe","country"])
		} else {
			m.messagebox("MUI Demo","Reached Max User Count","ok","warning")
		}
	}
}

fn about_dialog(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	m.messagebox("MUI Demo","A User System Created for MUI Examples","ok","info")
}

mut app:=m.create(m.WindowConfig{ title:"MUI Demo",
	menubar: [
		{"text":m.WindowData{str:"Edit"}, "items":m.WindowData{lst:[
			{"text":m.WindowData{str:"Add User"}, "fn": m.WindowData{fun:add_user}}
		]}},
		{"text":m.WindowData{str:"About"}, "items":m.WindowData{lst:[
			{"text":m.WindowData{str:"About"}, "fn": m.WindowData{fun:about_dialog}},
			{"text":m.WindowData{str:"About MUI"}, "fn": m.WindowData{fun:m.about_dialog}}
		]}},
	] })

app.rect(m.Widget{ id:"back", x:"# 0", y:"# 0", width:"100%x -300", height:"100%y", background:app.color_scheme[1], z_index:-1 })

app.textbox(m.Widget{ id:"name", placeholder:"First Name", x:30, y:30, width: 240})
app.textbox(m.Widget{ id:"last_name", placeholder:"Last Name", x:30, y:60, width: 240})
app.textbox(m.Widget{ id:"age", placeholder:"Age", x:30, y:90, width: 240})
app.password(m.Widget{ id:"password", placeholder:"Password", x:30, y:120, width: 240})
app.checkbox(m.Widget{ id:"online_reg", x:30, y:150, width:20, text:"Online registration"})
app.checkbox(m.Widget{ id:"subscribe", x:30, y:180, width:20, text:"Subscribe to the newsletter"})
app.group(m.Widget{ id:"country_group", x:20, y:210, height:140, width:240, text:"Country", z_index:-1 })
app.radio(m.Widget{ id:"country", x:40, y:235, height:20, list:countries})
app.button(m.Widget{ id:"button", x: 30, y:"# 60", text:"Add User" onclick:add_user})
app.progress(m.Widget{ id:"progress", x:30, y:"# 30", width: 240, percent:20 })

app.table(m.Widget{ id:"table", table:[["Sam","Johnson","29","United States"],["Kate","Williams","26","Canada"]] x:"330", y:"30", width:"100%x -360", height:"60" })

app.image(m.Widget{ id:"vlogo", x: "# 0", y:"# 0", path:"v-logo.png", width:128, height:128})

app.sort_widgets_with_zindex()

app.run()
