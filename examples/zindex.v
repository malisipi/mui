import malisipi.mui as m

fn change_z_index(event_details m.EventDetails,mut app &m.Window, app_data voidptr){
    unsafe {
        app.get_object_by_id(event_details.target_id.replace("z_index","button"))[0]["z_ind"].num=event_details.value.int()
        app.sort_widgets_with_zindex()
    }
}

mut app:=m.create(m.WindowConfig{ title:"Z-Index - MUI Example", height:400, width:400 })

app.button(m.Widget{ id:"button_1", x:"5%x", y:"5%y", width:"65%x", height:"85%y -25" text:"I'm First Button" })
app.button(m.Widget{ id:"button_2", x:"# 5%x", y:"5%y", width:"65%x", height:"85%y -25" text:"I'm Second Button" })
app.textbox(m.Widget{ id:"z_index_1", x:"5%x", y:"# 5%y", width:"45%x", height:"25" text:"", placeholder:"Z-Index Of First Button", onchange:change_z_index })
app.textbox(m.Widget{ id:"z_index_2", x:"# 5%x", y:"# 5%y", width:"45%x", height:"25" text:"", placeholder:"Z-Index Of Second Button", onchange:change_z_index })

app.run()
