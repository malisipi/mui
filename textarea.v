module mui

import malisipi.mfb as gg
import gx

pub fn add_textarea(mut app &Window, text string, id string, placeholder string, phsa bool, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color,  bfg gx.Color, fg gx.Color,  fnchg OnEvent, codefield bool, tSize int, frame string, zindex int){
    app.objects << {
        "type": WindowData{str:"textarea"},
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
	"code": WindowData{bol:codefield},
        "tSize":WindowData{num:tSize},
        "schmx":WindowData{num:0},
        "schvl":WindowData{num:0},
        "schsl":WindowData{num:0}
    }
}

[unsafe]
fn draw_textarea(app &Window, object map[string]WindowData){
	unsafe{
		line_count := object["text"].str.count("\n") + 1
		max_height := line_count * object["tSize"].num
		view_height := object["h"].num - 8
		mut scrolled_height := 0
		if max_height > view_height && object["schvl"].num > 0{
			scrolled_height = (max_height - view_height) * object["schmx"].num / object["schvl"].num
			object["schsl"].num = scrolled_height
		}
		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
		app.gg.draw_rounded_rect_filled(object["x"].num+2, object["y"].num+2, object["w"].num-4, object["h"].num-4, app.round_corners, object["bfg"].clr)
		if app.focus!=object["id"].str{
			mut the_text:=object["text"].str.replace("\0","")
			if object["phsa"].bol {
				the_text=object["ph"].str
			}
			for w,split_text in the_text.replace("\t","    ").split("\n"){
				if 4+(w+1)*object["tSize"].num - scrolled_height > 0 && 4+w*object["tSize"].num - scrolled_height < object["h"].num {
					app.gg.draw_text(object["x"].num+4, object["y"].num+4+w*object["tSize"].num - scrolled_height, split_text, gx.TextCfg{
						color: object["fg"].clr
						mono: object["code"].bol
						size: object["tSize"].num
						align: .left
						vertical_align: .top
					})
				}
			}
		} else {
			for w,split_text in object["text"].str.replace("\t","    ").replace("\0",text_cursor).split("\n"){
				if 4+(w+1)*object["tSize"].num - scrolled_height > 0 && 4+w*object["tSize"].num - scrolled_height < object["h"].num{
					app.gg.draw_text(object["x"].num+4, object["y"].num+4+w*object["tSize"].num - scrolled_height, split_text, gx.TextCfg{
						color: object["fg"].clr
						mono: object["code"].bol
						size: object["tSize"].num
						align: .left
						vertical_align: .top
					})
				}
			}
		}

		if object["text"].str.len<2 && !object["phsa"].bol{
			for w,split_text in object["ph"].str.split("\n"){
				app.gg.draw_text(object["x"].num+4, object["y"].num+4+w*object["tSize"].num, "  "+split_text, gx.TextCfg{
					color: object["bg"].clr
					mono: object["code"].bol
					size: object["tSize"].num
					align: .left
					vertical_align: .top
				})
			}
		}
	}
}
