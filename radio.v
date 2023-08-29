module mui

import gx

pub fn add_radio(mut app &Window, list []string, group_id string, x IntOrString, y IntOrString, wh IntOrString, selected int, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, frame string, zindex int, tSize int){
	app.objects << {
		"type": WindowData{str:"hidden"},
		"realT":WindowData{str:"radio"},
		"id":   WindowData{str:group_id},
		"in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
		"len":	WindowData{num:list.len}
		"x":    WindowData{num:0},
		"y":    WindowData{num:0},
		"w":    WindowData{num:0},
		"h":    WindowData{num:0},
		"s":	WindowData{num:selected}
		"bg":   WindowData{clr:bg},
		"bfg":	WindowData{clr:bfg},
		"fg":   WindowData{clr:fg},
		"hi":	WindowData{bol:hi},
		"fnchg":WindowData{fun:fnchg},
		"tSize":WindowData{num:tSize}
	}
	x_raw_str := match x{ int{ x.str() } string{ x } }
	for which_item,item in list {
		app.objects << {
			"type": WindowData{str:"radio"},
			"id":   WindowData{str:group_id+"_"+which_item.str()},
			"text": WindowData{str:item},
			"x":    WindowData{num:0},
			"y":    WindowData{num:0},
			"w":    WindowData{num:0},
			"h":    WindowData{num:0},
			"x_raw":WindowData{str: x_raw_str },
			"y_raw":WindowData{str: match y{ int{ (y+((match wh{int{wh}string{0}}+5)*which_item)).str() } string{ print("Anchors couldn't be used in Y of radio buttons.\n") "0" } } },
			"w_raw":WindowData{str: match wh{ int{ wh.str() } string{ print("Anchors couldn't be used in size of radio buttons.\n") "0" } } },
			"h_raw":WindowData{str: match wh{ int{ wh.str() } string{ print("Anchors couldn't be used in size of radio buttons.\n") "0" } } },
			"c":	WindowData{bol:selected==which_item},
			"hi":	WindowData{bol:hi},
			"tSize":WindowData{num:tSize},
			"in":   WindowData{str:frame},
		}
	}
}

[unsafe]
fn draw_radio(app &Window, object map[string]WindowData){
	unsafe{
		group:=get_object_by_id(app, object["id"].str.split("_")#[0..-1].join("_"))
		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["w"].num, app.round_corners, group["bg"].clr)
		if object["c"].bol{
			app.gg.draw_rounded_rect_filled(object["x"].num+2, object["y"].num+2, object["w"].num-4, object["w"].num-4, app.round_corners, group["bfg"].clr)
		}

		if !app.rtl_layout { // LTR
			app.gg.draw_text(object["x"].num+object["w"].num+4, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
				color: group["fg"].clr
				size: object["tSize"].num
				align: .left
				vertical_align: .middle
			})
		} else { // RTL
			app.gg.draw_text(object["x"].num-4, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
				color: group["fg"].clr
				size: object["tSize"].num
				align: .right
				vertical_align: .middle
			})
		}
	}
}
