module mui

import gg
import gx

pub fn add_link(mut app &Window, text string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, underline bool, link string, fg gx.Color, fnclk OnEvent, frame string, zindex int){
    app.objects << {
        "type": WindowData{str:"link"},
        "id":   WindowData{str:id},
	"in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
        "text": WindowData{str:text},
        "unlin": WindowData{str:text},
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
	"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
	"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
	"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
	"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "hi":	WindowData{bol:hi},
        "fg":   WindowData{clr:fg},
        "link": WindowData{str:link},
        "fnclk":WindowData{fun:fnclk}
    }
}

[unsafe]
fn draw_link(app &Window, object map[string]WindowData){
	unsafe{
		w,h:=app.gg.text_size(object["text"].str)
		app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
			color: object["fg"].clr
			size: 20
			align: .center
			vertical_align: .middle
		})
		if object["unlin"].bol{
			app.gg.draw_rect_filled(object["x"].num+object["w"].num/2-w/2, object["y"].num+object["h"].num/2+h/2-2,w,2,object["fg"].clr)
		}
	}
}
