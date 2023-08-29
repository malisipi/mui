module mui

import gg
import gx
import os
import math
import sokol.sapp

$if windows && tinyc {
	#flag windows -isystem C:\winapi
}

pub fn create(args &WindowConfig) &Window {
    draw_mode := draw_mode_config(args.draw_mode)
    color_scheme, light_mode, round_corner := if args.color!=[-1,-1,-1] { temp0, temp1:=create_gx_color_from_manuel_color(args.color) temp0, temp1, 0 } else {
		if draw_mode == .cross_platform { // if drawing theme is not windows or cross_platform
			temp0, temp1:=create_gx_color_from_color_scheme()
			temp0, temp1, 0
		} else {
			if int(draw_mode)&8 == 8 { // If windows
				drawing_theme:=if int(draw_mode)&2 == 2 { true } else if int(draw_mode)&4 == 4 { false } else { user_light_theme }
				if drawing_theme {
					theme_windows_light.color_scheme, true, theme_windows_light.round_corner
				} else {
					theme_windows_dark.color_scheme, false, theme_windows_dark.round_corner
				}
			} else if int(draw_mode)&16 == 16 { // If linux
				drawing_theme:=if int(draw_mode)&2 == 2 { true } else if int(draw_mode)&4 == 4 { false } else { user_light_theme }
				if drawing_theme {
					theme_linux_light.color_scheme, true, theme_linux_light.round_corner
				} else {
					theme_linux_dark.color_scheme, false, theme_linux_dark.round_corner
				}
			} else { // Else
				temp0, temp1:=create_gx_color_from_color_scheme()
				temp0, temp1, 0
			}
		}
	}
    mut app := &Window{
        objects: []
        focus: ""
        color_scheme: color_scheme
        light_mode: light_mode
        gg: 0
        menubar: args.menubar
        scrollbar: args.scrollbar
        x_offset: 0 + args.x_offset
        xn_offset: if args.scrollbar { scrollbar_size } else { 0 } + args.xn_offset
        y_offset: if args.menubar!=[]map["string"]WindowData{} { args.menubar_config.height } else { 0 } + args.y_offset + args.toolbar
        yn_offset: if args.scrollbar { scrollbar_size } else { 0 } + args.yn_offset + args.statusbar
        app_data: args.app_data
        screen_reader: if args.screen_reader { check_screen_reader() } else { false }
        file_handler: args.file_handler
        ask_quit: args.ask_quit
        init_fn: args.init_fn
        quit_fn: args.quit_fn
        resized_fn: args.resized_fn
        menubar_config: args.menubar_config
        draw_mode: draw_mode
        round_corners: if args.round_corners==-1 { round_corner } else { args.round_corners }
		rtl_layout: $if rtl? { true } $else { args.rtl_layout }
    }

    mut emoji_font:=args.font
    $if !no_emoji? {
		$if !android {
			noto_emoji_font:=$embed_file("noto_emoji_font/NotoEmoji.ttf")
			emoji_font=os.temp_dir()+"/noto_emoji_font.ttf"
			os.write_file(emoji_font, noto_emoji_font.to_string()) or {}
		}
	}

	mut window_title:="canvas"
	$if !emscripten? {
		window_title=args.title
	}

    app.gg = gg.new_context(
		bg_color: if args.background == [-1,-1,-1] { app.color_scheme[0] } else { gx.rgb(u8(args.background[0]), u8(args.background[1]), u8(args.background[2])) }
		frame_fn: frame_fn
		click_fn: click_fn
		char_fn: char_fn
		keydown_fn: keydown_fn
		user_data: app
		window_title: window_title
		move_fn: move_fn
		unclick_fn: unclick_fn
		init_fn: init_fn
		resized_fn: resized_fn
		scroll_fn: scroll_fn
		event_fn: event_fn
		font_path: os.abs_path(args.font)
		custom_bold_font_path: emoji_font
		width: args.width
		height: args.height
		create_window: true
		enable_dragndrop: true
	)

	$if emscripten?{
		C.emscripten_run_script(cstr("document.title='"+args.title+"'"))
	}

	app.scrollbar(Widget{ id:"@scrollbar:horizontal", x:"!& 0", y:"!&# 0", width:"! 100%x -15", height:"! 15", value_max:args.view_area[0]+app.x_offset+app.xn_offset, size_thumb:args.width, onchange: update_scroll_hor, z_index:999999, hidden:!app.scrollbar})
	app.scrollbar(Widget{ id:"@scrollbar:vertical", x:"!&# 0", y:"!& 0", width:"! 15", height:"! 100%y", value_max:args.view_area[1]+app.y_offset+app.yn_offset, size_thumb:args.height, onchange: update_scroll_ver, vertical:true, z_index:999999, hidden:!app.scrollbar})

	if args.toolbar != 0 {
		menubar_height := if args.menubar!=[]map["string"]WindowData{} { args.menubar_config.height } else { 0 }
		app.frame(id:"@toolbar", x:"!& 0", y:"!& ${menubar_height}", width:"100%x", height:args.toolbar)
	}
	if args.statusbar != 0 {
		app.frame(id:"@statusbar", x:"!& 0", y:"!&# 0", width:"100%x", height:args.statusbar)
	}

	return app
}

