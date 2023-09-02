module mui

import mfb as gg
import gx

[autofree_bug; manualfree]
pub fn add_label(mut app &Window, text string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, fg gx.Color, fnclk OnEvent, dialog bool, tSize int, tAlin int, tMult bool, frame string, zindex int){
    widget:= {
        "type": WindowData{str:"label"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
        "text": WindowData{str:text},
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
	"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
	"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
	"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
	"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "hi":	WindowData{bol:hi},
        "fg":   WindowData{clr:fg},
        "fnclk":WindowData{fun:fnclk},
        "tSize":WindowData{num:tSize},
        "tAlin":WindowData{num:tAlin},
        "tMult":WindowData{bol:tMult}
    }
    if dialog {app.dialog_objects << widget.clone()} else {app.objects << widget.clone()}
}

[unsafe]
fn draw_label(app &Window, object map[string]WindowData){
    unsafe {
        if !object["tMult"].bol {
            match object["tAlin"].num{
                1 {
                    app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
                        color: object["fg"].clr
                        size: object["tSize"].num
                        align: .center
                        vertical_align: .middle
                    })
                } 0 {
                    app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
                        color: object["fg"].clr
                        size: object["tSize"].num
                        align: .left
                        vertical_align: .middle
                    })
                } else {
                    app.gg.draw_text(object["x"].num+object["w"].num-4, object["y"].num+object["h"].num/2, object["text"].str, gx.TextCfg{
                        color: object["fg"].clr
                        size: object["tSize"].num
                        align: .right
                        vertical_align: .middle
                    })
                }
            }
        } else {
            match object["tAlin"].num{
                1 {
                    for w,split_text in object["text"].str.split("\n"){
                        app.gg.draw_text(object["x"].num+object["w"].num/2, object["y"].num+4+w*object["tSize"].num, split_text, gx.TextCfg{
                            color: object["fg"].clr
                            size: object["tSize"].num
                            align: .center
                            vertical_align: .top
                        })
                    }
                } 0 {
                    for w,split_text in object["text"].str.split("\n"){
                        app.gg.draw_text(object["x"].num+4, object["y"].num+4+w*object["tSize"].num, split_text, gx.TextCfg{
                            color: object["fg"].clr
                            size: object["tSize"].num
                            align: .left
                            vertical_align: .top
                        })
                    }
                } else {
                    for w,split_text in object["text"].str.split("\n"){
                        app.gg.draw_text(object["x"].num+object["w"].num-4, object["y"].num+4+w*object["tSize"].num, split_text, gx.TextCfg{
                            color: object["fg"].clr
                            size: object["tSize"].num
                            align: .right
                            vertical_align: .top
                        })
                    }
                }
            }
        }
    }
}
