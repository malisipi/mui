import malisipi.mui as m

const countries=["United States","Canada","United Kingdom", "Australia"]

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

fn selected_user(event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){
	unsafe {
		the_user := app.get_object_by_id("table")[0]["table"].tbl[event_details.value.int()]
		for i in 0..4 {
			app.get_object_by_id("selected_"+["name","lastname","age","country"][i])[0]["text"].str = ["Name:","Last Name:","Age:","Country:"][i] + " " + the_user[i]
		}
	}
}

mut app:=m.create(m.WindowConfig{ title:"MUI Demo"})

app.rect(m.Widget{ id:"back", x:"# 0", y:"# 0", width:"100%x -300", height:"100%y", background:app.color_scheme[1], z_index: -5})

app.textbox(id:"name", placeholder:"First Name", x:30, y:30, width: 240)
app.textbox(id:"last_name", placeholder:"Last Name", x:30, y:60, width: 240)
app.textbox(id:"age", placeholder:"Age", x:30, y:90, width: 240)
app.password(id:"password", placeholder:"Password", x:30, y:120, width: 240)
app.checkbox(id:"online_reg", x:30, y:150, width:20, text:"Online registration")
app.checkbox(id:"subscribe", x:30, y:180, width:20, text:"Subscribe to the newsletter")
app.group(id:"country_group", x:20, y:210, height:140, width:240, text:"Country" )
app.radio(id:"country", x:40, y:235, height:20, list:countries)
app.button(id:"button", x: 30, y:"# 60", text:"Add User" onclick:add_user)
app.progress(id:"progress", x:30, y:"# 30", width: 240, percent:20)

app.list(id:"table", table:[["Sam","Johnson","29","United States"],["Kate","Williams","26","Canada"]] x:"330", y:"30", width:"100%x -360", height:"60", onchange: selected_user)

app.rect(id:"back2", x:"# 10", y:"# 10", width:"100%x -320", height:"100", background:app.color_scheme[0])

app.label(id:"selected_name", x:"# 10", y:"# 85", width:"100%x -320", height:"25", text:"Name:", text_align:0)
app.label(id:"selected_lastname", x:"# 10", y:"# 60", width:"100%x -320", height:"25", text:"Last Name:", text_align:0)
app.label(id:"selected_age", x:"# 10", y:"# 35", width:"100%x -320", height:"25", text:"Age:", text_align:0)
app.label(id:"selected_country", x:"# 10", y:"# 10", width:"100%x -320", height:"25", text:"Country:", text_align:0)

app.run()