[unsafe]
fn frame_fn(app &Window) {
	unsafe{
		app.gg.begin()
		mut objects:=app.objects.clone()
		//if app.focus!="" { objects << get_object_by_id(app, app.focus) }
		real_size:=app.gg.window_size()
		window_info:=[real_size.width-app.x_offset-app.xn_offset,real_size.height-app.y_offset-app.yn_offset,real_size.width,real_size.height,app.scroll_x,app.scroll_y].clone()
		$if !dont_clip ? { app.gg.scissor_rect(0, 0, real_size.width, real_size.height) }

		if app.active_dialog!="" {
			objects=app.dialog_objects.clone()
		}

		for object in objects{
			if !object["hi"].bol && object["type"].str!="hidden"{
				if $if power_save ? { app.redraw_required || app.force_redraw } $else { true } {
					if object["in"].str == "" {
						points:=calc_points(window_info,object["x_raw"].str,object["y_raw"].str,object["w_raw"].str,object["h_raw"].str, app.rtl_layout)
						object["x"]=WindowData{num:points[0]+ if !object["x_raw"].str.starts_with("!") || app.active_dialog!="" {app.x_offset} else {0} }
						object["y"]=WindowData{num:points[1]+ if !object["y_raw"].str.starts_with("!") || app.active_dialog!="" {app.y_offset} else {0} }
						object["w"]=WindowData{num:points[2]}
						object["h"]=WindowData{num:points[3]}
					} else {
						frame:=app.get_object_by_id(object["in"].str)[0]
						if frame["hi"].bol {
							object["x"]=WindowData{num:-1}
							object["y"]=WindowData{num:-1}
							object["w"]=WindowData{num:0}
							object["h"]=WindowData{num:0}
						} else {
            points:=calc_points([frame["w"].num,frame["h"].num,frame["w"].num,frame["h"].num,0,0],
                      object["x_raw"].str,object["y_raw"].str,object["w_raw"].str,object["h_raw"].str, app.rtl_layout)
            object["x"]=WindowData{num:points[0]+frame["x"].num-frame["scwsl"].num}
            object["y"]=WindowData{num:points[1]+frame["y"].num-frame["schsl"].num}
            object["w"]=WindowData{num:points[2]}
            object["h"]=WindowData{num:points[3]}
						}
					}
				}
				if object["x"].num+object["w"].num>=0 && object["y"].num+object["h"].num>=0
								&& object["x"].num<=window_info[2] && object["y"].num<=window_info[3] && object["w"].num>0 && object["h"].num>0 {
					$if !dont_clip ? {
						if object["in"].str == "" {
							app.gg.scissor_rect(object["x"].num, object["y"].num, object["w"].num, object["h"].num)
						} else {
							frame := app.get_object_by_id(object["in"].str)[0]
							scissor_x := math.max(frame["x"].num,object["x"].num)
							scissor_y := math.max(frame["y"].num,object["y"].num)
							scissor_w := math.min(frame["x"].num+frame["w"].num,object["x"].num+frame["w"].num) - scissor_x
							scissor_h := math.min(frame["y"].num+frame["h"].num,object["y"].num+object["h"].num) - scissor_y
							if scissor_w < 0 || scissor_h < 0 { continue }
							app.gg.scissor_rect(
										scissor_x,
										scissor_y,
										scissor_w,
										scissor_h
									)
						}
					}
					match object["type"].str{
						"rect"{
							draw_rect(app, object)
						}"frame"{
							draw_frame(app, object)
						}"button"{
							draw_button(app, object)
						}"label"{
							draw_label(app, object)
						}"progress"{
							draw_progress(app, object)
						}"textbox"{
							draw_textbox(app, object)
						}"textarea"{
							draw_textarea(app, object)
						}"password"{
							draw_password(app, object)
						}"checkbox"{
							$if !dont_clip ? { if object["in"].str=="" {
								if !app.rtl_layout { // LTR
									app.gg.scissor_rect(object["x"].num, object["y"].num, object["w"].num + 300, object["h"].num)
								} else { // RTL
									app.gg.scissor_rect(object["x"].num - 300, object["y"].num, object["w"].num + 300, object["h"].num)
								}
							} }
							draw_checkbox(app, object)
						}"switch"{
							$if !dont_clip ? { if object["in"].str=="" {
								if !app.rtl_layout { // LTR
									app.gg.scissor_rect(object["x"].num, object["y"].num, object["w"].num + 300, object["h"].num)
								} else { // RTL
									app.gg.scissor_rect(object["x"].num - 300, object["y"].num, object["w"].num + 300, object["h"].num)
								}
							} }
							draw_switch(app, object)
						}"selectbox"{
							$if !dont_clip ? { if object["in"].str=="" { app.gg.scissor_rect(object["x"].num, object["y"].num, object["w"].num, object["h"].num+800) } }
							draw_selectbox(app, object)
						}"slider"{
							$if !dont_clip ? { if object["in"].str=="" { app.gg.scissor_rect(object["x"].num, object["y"].num, object["w"].num + 300, object["h"].num + 300) } }
							draw_slider(app, object)
						}"link"{
							draw_link(app, object)
						}"radio"{
							$if !dont_clip ? { if object["in"].str=="" {
								if !app.rtl_layout { // LTR
									app.gg.scissor_rect(object["x"].num, object["y"].num, object["w"].num + 300, object["h"].num)
								} else { // RTL
									app.gg.scissor_rect(object["x"].num - 300, object["y"].num, object["w"].num + 300, object["h"].num)
								}
							} }
							draw_radio(app, object)
						}"group"{
							draw_group(app, object)
						}"image"{
							draw_image(app, object)
						}"table"{
							draw_table(app, object)
						}"line_graph"{
							draw_line_graph(app, object)
						}"area_graph"{
							draw_area_graph(app, object)
						}"map"{
							draw_map(app, object)
						}"scrollbar"{
							draw_scrollbar(app, object)
						}"list"{
							draw_list(app, object)
						}"spinner"{
							draw_spinner(app, object)
						} else {
							for widget in app.custom_widgets{
								if object["type"].str==widget.typ{
									widget.draw_fn(app, object)
									break
								}
							}
						}
					}
				}
			}
		}
		$if !dont_clip ? { app.gg.scissor_rect(0, 0, real_size.width, real_size.height) }
		mut focused_object := app.get_object_by_id(app.focus)[0]
		if !is_null_object(focused_object) && focused_object["type"].str == "selectbox" { // will removed when splitted popup code from selectbox		
			$if !dont_clip ? { if focused_object["in"].str=="" { app.gg.scissor_rect(focused_object["x"].num, focused_object["y"].num, focused_object["w"].num, focused_object["h"].num+800) } }
			draw_selectbox(app, focused_object)
		}
		draw_focus(mut app)
		if app.menubar!=[]map["string"]WindowData{} {
			draw_menubar(mut app, real_size)
		}
		app.gg.end()
		$if power_save ? {
			if app.redraw_required {
				app.redraw_required = false
			}
		}
	}
}

