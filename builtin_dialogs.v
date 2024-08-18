module mui

import time
import gx

const dialogs_null_answer = "@mui_answer_null"
const dialogs_wait_time   = 200
const hex_chars           = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

fn dialogs_messagebox_cancel(event_details EventDetails, mut app &Window, mut app_data voidptr){
    app.clear_dialog()
    app.dialog_answer="0"
}

fn dialogs_messagebox_ok(event_details EventDetails, mut app &Window, mut app_data voidptr){
    app.clear_dialog()
    app.dialog_answer="1"
}

fn dialogs_textbox_cancel(event_details EventDetails, mut app &Window, mut app_data voidptr){
    app.clear_dialog()
    app.dialog_answer=""
}

fn dialogs_textbox_ok(event_details EventDetails, mut app &Window, mut app_data voidptr){
    unsafe {
        the_text:=app.get_dialog_object_by_id("mui__text")[0]["text"].str.replace("\0","")
        app.clear_dialog()
        app.dialog_answer=the_text
    }
}

fn dialogs_color_cancel(event_details EventDetails, mut app &Window, mut app_data voidptr){
    app.clear_dialog()
    app.dialog_answer="#000000"
}

fn dialogs_color_ok(event_details EventDetails, mut app &Window, mut app_data voidptr){
    unsafe {
        color_code:=rgb_to_color_code([ app.get_dialog_object_by_id("mui__slider__red")[0]["val"].num,
            app.get_dialog_object_by_id("mui__slider__green")[0]["val"].num,
            app.get_dialog_object_by_id("mui__slider__blue")[0]["val"].num
        ])
        app.clear_dialog()
        app.dialog_answer=color_code
    }
}

fn dialogs_color_update(event_details EventDetails, mut app &Window, mut app_data voidptr){
    unsafe {
        typ:=event_details.target_id.split("__")#[-1..][0][0..1] //mui__slider__red -> mui, slider, red -> red -> r
        match typ{
            "r" {
                app.get_dialog_object_by_id("mui__color")[0]["bg"].clr.r=u8(event_details.value.int())
            } "g" {
                app.get_dialog_object_by_id("mui__color")[0]["bg"].clr.g=u8(event_details.value.int())
            } "b" {
                app.get_dialog_object_by_id("mui__color")[0]["bg"].clr.b=u8(event_details.value.int())
            } else {}
        }
    }
}

pub fn color_code_to_rgb(color string) []int {
	return hex_to_rgb(color)
}

pub fn rgb_to_color_code(color []int) string {
    mut color_code:="#"
    for c in color {
        color_code+=hex_chars[c/16]
        color_code+=hex_chars[c%16]
    }
	return color_code
}

pub fn(mut app Window)clear_dialog(){
    app.dialog_objects=[]map[string]WindowData{}
    app.dialog_answer=dialogs_null_answer
    app.focus=""
    app.active_dialog=""
}

