import malisipi.mui as m
import os

const (
    open_file_emoji="⤵"
    save_file_emoji="💾"
)

struct AppData {
mut:
    file_path       string        //=""
}

fn about_dialog(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
	m.messagebox("Notepad","A Notepad Created for MUI Examples","ok","info")
}

fn load_file(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
    mut file_path:=event_details.value
    if event_details.target_type=="menubar" || event_details.target_type=="button"{
        file_path=m.openfiledialog("Notepad")
        if file_path=="" { return }
    }
    if os.exists(file_path){
        file_text:=os.read_file(file_path) or { m.messagebox("Notepad","Unable to open `"+file_path+"`\n* You may not have read permission.","ok","error") return }
        app_data.file_path=file_path
        unsafe { app.get_object_by_id("textarea")[0]["text"].str=file_text }
    } else {
        m.messagebox("Notepad","Unable to open `"+file_path+"`\n* File not found.","ok","error")
    }
}

fn save_file(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
    if app_data.file_path!="" {
        unsafe {   os.write_file(app_data.file_path, app.get_object_by_id("textarea")[0]["text"].str.replace("\0","")) or { m.messagebox("Notepad","Unable to write `"+app_data.file_path+"`\n* You may not have write permission.","ok","error") return }   }
    } else {
        save_as_file(event_details, mut app, mut app_data)
    }
}

fn save_as_file(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
    file_path:=m.savefiledialog("Notepad")
    if file_path=="" { return }
    unsafe {   os.write_file(file_path, app.get_object_by_id("textarea")[0]["text"].str.replace("\0","")) or { m.messagebox("Notepad","Unable to write `"+file_path+"`\n* You may not have write permission.","ok","error") return }   }
}

fn change_codefield(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
    unsafe {   app.get_object_by_id("textarea")[0]["code"].bol=event_details.value=="true"   }
}

menubar:=[
    {"text":m.WindowData{str:"File"}, "items":m.WindowData{lst:[
        {"text":m.WindowData{str:"Open"}, "fn": m.WindowData{fun:load_file}}
        {"text":m.WindowData{str:"Save"}, "fn": m.WindowData{fun:save_file}}
        {"text":m.WindowData{str:"Save As"}, "fn": m.WindowData{fun:save_as_file}}
    ]}},
    {"text":m.WindowData{str:"About"}, "items":m.WindowData{lst:[
        {"text":m.WindowData{str:"About"}, "fn": m.WindowData{fun:about_dialog}},
        {"text":m.WindowData{str:"About MUI"}, "fn": m.WindowData{fun:m.about_dialog}}
    ]}},
]

mut app:=m.create(m.WindowConfig{ title:"Notepad - MUI Examples", width:400, height: 300, menubar:menubar, file_handler:load_file, ask_quit:true, app_data:&AppData{}, y_offset:25 })

app.button(m.Widget{ id:"open", x:"!& 0", y:"!& 25" width:25, height:25, text:open_file_emoji, onclick:load_file, icon:true})
app.button(m.Widget{ id:"save", x:"!& 30", y:"!& 25" width:25, height:25, text:save_file_emoji, onclick:save_file, icon:true})
app.switch(m.Widget{ id:"codefield", x:"!& 60", y:"!& 30" width:30, height:15, text:"Codefield", onchange:change_codefield})

app.textarea(m.Widget{ id:"textarea", x:0, y:0, width:"100%x", height:"100%y", placeholder:"Open/Drop a file to edit\nOr create a new file"})

app.run()
