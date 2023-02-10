module mui

[unsafe]
fn draw_focus(mut app Window){
    if app.focus!="" {
        unsafe{
            if !app.focus.starts_with("@menubar#"){
                if app.active_dialog=="" {
                    mut object:=app.get_object_by_id(app.focus)[0]
                    app.gg.draw_rounded_rect_empty(object["x"].num, object["y"].num, object["w"].num+1, object["h"].num+1, if app.round_corners > 0 { 2 } else { 0 }, app.color_scheme[3])
                } else {
                    mut object:=app.get_dialog_object_by_id(app.focus)[0]
                    app.gg.draw_rounded_rect_empty(object["x"].num, object["y"].num, object["w"].num+1, object["h"].num+1, if app.round_corners > 0 { 2 } else { 0 }, app.color_scheme[3])
                }
            }
        }
    }
}
