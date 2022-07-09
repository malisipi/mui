module mui

import gg
import math
import os

pub fn create(args &WindowConfig)	 &Window{
    mut app := &Window{
        objects: []
        focus: ""
        color_scheme: if args.color!=[-1,-1,-1] { create_gx_color_from_manuel_color(args.color) } else { create_gx_color_from_color_scheme() }
        gg: 0
        menubar: args.menubar
        scrollbar: args.scrollbar
        x_offset: 0
        xn_offset: if args.scrollbar { scrollbar_size } else { 0 }
        y_offset: if args.menubar!=[]map["string"]WindowData{} { menubar_height } else { 0 }
        yn_offset: if args.scrollbar { scrollbar_size } else { 0 }
        app_data: args.app_data
        screen_reader: if args.screen_reader { check_screen_reader() } else { false }
    }

    mut emoji_font:=args.font
    $if no_emoji? {
	} $else {
		noto_emoji_font:=$embed_file("noto_emoji_font/NotoEmoji.ttf")
		emoji_font=os.temp_dir()+"/noto_emoji_font.ttf"
		os.write_file(emoji_font, noto_emoji_font.to_string()) or {}
	}

    app.gg = gg.new_context(
		bg_color: app.color_scheme[0]
		frame_fn: frame_fn
		click_fn: click_fn
		char_fn: char_fn
		keydown_fn: keydown_fn
		user_data: app
		window_title: args.title
		move_fn: move_fn
		unclick_fn: unclick_fn
		resized_fn: resized_fn
		scroll_fn: scroll_fn
		font_path: args.font
		custom_bold_font_path: emoji_font
		width: args.width
		height: args.height
		create_window: true
	)

	if args.scrollbar{
		app.scrollbar(mui.Widget{ id:"@scrollbar:horizontal", x:"!& 0", y:"!&# 0", width:"! 100%x -15", height:"! 15", value_max:args.view_area[0], size_thumb:args.width, onchange: update_scroll_hor})
		app.scrollbar(mui.Widget{ id:"@scrollbar:vertical", x:"!&# 0", y:"!& 0", width:"! 15", height:"! 100%y -15", value_max:args.view_area[1], size_thumb:args.height, onchange: update_scroll_ver, vertical:true})
	}

	return app
}

[unsafe]
fn frame_fn(app &Window) {
	unsafe{
		app.gg.begin()
		mut objects:=app.objects.clone()
		if app.focus!="" { objects << get_object_by_id(app, app.focus) }
		real_size:=app.gg.window_size()
		window_info:=[real_size.width-app.x_offset-app.xn_offset,real_size.height-app.y_offset-app.yn_offset,real_size.width,real_size.height,app.scroll_x,app.scroll_y].clone()
		for object in objects{
			if !object["hi"].bol && object["type"].str!="hidden"{
				points:=calc_points(window_info,object["x_raw"].str,object["y_raw"].str,object["w_raw"].str,object["h_raw"].str)
				object["x"]=WindowData{num:points[0]}
				object["y"]=WindowData{num:points[1]+app.y_offset}
				object["w"]=WindowData{num:points[2]}
				object["h"]=WindowData{num:points[3]}
				match object["type"].str{
					"rect"{
						draw_rect(app, object)
					}"button"{
						draw_button(app, object)
					}"label"{
						draw_label(app, object)
					}"progress"{
						draw_progress(app, object)
					}"textbox"{
						draw_textbox(app, object)
					}"password"{
						draw_password(app, object)
					}"checkbox"{
						draw_checkbox(app, object)
					}"selectbox"{
						draw_selectbox(app, object)
					}"slider"{
						draw_slider(app, object)
					}"link"{
						draw_link(app, object)
					}"radio"{
						draw_radio(app, object)
					}"group"{
						draw_group(app, object)
					}"image"{
						draw_image(app, object)
					}"table"{
						draw_table(app, object)
					}"line_graph"{
						draw_line_graph(app, object)
					}"map"{
						draw_map(app, object)
					}"scrollbar"{
						draw_scrollbar(app, object)
					}else {}
				}
			}
		}
		draw_focus(mut app)
		if app.menubar!=[]map["string"]WindowData{} {
			draw_menubar(mut app, real_size)
		}
		app.gg.end()
	}
}

