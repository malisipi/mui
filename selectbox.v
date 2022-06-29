module mui

import gg
import gx

pub fn add_selectbox(mut app &Window, text string, list []string, selected int, id string, x string|int, y string|int, w string|int, h string|int, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent){
    app.objects << {
        "type": WindowData{str:"selectbox"},
        "id":   WindowData{str:id}
        "text": WindowData{str:if text==""{ list[selected] } else { text }},
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
		"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
		"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
		"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
		"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "bg":   WindowData{clr:bg},
        "bfg":  WindowData{clr:bfg},
        "fg":   WindowData{clr:fg}
        "list":	WindowData{str:list.join("\0")}
        "s":	WindowData{num:if text==""{ selected } else { -1 }}
        "hi":	WindowData{bol:hi}
        "fnchg":WindowData{fun:fnchg}
    }
}

[unsafe]
fn draw_selectbox(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["bg"].clr)
		app.gg.draw_rect_filled(object["x"].num+2, object["y"].num+2, object["w"].num-4, object["h"].num-4, object["bfg"].clr)

		app.gg.draw_triangle_filled(
			object["x"].num+object["w"].num-16, object["y"].num+object["h"].num/2-5,
			object["x"].num+object["w"].num-6 , object["y"].num+object["h"].num/2-5,
			object["x"].num+object["w"].num-11, object["y"].num+object["h"].num/2+5,
			object["fg"].clr)

		app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
			color: object["fg"].clr
			size: 20
			align: .center
			vertical_align: .middle
		})

		if app.focus==object["id"].str {
			for which_item, item in object["list"].str.split("\0"){
				app.gg.draw_rect_filled(object["x"].num, object["y"].num+object["h"].num*(which_item+1), object["w"].num, object["h"].num, object["bg"].clr)
				app.gg.draw_rect_filled(object["x"].num+2, object["y"].num+2+object["h"].num*(which_item+1), object["w"].num-4, object["h"].num-4, object["bfg"].clr)
				app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+object["h"].num/2+object["h"].num*(which_item+1), item, gx.TextCfg{
					color: object["fg"].clr
					size: 20
					align: .center
					vertical_align: .middle
				})
			}
		}
	}
}
