module mui

import gx
import math
import math.stats

pub fn add_line_graph(mut app &Window, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, title string, label []string, data [][]int, colors []gx.Color, names []string, bg gx.Color, fg gx.Color, frame string, zindex int){
    app.objects << {
        "type": WindowData{str:"line_graph"},
        "id":   WindowData{str:id},
		"in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
		"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
		"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
		"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
		"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "hi":	WindowData{bol:hi},
		"g_tit":WindowData{str:title},
		"g_lbl":WindowData{str:label.join("\0")},
		"g_nam":WindowData{str:names.join("\0")},
		"g_dat":WindowData{dat:data},
		"g_clr":WindowData{lcr:colors},
        "bg":   WindowData{clr:bg},
        "fg":   WindowData{clr:fg},
    }
}

@[unsafe]
fn draw_line_graph(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
		labels:=object["g_lbl"].str.split("\0")
		datas:=object["g_dat"].dat
		colors:=object["g_clr"].lcr
		names:=object["g_nam"].str.split("\0")
		mut datas_1d:=[]int{}
		for a in datas{
			for b in a{
				datas_1d << b
			}
		}
		data_max:=stats.max(datas_1d)
		data_range:=stats.range(datas_1d)
		rows:=f32(object["h"].num-80)/30
		rows_height:=f32(data_range)/rows
		cols:=labels.len
		cols_width:=f32(object["w"].num-80)/cols

		app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+10, object["g_tit"].str, gx.TextCfg{
			color: object["fg"].clr
			size: 20
			align: .center
			vertical_align: .top
		})

		for row in 0..int(rows){
			app.gg.draw_text(object["x"].num+36, (object["y"].num+40)+30*row+30/2, int(math.round(data_max-row*rows_height)).str(), gx.TextCfg{
				color: object["fg"].clr
				size: 20
				align: .right
				vertical_align: .middle
			})
		}
		for col in 0..int(cols){
			app.gg.draw_text(int((object["x"].num+40)+cols_width*col+cols_width/2), object["y"].num+object["h"].num-40, labels[col], gx.TextCfg{
				color: object["fg"].clr
				size: 20
				align: .center
				vertical_align: .top
			})
		}
	
		for wn,name in names{
			for col in 0..int(cols)-1{
				app.gg.draw_line(int((object["x"].num+36)+cols_width*col+cols_width/2),object["y"].num+40+int(f32(object["h"].num-80)/data_range*(data_max-datas[wn][col])),int((object["x"].num+36)+cols_width*(col+1)+cols_width/2), object["y"].num+40+int(f32(object["h"].num-80)/data_range*(data_max-datas[wn][col+1])), colors[wn])
			}
			app.gg.draw_text(int((object["x"].num+36)+cols_width*(cols-1)+cols_width/2)+4, object["y"].num+40+int(f32(object["h"].num-80)/data_range*(data_max-datas[wn][datas[wn].len-1])), name, gx.TextCfg{
				color: colors[wn]
				size: 20
				align: .left
				vertical_align: .middle
			})
		}

		app.gg.draw_line(object["x"].num+40, object["y"].num+40, object["x"].num+40, object["y"].num+object["h"].num-40, object["fg"].clr)
		app.gg.draw_line(object["x"].num+40, object["y"].num+object["h"].num-40, object["x"].num+object["w"].num-40, object["y"].num+object["h"].num-40, object["fg"].clr)
	}
}
