module mui

import gg
import gx

pub fn add_selectbox(mut app &Window, text string, list []string, selected int, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, frame string, zindex int){
    app.objects << {
        "type": WindowData{str:"selectbox"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
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
        "fg":   WindowData{clr:fg},
        "list":	WindowData{str:list.join("\0")},
        "s":	WindowData{num:if text==""{ selected } else { -1 }},
        "hi":	WindowData{bol:hi},
        "fnchg":WindowData{fun:fnchg},
    }
}

[unsafe]
fn draw_selectbox(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
		app.gg.draw_rounded_rect_filled(object["x"].num+2, object["y"].num+2, object["w"].num-4, object["h"].num-4, app.round_corners, object["bfg"].clr)

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
			$if windows {
				if draw_mode&1 == 1 {
					if !app.native_focus {
						the_list := object["list"].str.split("\0")
						selected := app.create_popup_menu(the_list, object["x"].num, window_titlebar_height+object["y"].num+object["h"].num)
						if selected != -1 {
							object["s"]=WindowData{num:selected}
							object["text"]=WindowData{str:the_list[object["s"].num]}
							object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",value:object["text"].str,target_type:object["type"].str,target_id:object["id"].str},mut app, mut app.app_data)
						}
						app.native_focus = true
					}
					return
				}
			}

			$if !dont_clip ? {
				app.gg.scissor_rect(object["x"].num,object["y"].num+object["h"].num,object["w"].num,object["h"].num*object["list"].str.split("\0").len)
			}
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