[unsafe]
fn click_fn(x f32, y f32, mb gg.MouseButton, mut app &Window) {
	unsafe{
		if app.focus!="" {
			if get_object_by_id(app, app.focus)["type"].str=="selectbox" {
				mut old_focused_object:=get_object_by_id(app, app.focus)
				app.focus=""
				total_items:=old_focused_object["list"].str.split("\0").len
				list_x:=old_focused_object["x"].num
				list_y:=old_focused_object["y"].num+old_focused_object["h"].num
				list_height:=total_items*old_focused_object["h"].num
				list_width:=old_focused_object["w"].num
				if list_x<x && list_x+list_width>x {
					if list_y<y && list_y+list_height>y {
						old_focused_object["s"]=WindowData{num:int((y-list_y)/(list_height/total_items))}
						old_focused_object["text"]=WindowData{str:old_focused_object["list"].str.split("\0")[old_focused_object["s"].num]}
						old_focused_object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",value:old_focused_object["text"].str,target_type:old_focused_object["type"].str,target_id:old_focused_object["id"].str},mut app, mut app.app_data)
						return
					}
				}
			}else if app.focus.starts_with("@menubar#") {
				selected_item:=app.focus.replace("@menubar#","").int()
				if x>=menubar_width*selected_item && x<=menubar_width*selected_item+menubar_sub_width {
					menubar_sub_items_len:=app.menubar[selected_item]["items"].lst.len
					if y>=menubar_height && y<=menubar_height*(menubar_sub_items_len+1){
						app.menubar[selected_item]["items"].lst[int(y-menubar_height)/menubar_height]["fn"].fun(EventDetails{event:"click",trigger:"mouse_left",value:"true",target_type:"menubar",target_id:"menubar"},mut app, mut app.app_data)
					}
				}
				app.focus=""
				return
			}

		}
		app.focus=""

		if y<=menubar_height && app.menubar!=[]map["string"]WindowData{}{
			menu_items:=app.menubar.len
			if x<menu_items*menubar_width{
				app.focus="@menubar#"+(x/menubar_width).str()
				return
			}
		}

		if mb==gg.MouseButton.left{
			for mut object in app.objects{
				if !object["hi"].bol && object["type"].str!="rect" && object["type"].str!="group" && object["type"].str!="table"{
					if object["x"].num<x && object["x"].num+object["w"].num>x{
						if object["y"].num<y && object["y"].num+object["h"].num>y{
							if object["type"].str!="rect" {
								app.focus=object["id"].str
							}
							match object["type"].str{
								"button" {
									object["fn"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:true.str()},mut app, mut app.app_data)
								} "checkbox" {
									object["c"]=WindowData{bol:!object["c"].bol}
									object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["c"].bol.str()},mut app, mut app.app_data)
								} "slider", "scrollbar" {
									if !object["vert"].bol {
										object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(x-object["x"].num,0),object["w"].num))/f32(object["w"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
									} else {
										object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(y-object["y"].num,0),object["h"].num))/f32(object["h"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
									}
									object["click"]=WindowData{bol:true}
									object["fnclk"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()}, mut app, mut app.app_data)
									object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()}, mut app, mut app.app_data)
								} "label"{
									object["fnclk"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:true.str()},mut app, mut app.app_data)
								} "link"{
									object["fnclk"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:true.str()},mut app, mut app.app_data)
									os.open_uri(object["link"].str) or {}
								} "textbox", "password"{
									the_text:=object["text"].str.replace("\0","")
									if the_text.len>0{
										mut split_char:=0
										if object["type"].str=="textbox"{
											split_char=math.min(int(math.round((x-object["x"].num)/((app.gg.text_width(the_text)+2)/the_text.len))),the_text.len)
										} else {
											split_char=math.min(int(math.round((x-object["x"].num)/((app.gg.text_width(object["hc"].str)*the_text.len+2)/the_text.len))),the_text.len)
										}
										object["text"]=WindowData{str:the_text[0..split_char]+"\0"+the_text[split_char..math.min(99999,the_text.len)]}
									} else {
										object["text"]=WindowData{str:"\0"}
									}
								} "radio" {
									group_id:=object["id"].str.split("_")#[0..-1].join("_")
									group:=get_object_by_id(app,group_id)
									which_item:=object["id"].str.replace(group_id+"_","").int()
									radio_list_len:=group["len"].num
									for item in 0..radio_list_len {
										app.get_object_by_id(group_id+"_"+item.str())[0]["c"].bol=item==which_item
									}
									group["s"].num=which_item
									group["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:which_item.str()},mut app, mut app.app_data)
								} "image", "map" {
									object["fn"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str,value:true.str()},mut app, mut app.app_data)
								}else {}
							}
							break
						}
					}
				}
			}
		}
	}
}

