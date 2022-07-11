import malisipi.mui as m

fn create_messagebox(event_details m.EventDetails, mut app &m.Window, app_data voidptr){
    unsafe{
        m.messagebox(
            app.get_object_by_id("title")[0]["text"].str,
            app.get_object_by_id("message")[0]["text"].str,
            app.get_object_by_id("type")[0]["text"].str,
            app.get_object_by_id("icon")[0]["text"].str
        )
    }
}

mut app:=m.create(m.WindowConfig{ title:"Messagebox - MUI Examples", width:400, height:300, color:[20,20,140] })

app.textbox(m.Widget{ id:"title", x:"5%x", y:"5%y", width:"90%x", height:"10%y", placeholder:"Title" })
app.textbox(m.Widget{ id:"message", x:"5%x", y:"20%y", width:"90%x", height:"10%y", placeholder:"Message" })
app.selectbox(m.Widget{ id:"type", x:"5%x", y:"35%y", width:"43%x", height:"10%y", list:["ok", "okcancel", "yesno", "yesnocancel"] })
app.selectbox(m.Widget{ id:"icon", x:"# 5%x", y:"35%y", width:"43%x", height:"10%y", list:["info", "warning", "error"] })
app.button(m.Widget{ id:"create", x:"5%x", y:"# 5%y", width:"90%x", height:"10%y", text:"Create", onclick:create_messagebox })

app.run()
