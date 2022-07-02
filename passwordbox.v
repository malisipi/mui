module mui

import gg
import gx

pub fn add_password(mut app &Window, text string, hider_char string, id string, placeholder string, x string|int, y string|int, w string|int, h string|int, hi bool, bg gx.Color,  bfg gx.Color, fg gx.Color,  fnchg OnEvent){
    app.objects << {
        "type": WindowData{str:"password"},
        "id":   WindowData{str:id},
        "text": WindowData{str:text+"\0"},
		"ph":	WindowData{str:placeholder},
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
        "hc":	WindowData{str:hider_char},
        "fnchg":WindowData{fun:fnchg}
    }
}

[unsafe]
fn draw_password(app &Window, object map[string]WindowData){
	unsafe{
		mut hidden_text:=""
		for _ in 0..object["text"].str.split("\0")[0].runes().len{
			hidden_text+=object["hc"].str
		}
		hidden_text+="\0"
		for _ in 0..object["text"].str.split("\0")[1].runes().len{
			hidden_text+=object["hc"].str
		}

		app.gg.draw_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["bg"].clr)
		app.gg.draw_rect_filled(object["x"].num+2, object["y"].num+2, object["w"].num-4, object["h"].num-4, object["bfg"].clr)

		if app.focus!=object["id"].str{
			app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num/2, hidden_text.replace("\0",""), gx.TextCfg{
				color: object["fg"].clr
				size: 20
				align: .left
				vertical_align: .middle
			})
		} else {
			app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num/2, hidden_text.replace("\0",text_cursor), gx.TextCfg{
				color: object["fg"].clr
				size: 20
				align: .left
				vertical_align: .middle
			})
		}

		if object["text"].str.len<2{
			app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num/2, "  "+object["ph"].str, gx.TextCfg{
				color: object["bg"].clr
				size: 20
				align: .left
				vertical_align: .middle
			})
		}
	}
}
