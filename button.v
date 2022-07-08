module mui

import gg
import gx

pub fn add_button(mut app &Window, text string, id string, x string|int, y string|int, w string|int, h string|int, hi bool, bg gx.Color, fg gx.Color, fun OnEvent, icon bool){
    app.objects << {
        "type": WindowData{str:"button"},
        "id":   WindowData{str:id}
        "text": WindowData{str:text},
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
        "fg":   WindowData{clr:fg},
        "fn":   WindowData{fun:fun},
        "icon": WindowData{bol:icon}
    }
}

[unsafe]
fn draw_button(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["bg"].clr)
		app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
			color: object["fg"].clr
			size: 20
			align: .center
			vertical_align: .middle
			bold: object["icon"].bol
		})
	}
}
