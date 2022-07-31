module mui

import gg
import gx

const (
    scrollbar_size=15
)

[unsafe]
fn update_scroll_hor(event_details EventDetails, mut app &Window, app_data voidptr){
    unsafe{
        app.scroll_x=event_details.value.int()
    }
}

[unsafe]
fn update_scroll_ver(event_details EventDetails, mut app &Window, app_data voidptr){
    unsafe{
        app.scroll_y=event_details.value.int()
    }
}

pub fn add_scrollbar(mut app &Window, val int, min int, max int, step int, sthum int, id string, x string|int, y string|int, w string|int, h string|int, vert bool, hi bool, bg gx.Color,  bfg gx.Color, fg gx.Color, fnclk OnEvent, fnchg OnEvent, fnucl OnEvent, frame string){
	    app.objects << {
        "type": WindowData{str:"scrollbar"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "val":  WindowData{num:val-(val-min)%step},
        "vlMin":WindowData{num:min},
        "vlMax":WindowData{num:max-(max-min)%step},
        "vStep":WindowData{num:step},
        "sThum":WindowData{num:sthum},
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
		"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
		"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
		"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
		"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "vert": WindowData{bol:vert},
        "hi":	WindowData{bol:hi},
        "bg":   WindowData{clr:bg},
        "bfg":  WindowData{clr:bfg},
        "fg":   WindowData{clr:fg},
        "click":WindowData{bol:false},
        "fnclk":WindowData{fun:fnclk},
        "fnchg":WindowData{fun:fnchg},
        "fnucl":WindowData{fun:fnucl}
    }
}

[unsafe]
fn draw_scrollbar(app &Window, object map[string]WindowData){
	unsafe{
        if !object["vert"].bol {
            app.gg.draw_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["bg"].clr)
            thumb_size:=int(f32(object["sThum"].num-object["vlMin"].num)/f32(object["vlMax"].num-object["vlMin"].num)*object["w"].num)
            width_of_thumb:=int(f32(object["w"].num-thumb_size)/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num)*(f32(object["val"].num-object["vlMin"].num)/object["vStep"].num))
            app.gg.draw_rect_filled(object["x"].num+width_of_thumb, object["y"].num, thumb_size, object["h"].num, object["bfg"].clr)
        } else {
            app.gg.draw_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["bg"].clr)
            thumb_size:=int(f32(object["sThum"].num-object["vlMin"].num)/f32(object["vlMax"].num-object["vlMin"].num)*object["h"].num)
            height_of_thumb:=int(f32(object["h"].num-thumb_size)/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num)*(f32(object["val"].num-object["vlMin"].num)/object["vStep"].num))
            app.gg.draw_rect_filled(object["x"].num, object["y"].num+height_of_thumb, object["w"].num, thumb_size, object["bfg"].clr)
        }
	}
}
