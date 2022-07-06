import malisipi.mui as m

fn change_type(event_details m.EventDetails, mut app &m.Window, app_data voidptr){
    unsafe{
        if app.get_object_by_id("widget")[0]["type"].str=="password"{
            app.get_object_by_id("widget")[0]["type"].str="textbox"
        } else {
            app.get_object_by_id("widget")[0]["type"].str="password"
        }
    }
}

mut app:=m.create(m.WindowConfig{ title:"Change Type - MUI Example", width:165, height:60, color:m.theme_light})
app.password(m.Widget{ id:"widget", x:"20", y:"20", onchange:change_type })
m.run(mut app)
