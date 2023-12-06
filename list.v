module mui

import gg
import gx

pub fn add_list(mut app &Window, table [][]string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, frame string, zindex int, fnchg OnEvent, selected int, tSize int, row_h int){
    app.objects << {
        "type": WindowData{str:"list"},
	"table":WindowData{tbl:table},
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
        "bg":   WindowData{clr:bg},
        "bfg":  WindowData{clr:bfg},
        "s":	WindowData{num:selected},
        "fg":   WindowData{clr:fg},
        "fnchg":WindowData{fun:fnchg},
        "tSize":WindowData{num:tSize},
        "row_h":WindowData{num:row_h},
        "schmx":WindowData{num:0},
        "schvl":WindowData{num:0},
        "schsl":WindowData{num:0}
    }
}

@[unsafe]
fn draw_list(app &Window, object map[string]WindowData){
	unsafe{
		table:=object["table"].tbl
		table_y:=table.len
		if table_y == 0 { return }
		table_x:=table[0].len
		if table_x == 0 { return }
		fit_inside_viewarea := object["row_h"].num==-1
		per_cell:=[object["w"].num/table_x,if fit_inside_viewarea {object["h"].num/table_y} else {object["row_h"].num}]

		mut scrolled_height := 0
		if !fit_inside_viewarea {
			max_height := table_y * object["row_h"].num
			view_height := object["h"].num
			if max_height > view_height && object["schvl"].num > 0{
				scrolled_height = (max_height - view_height) * object["schmx"].num / object["schvl"].num
				object["schsl"].num = scrolled_height
			}
		}

		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, per_cell[0]*table_x, if fit_inside_viewarea { per_cell[1]*table_y } else { object["h"].num }, app.round_corners, object["bg"].clr)
		if fit_inside_viewarea || ( (object["s"].num+1)*per_cell[1] > scrolled_height && object["s"].num*per_cell[1] < object["h"].num + scrolled_height ) {
			app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num + per_cell[1] * object["s"].num - scrolled_height, per_cell[0]*table_x, per_cell[1]-1, app.round_corners, object["bfg"].clr)
		}

		for wy,y_ in table{
			if fit_inside_viewarea || ( (wy+1)*per_cell[1] > scrolled_height && wy*per_cell[1] < object["h"].num + scrolled_height ) {
				for wx,x_ in y_{
					app.gg.draw_rounded_rect_empty(object["x"].num+per_cell[0]*wx+1, object["y"].num+per_cell[1]*wy+1 - scrolled_height, per_cell[0]-2, per_cell[1]-2, app.round_corners, object["bfg"].clr)
					app.gg.draw_text(object["x"].num+per_cell[0]*wx+per_cell[0]/2, object["y"].num+per_cell[1]*wy+per_cell[1]/2 - scrolled_height, x_, gx.TextCfg{
						color: object["fg"].clr
						size: object["tSize"].num
						align: .center
						vertical_align: .middle
					})
				}
			}
		}
	}
}
