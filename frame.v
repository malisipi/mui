module mui

import gg
import gx

pub fn add_frame(mut app &Window, id string, x string|int, y string|int, w string|int, h string|int, hi bool, bg gx.Color, dialog bool, frame string){
    widget:= {
        "type": WindowData{str:"rect"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
		"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
		"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
		"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
		"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "hi":	WindowData{bol:hi},
        "bg":   WindowData{clr:bg},
    }
    if dialog {app.dialog_objects << widget.clone()} else {app.objects << widget.clone()}
}

[unsafe]
fn draw_frame(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["bg"].clr)
	}
}

