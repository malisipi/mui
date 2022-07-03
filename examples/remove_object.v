import malisipi.mui as m

fn delete_me(event_details m.EventDetails, mut app &m.Window, app_data voidptr){
    unsafe{
        app.remove_object_by_id(event_details.target_id)
        app.focus=""
    }
}

mut app:=m.create(m.WindowConfig{ title:"Delete Object - MUI Example", width:165, height:60})
app.button(m.Widget{ id:"button", x:"20", y:"20", text:"Delete Me" onclick:delete_me })
m.run(mut app)
