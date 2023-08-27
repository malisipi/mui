module mui

import gg
import gx

pub const (
    scrollbar_size=15
)

[unsafe]
fn update_scroll_hor(event_details EventDetails, mut app &Window, mut app_data voidptr){
    unsafe{
        app.scroll_x=event_details.value.int()
    }
}

[unsafe]
fn update_scroll_ver(event_details EventDetails, mut app &Window, mut app_data voidptr){
    unsafe{
        app.scroll_y=event_details.value.int()
    }
}

[autofree_bug; manualfree]
pub fn add_scrollbar(mut app &Window, val int, min int, max int, step int, sthum int, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, vert bool, hi bool, bg gx.Color,  bfg gx.Color, fg gx.Color, fnclk OnEvent, fnchg OnEvent, fnucl OnEvent, frame string, zindex int, connected_object map[string]WindowData){
    unsafe {
        app.objects << {
            "type": WindowData{str:"scrollbar"},
            "id":   WindowData{str:id},
            "in":   WindowData{str:frame},
            "z_ind":WindowData{num:zindex},
            "val":  WindowData{num:if is_null_object(connected_object) {val-(val-min)%step} else { 0 } },
            "vlMin":WindowData{num:if is_null_object(connected_object) {min} else { 0 } },
            "vlMax":WindowData{num:if is_null_object(connected_object) {max-(max-min)%step} else { 99999 } },
            "vStep":WindowData{num:if is_null_object(connected_object) {step} else { 1 }},
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
            "fnclk":WindowData{fun:if is_null_object(connected_object) {fnclk} else {empty_fn} },
            "fnchg":WindowData{fun:if is_null_object(connected_object) {fnchg} else {change_connected_object_viewarea}},
            "fnucl":WindowData{fun:if is_null_object(connected_object) {fnucl} else {empty_fn}},
            "cnObj":WindowData{lst:[connected_object]}
        }
    }
}

[unsafe]
fn change_connected_object_viewarea(event_details EventDetails, mut window &Window, mut app_data voidptr){
	unsafe {
		mut scrollbar := window.get_object_by_id(event_details.target_id)[0]
		if scrollbar["vert"].bol {
			scrollbar["cnObj"].lst[0]["schmx"].num = scrollbar["val"].num - scrollbar["vlMin"].num
			scrollbar["cnObj"].lst[0]["schvl"].num = scrollbar["vlMax"].num - scrollbar["vlMin"].num
		} else {
			scrollbar["cnObj"].lst[0]["scwmx"].num = scrollbar["val"].num - scrollbar["vlMin"].num
			scrollbar["cnObj"].lst[0]["scwvl"].num = scrollbar["vlMax"].num - scrollbar["vlMin"].num
		}
	}
}

[unsafe]
fn draw_scrollbar(app &Window, object map[string]WindowData){
	unsafe{
        if !object["vert"].bol {
            app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
            thumb_size:=if is_null_object(object["cnObj"].lst[0]) {
            	int(f32(object["sThum"].num-object["vlMin"].num)/f32(object["vlMax"].num-object["vlMin"].num)*object["w"].num)
            } else {
            	object["w"].num/4
            }
            width_of_thumb:=int(f32(object["w"].num-thumb_size)/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num)*(f32(object["val"].num-object["vlMin"].num)/object["vStep"].num))
            app.gg.draw_rounded_rect_filled(object["x"].num+width_of_thumb, object["y"].num + object["h"].num / 3, thumb_size, object["h"].num / 3, app.round_corners, object["bfg"].clr)
        } else {
            app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num, object["w"].num, object["h"].num, app.round_corners, object["bg"].clr)
            thumb_size:=if is_null_object(object["cnObj"].lst[0]) {
            	int(f32(object["sThum"].num-object["vlMin"].num)/f32(object["vlMax"].num-object["vlMin"].num)*object["h"].num)
            } else {
            	object["h"].num/4
            }
            height_of_thumb:=int(f32(object["h"].num-thumb_size)/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num)*(f32(object["val"].num-object["vlMin"].num)/object["vStep"].num))
            app.gg.draw_rounded_rect_filled(object["x"].num + object["w"].num / 3, object["y"].num+height_of_thumb, object["w"].num / 3, thumb_size, app.round_corners, object["bfg"].clr)
        }
	}
}
