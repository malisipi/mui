module mui

import gg
import gx

[autofree_bug; manualfree]
pub fn add_frame(mut app &Window, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, dialog bool, frame string, zindex int, view_area []int, draggable bool, click_events bool){
    widget:= {
        "type": WindowData{str:"frame"},
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
        "acttb":WindowData{str:""}, // for tabbed view
        "schmx":WindowData{num:0},
        "schvl":WindowData{num:0},
        "schsl":WindowData{num:0},
        "scwmx":WindowData{num:0},
        "scwvl":WindowData{num:0},
        "scwsl":WindowData{num:0},
        "viewA":WindowData{dat:[view_area]},
		"drag":	WindowData{bol: draggable},
	    "sclke":WindowData{bol:click_events},
    }
    if dialog {app.dialog_objects << widget.clone()} else {app.objects << widget.clone()}
}

[unsafe]
fn draw_frame(app &Window, object map[string]WindowData){
	unsafe{
		max_height := object["viewA"].dat[0][0]
		view_height := object["h"].num
		mut scrolled_height := 0
		if max_height > view_height && object["schvl"].num > 0{
			scrolled_height = (max_height - view_height) * object["schmx"].num / object["schvl"].num
		}
		object["schsl"].num = scrolled_height

		max_width := object["viewA"].dat[0][1]
		view_width := object["w"].num
		mut scrolled_width := 0
		if max_width > view_width && object["scwvl"].num > 0 {
			scrolled_width = (max_width - view_width) * object["scwmx"].num / object["scwvl"].num
		}
		object["scwsl"].num = scrolled_width

		app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
	}
}

