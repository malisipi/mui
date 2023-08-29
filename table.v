module mui

import gg
import gx

pub fn add_table(mut app &Window, table [][]string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, frame string, zindex int, tSize int, row_h int){
    app.objects << {
        "type": WindowData{str:"table"},
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
        "fg":   WindowData{clr:fg},
        "tSize":WindowData{num:tSize},
        "row_h":WindowData{num:row_h},
        "schmx":WindowData{num:0},
        "schvl":WindowData{num:0},
        "schsl":WindowData{num:0}
    }
}

[unsafe]
fn draw_table(app &Window, object map[string]WindowData){
	unsafe{
		mut table:=object["table"].tbl // LTR
		table_y:=table.len
		table_x:=table[0].len

		if app.rtl_layout { // RTL
			mut new_table := [][]string{}
			for row:=0; row<table_y; row++ {
				new_table << table[row].reverse()
			}
			table = new_table
		}

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
