module mui

import malisipi.mfb as gg

@[autofree_bug; manualfree]
pub fn add_image(mut app &Window, path string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, fun OnEvent, frame string, zindex int){
    app.objects << {
        "type": WindowData{str:"image"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
	"image":WindowData{img:app.gg.create_image(path) or { gg.Image{} }}
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
	"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
	"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
	"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
	"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "hi":	WindowData{bol:hi},
        "fn":   WindowData{fun:fun}
    }
}

@[unsafe]
fn draw_image(app &Window, object map[string]WindowData){
	unsafe{
		app.gg.draw_image(object["x"].num, object["y"].num, object["w"].num, object["h"].num, object["image"].img)
	}
}