pub fn (mut app Window) run () {
	app.sort_widgets_with_zindex()
	app.gg.run()
}

pub fn (mut app Window) destroy () {
	app.quit_fn( EventDetails{
					event:"destroy",
					trigger:"non_user",
					value:"true",
					target_type:"window",
					target_id:""},
		mut app, mut app.app_data)
	sapp.quit()
}

pub fn (mut app Window) set_title (title string) {
	C.sapp_set_window_title(&char(title.str))
}

pub fn (mut app Window) enable_scrollbar (enable_scrollbar bool) {
	if !(app.scrollbar==enable_scrollbar) {
		if enable_scrollbar {
			app.scrollbar=true
			app.xn_offset+=scrollbar_size
			app.yn_offset+=scrollbar_size
			unsafe {
				app.get_object_by_id("@scrollbar:horizontal")[0]["hi"].bol=false
				app.get_object_by_id("@scrollbar:vertical")[0]["hi"].bol=false
				app.get_object_by_id("@scrollbar:extra")[0]["hi"].bol=false
			}
		} else {
			app.scrollbar=false
			app.xn_offset-=scrollbar_size
			app.yn_offset-=scrollbar_size
			unsafe {
				app.get_object_by_id("@scrollbar:horizontal")[0]["hi"].bol=true
				app.get_object_by_id("@scrollbar:vertical")[0]["hi"].bol=true
				app.get_object_by_id("@scrollbar:extra")[0]["hi"].bol=true
			}
		}
	}
}

pub fn (mut app Window) set_viewarea (x int, y int) {
	app.get_object_by_id("@scrollbar:horizontal")[0]["vlMax"].num=x+app.x_offset+app.xn_offset
	app.get_object_by_id("@scrollbar:vertical")[0]["vlMax"].num=y+app.y_offset+app.yn_offset
}
