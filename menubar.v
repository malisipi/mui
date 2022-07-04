module mui

import gg
import gx

const (
    menubar_width=80
    menubar_height=25
    menubar_sub_width=menubar_width*2
)

[unsafe]
fn draw_menubar(mut app &Window, size &gg.Size){
	unsafe{
        mut clicked_item:=-1
        if app.focus.starts_with("@menubar#"){
            clicked_item=app.focus.replace("@menubar#","").int()
        }

        app.gg.draw_rect_filled(0,0,size.width,menubar_height,app.color_scheme[1])
        for which_item,items in app.menubar{

            app.gg.draw_rect_empty(menubar_width*which_item,0,menubar_width,menubar_height,app.color_scheme[0])

            app.gg.draw_text(menubar_width*which_item+menubar_width/2,menubar_height/2,items["text"].str, gx.TextCfg{
                color: app.color_scheme[3]
                size: 20
                align: .center
                vertical_align: .middle
            })

            if clicked_item==which_item {
                for which_sub_item, sub_item in items["items"].lst{

                    app.gg.draw_rect_filled(menubar_width*which_item,menubar_height*(which_sub_item+1),menubar_sub_width,menubar_height,app.color_scheme[1])
                    app.gg.draw_rect_empty(menubar_width*which_item,menubar_height*(which_sub_item+1),menubar_sub_width,menubar_height,app.color_scheme[0])

                    app.gg.draw_text(menubar_width*which_item+4,menubar_height*(which_sub_item+1)+menubar_height/2, sub_item["text"].str, gx.TextCfg{
                        color: app.color_scheme[3]
                        size: 20
                        align: .left
                        vertical_align: .middle
                    })
                }
            }

        }
	}
}
