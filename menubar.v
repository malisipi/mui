module mui

import gg
import gx

[unsafe]
fn draw_menubar(mut app &Window, size &gg.Size){
	unsafe{
        mut clicked_item:=-1
        if app.focus.starts_with("@menubar#"){
            clicked_item=app.focus.replace("@menubar#","").int()
        }

        app.gg.draw_rounded_rect_filled(0, 0, size.width, app.menubar_config.height, app.round_corners, app.color_scheme[1])
        for which_item,items in app.menubar{

            app.gg.draw_rounded_rect_empty(app.menubar_config.width*which_item, 0, app.menubar_config.width,app.menubar_config.height, app.round_corners, app.color_scheme[0])

            app.gg.draw_text(app.menubar_config.width*which_item+app.menubar_config.width/2,app.menubar_config.height/2,items["text"].str, gx.TextCfg{
                color: app.color_scheme[3]
                size: app.menubar_config.text_size
                align: .center
                vertical_align: .middle
            })

            if clicked_item==which_item {
            	$if windows {
		        if int(app.draw_mode)&1 == 1 {
		            if !app.native_focus {
		                selected:=app.create_popup_menu(items["items"].lst.map(it["text"].str), app.menubar_config.width * which_item, window_titlebar_height + app.menubar_config.height)
		                if selected != -1 {
		                    app.menubar[which_item]["items"].lst[selected]["fn"].fun(EventDetails{event:"click",trigger:"mouse_left",value:"true",target_type:"menubar",target_id:"menubar"},mut app, mut app.app_data)
		                }
		                app.native_focus = true
		            }
		            continue
		        }
		}
                for which_sub_item, sub_item in items["items"].lst{

                    app.gg.draw_rounded_rect_filled(app.menubar_config.width*which_item, app.menubar_config.height*(which_sub_item+1), app.menubar_config.sub_width, app.menubar_config.height, app.round_corners, app.color_scheme[1])
                    app.gg.draw_rounded_rect_empty(app.menubar_config.width*which_item, app.menubar_config.height*(which_sub_item+1), app.menubar_config.sub_width, app.menubar_config.height, app.round_corners, app.color_scheme[0])

                    app.gg.draw_text(app.menubar_config.width*which_item+4,app.menubar_config.height*(which_sub_item+1)+app.menubar_config.height/2, sub_item["text"].str, gx.TextCfg{
                        color: app.color_scheme[3]
                        size: app.menubar_config.text_size
                        align: .left
                        vertical_align: .middle
                    })
                }
            }

        }
	}
}