[unsafe]
fn move_fn(x f32, y f32, mut app &Window){
	unsafe{
		if !(app.focus==""){
			object:=get_object_by_id(app, app.focus)
			if object["type"].str=="slider" || object["type"].str=="scrollbar"{
				if object["click"].bol {
					if !object["vert"].bol {
						object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(x-object["x"].num,0),object["w"].num))/f32(object["w"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
					} else {
						object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(y-object["y"].num,0),object["h"].num))/f32(object["h"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
					}
					object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str,value:object["val"].num.str()},mut app, mut app.app_data)
				}
			}
		}
	}
}

[unsafe]
fn unclick_fn(x f32, y f32, mb gg.MouseButton, mut app &Window){
	unsafe{
		if !(app.focus==""){
			object:=get_object_by_id(app, app.focus)
			if object["type"].str=="slider" || object["type"].str=="scrollbar"{
				object["click"]=WindowData{bol:false}
				object["fnucl"].fun(EventDetails{event:"unclick",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()},mut app, mut app.app_data)
			}
		}
	}
}

[unsafe]
fn scroll_fn(event &gg.Event, mut app &Window){
	unsafe{
		shift_press:=event.modifiers&1<<0==1
		if event.scroll_x!=0 || shift_press {
			mut scrollbar_horizontal:=app.get_object_by_id("@scrollbar:horizontal")[0]
			app.scroll_x=math.max(math.min(int(scrollbar_horizontal["val"].num+if !shift_press {event.scroll_x} else {event.scroll_y}*-50),scrollbar_horizontal["vlMax"].num), scrollbar_horizontal["vlMin"].num)
			scrollbar_horizontal["val"].num=app.scroll_x
		} else {
			mut scrollbar_vertical:=app.get_object_by_id("@scrollbar:vertical")[0]
			app.scroll_y=math.max(math.min(int(scrollbar_vertical["val"].num+event.scroll_y*-50),scrollbar_vertical["vlMax"].num), scrollbar_vertical["vlMin"].num)
			scrollbar_vertical["val"].num=app.scroll_y
		}
	}
}

[unsafe]
fn char_fn(chr u32, mut app &Window){
	unsafe {
		keyboard_fn(chr, mut app)
	}
}

