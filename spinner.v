module mui

import gg
import gx

pub fn add_spinner(mut app &Window, text string, id string, placeholder string, phsa bool, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color,  bfg gx.Color, fg gx.Color,  fnchg OnEvent, dialog bool, frame string, zindex int, tSize int){
    widget:= {
        "type": WindowData{str:"spinner"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
        "text": WindowData{str:text+"\0"},
		"ph":	WindowData{str:placeholder},
		"phsa": WindowData{bol:phsa},
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
        "fg":   WindowData{clr:fg},
        "hi":	WindowData{bol:hi},
        "fnchg":WindowData{fun:fnchg},
        "tSize":WindowData{num:tSize}
    }
    if dialog {app.dialog_objects << widget.clone()} else {app.objects << widget.clone()}
}

[unsafe]
fn draw_spinner(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
		app.gg.draw_rounded_rect_filled(object["x"].num+2, object["y"].num+2, object["w"].num-20, object["h"].num-4, app.round_corners, object["bfg"].clr)
		
		if app.focus!=object["id"].str{
			mut the_text:=object["text"].str.replace("\0","")
			if object["phsa"].bol {
				the_text=object["ph"].str
			}
			app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num/2, the_text, gx.TextCfg{
				color: object["fg"].clr
				size: object["tSize"].num
				align: .left
				vertical_align: .middle
			})
		} else {
			app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num/2, object["text"].str.replace("\0",text_cursor), gx.TextCfg{
				color: object["fg"].clr
				size: object["tSize"].num
				align: .left
				vertical_align: .middle
			})
		}

		if object["text"].str.len<2 && !object["phsa"].bol{
			app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num/2, "  "+object["ph"].str, gx.TextCfg{
				color: object["bg"].clr
				size: object["tSize"].num
				align: .left
				vertical_align: .middle
			})
		}
		
		app.gg.draw_rounded_rect_filled(object["x"].num + object["w"].num - 16, object["y"].num, 16, object["h"].num / 2 - 1, app.round_corners, object["bfg"].clr)
		app.gg.draw_triangle_filled(
			object["x"].num+object["w"].num-13, object["y"].num+object["h"].num/4+5-1,
			object["x"].num+object["w"].num-3 , object["y"].num+object["h"].num/4+5-1,
			object["x"].num+object["w"].num-8, object["y"].num+object["h"].num/4-5-1,
			object["fg"].clr)
		
		app.gg.draw_rounded_rect_filled(object["x"].num + object["w"].num - 16, object["y"].num + object["h"].num / 2 + 1, 16, object["h"].num / 2 - 1, app.round_corners, object["bfg"].clr)
		app.gg.draw_triangle_filled(
			object["x"].num+object["w"].num-13, object["y"].num+object["h"].num/4*3-5+1,
			object["x"].num+object["w"].num-3 , object["y"].num+object["h"].num/4*3-5+1,
			object["x"].num+object["w"].num-8, object["y"].num+object["h"].num/4*3+5+1,
			object["fg"].clr)
	}
}
