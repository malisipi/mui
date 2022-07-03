module mui

[unsafe]
fn draw_focus(mut app Window){
    if app.focus!="" {
        unsafe{
            mut object:=app.get_object_by_id(app.focus)[0]
            app.gg.draw_rect_empty(object["x"].num, object["y"].num, object["w"].num+1, object["h"].num+1,app.color_scheme[3])
        }
    }
}
