module custom_widget

import mfb as gg
import gx
import malisipi.mui

pub fn new(mut app mui.Window, args mui.Widget){
    app.objects << {
        "type": mui.WindowData{str:"my_custom_widget"},
        "id":   mui.WindowData{str:args.id},
        "text": mui.WindowData{str:args.text},
        "x":    mui.WindowData{num:0},
        "y":    mui.WindowData{num:0},
        "w":    mui.WindowData{num:0},
        "h":    mui.WindowData{num:0},
        "d_x":  mui.WindowData{num:0},
        "d_y":  mui.WindowData{num:0},
		"x_raw":mui.WindowData{str: match args.x{ int{ args.x.str() } string{ args.x } } },
		"y_raw":mui.WindowData{str: match args.y{ int{ args.y.str() } string{ args.y } } },
		"w_raw":mui.WindowData{str: match args.width{ int{ args.width.str() } string{ args.width } } },
		"h_raw":mui.WindowData{str: match args.height{ int{ args.height.str() } string{ args.height } } },
        "hi":	mui.WindowData{bol:args.hidden},
    }
}

[unsafe]
fn draw_my_custom_widget(app &mui.Window, object map[string]mui.WindowData){
	unsafe{
		app.gg.draw_rect_filled(object["x"].num+object["d_x"].num, object["y"].num+object["d_y"].num, object["w"].num-object["d_x"].num, object["h"].num-object["d_y"].num, gx.Color{r: 255, g:255, b:255})
		app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
			color: gx.Color{r: 255, g:0, b:0}
			size: 20
			align: .center
			vertical_align: .middle
		})
	}
}

[unsafe]
fn click_my_custom_widget(x f32, y f32, mut object map[string]mui.WindowData, mut app &mui.Window){
    print([f32(1),x,y])
}

[unsafe]
fn move_my_custom_widget(x f32, y f32, mut object map[string]mui.WindowData, mut app &mui.Window){
    unsafe {
        object["d_x"].num=int(x)-object["x"].num
        object["d_y"].num=int(y)-object["y"].num
    }
}

[unsafe]
fn unclick_my_custom_widget(x f32, y f32, mut object map[string]mui.WindowData, mut app &mui.Window){
    print([f32(2),x,y])
    app.focus=""
}

pub fn load_into_app(mut app &mui.Window){
    app.custom_widgets << mui.CustomWidget{typ:"my_custom_widget",
                    draw_fn:draw_my_custom_widget,
                    click_fn:click_my_custom_widget,
                    move_fn:move_my_custom_widget,
                    unclick_fn:unclick_my_custom_widget
    }
}
