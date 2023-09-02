module mui

import mfb as gg
import gx

[autofree_bug; manualfree]
pub fn add_group(mut app &Window, id string, text string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, frame string, zindex int){
    app.objects << {
        "type": WindowData{str:"group"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
        "text": WindowData{str:text}
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
        "fg":   WindowData{clr:fg},
    }
}

[unsafe]
fn draw_group(app &Window, object map[string]WindowData){
	unsafe{
		text_width, text_height:=app.gg.text_size(object["text"].str)
		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
		app.gg.draw_rounded_rect_empty(object["x"].num+10, object["y"].num+10, object["w"].num-20, object["h"].num-20, app.round_corners, object["bfg"].clr)
		app.gg.draw_rect_filled(object["x"].num+20, object["y"].num, text_width+4, 20, object["bg"].clr)

		app.gg.draw_text(object["x"].num+22, object["y"].num+text_height/2+2, object["text"].str, gx.TextCfg{
			color: object["fg"].clr
			size: 20
			align: .left
			vertical_align: .middle
		})
	}
}