pub fn(mut app Window)create_dialog(dialog_data Modal){
    $if !dont_clip ? {
    	app.force_redraw = true
    }
    app.clear_dialog()
    match dialog_data.typ{
        "messagebox" {
            app.rect(Widget{ id:"mui__background", x:"10%x", y:"5%y", width:"80%x", height:"40%y", background:app.color_scheme[1], dialog:true})
            app.label(Widget{ id:"mui__title", x:"10%x", y:"5%y +5", width:"80%x", height:"25", text_size:25, text:dialog_data.title, dialog:true})
            app.label(Widget{ id:"mui__text", x:"10%x +5", y:"5%y +35", width:"80%x -10", height:"30%y -40", text:dialog_data.message, text_align:0, text_multiline:true, dialog:true})
            app.button(Widget{ id:"mui__cancel", x:"10%x", y:"# 55%y", width:"40%x", height:"10%y", text:"Cancel", dialog:true, onclick:dialogs_messagebox_cancel})
            app.button(Widget{ id:"mui__ok", x:"# 10%x", y:"# 55%y", width:"40%x", height:"10%y", text:"OK", dialog:true, onclick:dialogs_messagebox_ok})
        } "textbox","password" {
            app.rect(Widget{ id:"mui__background", x:"10%x", y:"5%y", width:"80%x", height:"40%y", background:app.color_scheme[1], dialog:true})
            app.label(Widget{ id:"mui__title", x:"10%x", y:"5%y +5", width:"80%x", height:"25", text_size:25, text:dialog_data.title, dialog:true})
            if dialog_data.typ=="textbox" {
                app.textbox(Widget{ id:"mui__text", x:"10%x +5", y:"5%y +35", width:"80%x -10", height:"40", text:dialog_data.default_entry, dialog:true})
            } else {
                app.password(Widget{ id:"mui__text", x:"10%x +5", y:"5%y +35", width:"80%x -10", height:"40", text:dialog_data.default_entry, dialog:true})
            }
            app.button(Widget{ id:"mui__cancel", x:"10%x", y:"# 55%y", width:"40%x", height:"10%y", text:"Cancel", dialog:true, onclick:dialogs_textbox_cancel})
            app.button(Widget{ id:"mui__ok", x:"# 10%x", y:"# 55%y", width:"40%x", height:"10%y", text:"OK", dialog:true, onclick:dialogs_textbox_ok})
        } "color" {
            app.rect(Widget{ id:"mui__background", x:"10%x -5", y:"5%y -5", width:"80%x +10", height:"40%y +10", background:app.color_scheme[1], dialog:true})
            the_color:=color_code_to_rgb(dialog_data.default_entry)
            app.rect(Widget{ id:"mui__background2", x:"10%x", y:"5%y", width:"80%x", height:"40%y", background:app.color_scheme[0], dialog:true})
            app.label(Widget{ id:"mui__title", x:"10%x", y:"5%y", width:"80%x", height:"20", text:dialog_data.title, dialog:true})
            app.label(Widget{ id:"mui__red", x:"10%x", y:"5%y +25", width:"20%x", height:"20", text:"RED:", dialog:true})
            app.slider(Widget{ id:"mui__slider__red", x:"30%x", y:"5%y +25", width:"60%x -50", value:the_color[0], value_max:255, height:"20", dialog:true, onclick:dialogs_color_update, onchange:dialogs_color_update, onunclick:dialogs_color_update})
            app.label(Widget{ id:"mui__green", x:"10%x", y:"5%y +50", width:"20%x", height:"20", text:"GREEN:", dialog:true})
            app.slider(Widget{ id:"mui__slider__green", x:"30%x", y:"5%y +50", width:"60%x -50", value:the_color[1], value_max:255, height:"20", dialog:true, onclick:dialogs_color_update, onchange:dialogs_color_update, onunclick:dialogs_color_update})
            app.label(Widget{ id:"mui__blue", x:"10%x", y:"5%y +75", width:"20%x", height:"20", text:"BLUE:", dialog:true})
            app.slider(Widget{ id:"mui__slider__blue", x:"30%x", y:"5%y +75", width:"60%x -50", value:the_color[2], value_max:255, height:"20", dialog:true, onclick:dialogs_color_update, onchange:dialogs_color_update, onunclick:dialogs_color_update})
            app.rect(Widget{ id:"mui__color", x:"10%x +10", y:"5%y +110", width:"80%x -20", height:"25", background:gx.Color{r:u8(the_color[0]), g:u8(the_color[1]), b:u8(the_color[2])}, dialog:true})
            app.button(Widget{ id:"mui__cancel", x:"10%x", y:"# 55%y", width:"40%x", height:"10%y", text:"Cancel", dialog:true, onclick:dialogs_color_cancel})
            app.button(Widget{ id:"mui__ok", x:"# 10%x", y:"# 55%y", width:"40%x", height:"10%y", text:"OK", dialog:true, onclick:dialogs_color_ok})
        } else {print(dialog_data.typ+" Dialog Not Implemented\n") app.clear_dialog() app.dialog_answer="" return}
    }
    app.active_dialog=dialog_data.typ
}

pub fn(mut app Window)run_dialog(){
    app.active_dialog="custom"
}

pub fn(mut app Window)wait_and_get_answer()string{
    for {
        if app.dialog_answer!=dialogs_null_answer{
            return app.dialog_answer
        }
        time.sleep(dialogs_wait_time*time.millisecond)
    }
    $if !dont_clip ? {
    	app.force_redraw = false
    	app.redraw_required = true
    }
    return ""
}