[unsafe]
fn keyboard_fn(chr u32|string, mut app &Window){
	unsafe{
		if app.focus!="" {
			mut object:=get_object_by_id(app,app.focus)

			mut key:=""
			match chr{
				u32{
					key=utf32_to_str(chr)
				} string {
					key=chr
				}
			}

			if key=="escape"{
				app.focus=""
			}
			match object["type"].str {
				"textbox","password" {
					if key.runes().len<2{
						the_text:=object["text"].str
						the_text_part1,the_text_part2:=the_text.split("\0")[0],the_text.split("\0")[1]
						if key!="\b" && key!="\1" {
							object["text"]=WindowData{str:the_text_part1+key+"\0"+the_text_part2}
						} else if key=="\b" {
							object["text"]=WindowData{str:the_text_part1.runes()#[0..-1].string()+"\0"+the_text_part2}
						} else {
							object["text"]=WindowData{str:the_text_part1+"\0"+the_text_part2.runes()#[1..].string()}
						}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["text"].str},mut app, mut app.app_data)
					} else if key=="right" || key.to_lower()=="left"{
						the_text:=object["text"].str
						the_text_part1,the_text_part2:=the_text.split("\0")[0].runes(),the_text.split("\0")[1].runes()
						if key.to_lower()=="right" {
							if the_text_part2.len==0 { return }
							object["text"]=WindowData{str:the_text_part1.string()+the_text_part2[0..1].string()+"\0"+the_text_part2[1..the_text_part2.len].string()}
						} else {
							if the_text_part1.len==0 { return }
							object["text"]=WindowData{str:the_text_part1#[0..-1].string()+"\0"+the_text_part1[the_text_part1.len-1..the_text_part1.len].string()+the_text_part2.string()}
						}
					}
				} "button" {
					if key=="enter" || key==" " {
						object["fn"].fun(EventDetails{event:"keypress",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:true.str()},mut app, mut app.app_data)
					}
				} "checkbox" {
					if key=="enter" || key==" " {
						object["c"]=WindowData{bol:!object["c"].bol}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["c"].bol.str()},mut app, mut app.app_data)
					}
				} "slider","scrollbar" {
					if key=="left" {
						object["val"]=WindowData{num:math.max(object["vlMin"].num,object["val"].num-object["vStep"].num)}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["val"].num.str()},mut app, mut app.app_data)
					} else if key.to_lower()=="right" {
						object["val"]=WindowData{num:math.min(object["vlMax"].num,object["val"].num+object["vStep"].num)}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["val"].num.str()},mut app, mut app.app_data)
					}
				} "radio" {
					if key=="__up" || key=="down" {
						group_id:=object["id"].str.split("_")#[0..-1].join("_")
						group:=get_object_by_id(app,group_id)
						radio_list_len:=group["len"].num
						mut which_item:=object["id"].str.replace(group_id+"_","").int()
						if key=="__up"{
							which_item-=1
							if which_item==-1{
								which_item=radio_list_len-1
							}
						} else {
							which_item+=1
							if which_item==radio_list_len{
								which_item=0
							}
						}
						for item in 0..radio_list_len {
							app.get_object_by_id(group_id+"_"+item.str())[0]["c"].bol=item==which_item
						}
						app.focus=group_id+"_"+which_item.str()
						group["s"].num=which_item
						group["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:group_id+"_"+which_item.str(),value:which_item.str()},mut app, mut app.app_data)

						if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
					}
				} "selectbox" {
					if key=="__up" || key=="down" {
						list:=object["list"].str.split("\0")
						which_item:=object["s"].num
						if key=="__up"{
							which_item-=1
							if which_item<=-1{
								which_item=list.len-1
							}
						} else {
							which_item+=1
							if which_item==list.len{
								which_item=0
							}
						}
						object["s"].num=which_item
						object["text"].str=list[which_item]
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",value:object["text"].str,target_type:object["type"].str,target_id:object["id"].str},mut app, mut app.app_data)

						if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
					}
				} "image", "map" {
					if key.to_lower()=="enter" || key==" " {
						object["fn"].fun(EventDetails{event:"keypress",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:true.str()},mut app, mut app.app_data)
					}
				} else {}
			}
		}
	}
}

[unsafe]
fn resized_fn(event &gg.Event, mut app &Window){
	unsafe{
		app.get_object_by_id("@scrollbar:horizontal")[0]["sThum"].num=event.window_width
		app.get_object_by_id("@scrollbar:vertical")[0]["sThum"].num=event.window_height
	}
}

[unsafe]
fn keydown_fn(c gg.KeyCode, m gg.Modifier, mut app &Window){
	//super := m == .super
	shift := m == .shift
	//alt   := m == .alt
	//ctrl  := m == .ctrl
	mut key:=""
	match c{
		.tab {
			unsafe {
				if shift {
					app.focus=app.get_previous_object_by_id(app.focus)[0]["id"].str
					if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
				} else {
					app.focus=app.get_next_object_by_id(app.focus)[0]["id"].str
					if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
				}
			}
		}
		.menu  { key="menu" }
		.right { key="right"}
		.left  { key="left" }
		.down  { key="down" }
		.up    { key="__up" }
		.enter { key="enter"}
		.escape{key="escape"}
		.backspace{ key="\b"}
		.delete{key="\1"}
		else {}
	}
	if key!=""{
		unsafe {
			keyboard_fn(key,mut app)
		}
	}
}

pub fn run(mut app &Window){
	app.gg.run()
}
