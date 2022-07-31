module mui

import gg
import gx

pub fn add_progress(mut app &Window, percent int, id string, x string|int, y string|int, w string|int, h string|int, hi bool, bg gx.Color,  bfg gx.Color, fg gx.Color, dialog bool, frame string){
    widget:={
        "type": WindowData{str:"progress"},
        "id":   WindowData{str:id}
        "in":   WindowData{str:frame},
        "perc": WindowData{num:percent},
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
        "bfg":  WindowData{clr:bfg},
        "fg":   WindowData{clr:fg}
    }
    if dialog {app.dialog_objects << widget.clone()} else {app.objects << widget.clone()}
}

[unsafe]
fn draw_progress(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["bg"].clr)
		app.gg.draw_rect_filled(object["x"].num, object["y"].num, int(f32(object["w"].num)/100*object["perc"].num), object["h"].num, object["bfg"].clr)
		app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+object["h"].num/2, object["perc"].num.str()+"%", gx.TextCfg{
			color: object["fg"].clr
			size: 20
			align: .center
			vertical_align: .middle
		})
	}
}
