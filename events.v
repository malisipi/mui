module mui

import gg
import math
import os
import sokol.sapp

[unsafe]
fn click_fn(x f32, y f32, mb gg.MouseButton, mut app &Window) {
	app.native_focus = false
	unsafe{
		if app.focus!="" && app.active_dialog=="" {
			object := get_object_by_id(app, app.focus)
			if object != null_object && object["type"].str=="selectbox" && $if windows { int(app.draw_mode)&1 == 0 } $else { true } {
				mut old_focused_object:=get_object_by_id(app, app.focus)
				app.focus=""
				the_list := old_focused_object["list"].str.split("\0")
				total_items:=the_list.len
				list_x:=old_focused_object["x"].num
				list_y:=old_focused_object["y"].num+old_focused_object["h"].num
				list_height:=total_items*old_focused_object["h"].num
				list_width:=old_focused_object["w"].num
				if list_x<x && list_x+list_width>x {
					if list_y<y && list_y+list_height>y {
						old_focused_object["s"]=WindowData{num:int((y-list_y)/(list_height/total_items))}
						old_focused_object["text"]=WindowData{str:the_list[old_focused_object["s"].num]}
						old_focused_object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",value:old_focused_object["text"].str,target_type:old_focused_object["type"].str,target_id:old_focused_object["id"].str},mut app, mut app.app_data)
						return
					}
				}
			} else if app.focus.starts_with("@menubar#") && $if windows { int(app.draw_mode)&1 == 0 } $else { true } {
				selected_item:=app.focus.replace("@menubar#","").int()
				if x>=app.menubar_config.width*selected_item && x<=app.menubar_config.width*selected_item+app.menubar_config.sub_width {
					menubar_sub_items_len:=app.menubar[selected_item]["items"].lst.len
					if y>=app.menubar_config.height && y<=app.menubar_config.height*(menubar_sub_items_len+1){
						app.menubar[selected_item]["items"].lst[int(y-app.menubar_config.height)/app.menubar_config.height]["fn"].fun(EventDetails{event:"click",trigger:"mouse_left",value:"true",target_type:"menubar",target_id:"menubar"},mut app, mut app.app_data)
					}
				}
				app.focus=""
				return
			}

		}
		app.focus=""

		if app.active_dialog=="" && y<=app.menubar_config.height && app.menubar!=[]map["string"]WindowData{}{
			menu_items:=app.menubar.len
			if x<menu_items*app.menubar_config.width{
				app.focus="@menubar#"+(x/app.menubar_config.width).str()
				return
			}
		}

		if mb==gg.MouseButton.left{
			mut objects:=app.objects.clone().reverse()
			if app.active_dialog!=""{
				objects=app.dialog_objects.clone().reverse()
			}
			for mut object in objects{
				if !object["hi"].bol && object["type"].str!="rect" && object["type"].str!="frame" && object["type"].str!="group" && object["type"].str!="table"{
					if object["x"].num<x && object["x"].num+object["w"].num>x{
						if object["y"].num<y && object["y"].num+object["h"].num>y{
							if object["in"].str != "" {
								frame_x:=app.get_object_by_id(object["in"].str)[0]["x"].num
								frame_y:=app.get_object_by_id(object["in"].str)[0]["y"].num
								frame_w:=app.get_object_by_id(object["in"].str)[0]["w"].num
								frame_h:=app.get_object_by_id(object["in"].str)[0]["h"].num
								if frame_x > x || frame_x + frame_w < x || frame_y > y || frame_y + frame_h < y {
									continue
								}
							}
							if object["type"].str!="rect" {
								app.focus=object["id"].str
							}
							$if android{
								match object["type"].str{
									"textbox", "password", "textarea" {
										show_keyboard(true)
									} else {
										show_keyboard(false)
									}
								}
							}
							match object["type"].str{
								"button" {
									object["fn"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:true.str()},mut app, mut app.app_data)
								} "checkbox", "switch" {
									object["c"]=WindowData{bol:!object["c"].bol}
									object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["c"].bol.str()},mut app, mut app.app_data)
								} "slider" {
									if !object["vert"].bol {
										object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(x-object["x"].num,0),object["w"].num))/f32(object["w"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
									} else {
										object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(y-object["y"].num,0),object["h"].num))/f32(object["h"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
									}
									object["click"]=WindowData{bol:true}
									object["fnclk"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()}, mut app, mut app.app_data)
									object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()}, mut app, mut app.app_data)
								} "scrollbar" {
									if !object["vert"].bol {
										object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(x-object["x"].num,0),object["w"].num))/f32(object["w"].num/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num-object["sThum"].num)}
									} else {
										object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(y-object["y"].num,0),object["h"].num))/f32(object["h"].num/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num-object["sThum"].num)}
									}
									object["click"]=WindowData{bol:true}
									object["fnclk"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()}, mut app, mut app.app_data)
									object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()}, mut app, mut app.app_data)
								} "label"{
									object["fnclk"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:true.str()},mut app, mut app.app_data)
								} "link"{
									object["fnclk"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:true.str()},mut app, mut app.app_data)
									go os.open_uri(object["link"].str)
								} "textbox", "password", "spinner" {
									if object["type"].str == "spinner" {
										if x-object["x"].num-object["w"].num > -16 {
											if object["h"].num / 2 > (y-object["y"].num) {
												object["text"].str = (object["text"].str.replace("\0","").int() + 1).str()
											} else {
												object["text"].str = (object["text"].str.replace("\0","").int() - 1).str()
											}
											return
										}
									}
									the_text:=object["text"].str.replace("\0","")
									app.gg.set_text_cfg(size:object["tSize"].num)
									if the_text.len>0{
										mut split_char:=0
										if !(object["type"].str=="password") { //textbox & spinner
											split_char=math.min(int(math.round((x-4-object["x"].num)/((app.gg.text_width(the_text)+2)/the_text.runes().len))),the_text.runes().len)
										} else {
											split_char=math.min(int(math.round((x-4-object["x"].num)/((app.gg.text_width(object["hc"].str)*the_text.runes().len+2)/the_text.runes().len))),the_text.runes().len)
										}
										object["text"]=WindowData{str:the_text.runes()[0..split_char].string()+"\0"+the_text.runes()[split_char..math.min(99999,the_text.runes().len)].string()}
									} else {
										object["text"]=WindowData{str:"\0"}
									}
								} "textarea"{
									the_text:=object["text"].str.replace("\0","")
									app.gg.set_text_cfg(size:object["tSize"].num, mono:object["code"].bol)
									if the_text.len>0{
										rows:=the_text.split("\n")
										which_row:=int(math.min(math.max(y+object["schsl"].num-object["y"].num-4,0)/20,rows.len-1))
										row_text:=the_text.split("\n")[which_row]
										mut edited_row:="\0"
										if row_text.len>0{
											split_char:=math.min(int(math.round((x-4-object["x"].num)/((app.gg.text_width(row_text)+2)/row_text.runes().len))),row_text.runes().len)
											edited_row=row_text.runes()[0..split_char].string()+"\0"+row_text.runes()[split_char..math.min(99999,row_text.runes().len)].string()
										}
										before_rows:=if rows#[0..which_row].len>0 { rows#[0..which_row].join("\n") } else { "" }
										after_rows:=if rows#[which_row+1..].len>0 { rows#[which_row+1..].join("\n") } else { "" }
										latest_text:=before_rows+if before_rows!="" {"\n"} else {""}+edited_row+if after_rows!="" {"\n"} else {""}+after_rows
										object["text"]=WindowData{str:latest_text}
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
								} "list" {
									object["s"].num = int(y-object["y"].num+object["schsl"].num) / int(if object["row_h"].num==-1 { object["h"].num / object["table"].tbl.len } else {object["row_h"].num})
									object["fnchg"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str,value:object["s"].num.str()},mut app, mut app.app_data)
								} "image", "map" {
									object["fn"].fun(EventDetails{event:"click",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str,value:true.str()},mut app, mut app.app_data)
								} else {
									for widget in app.custom_widgets{
										if object["type"].str==widget.typ{
											widget.click_fn(x, y, mut object, app)
										}
									}
								}
							}
							break
						}
					}
				}
			}
		}
	}
	$if power_save ? {
		app.redraw_required = true
	}
}

[unsafe]
fn move_fn(x f32, y f32, mut app &Window){
	unsafe{
		mut objects:=app.objects.clone().reverse()
		if app.active_dialog!=""{
			objects=app.dialog_objects.clone().reverse()
		}

		mut changed_cursor:=false
		for mut object in objects{
			if !object["hi"].bol && object["type"].str!="rect" && object["type"].str!="group" && object["type"].str!="table"{
				if object["x"].num<x && object["x"].num+object["w"].num>x{
					if object["y"].num<y && object["y"].num+object["h"].num>y{
						match object["type"].str {
							"textbox", "password", "textarea"{
								sapp.set_mouse_cursor(.ibeam)
								changed_cursor=true
								break
							} "link" {
								sapp.set_mouse_cursor(.pointing_hand)
								changed_cursor=true
								break
							} else {
								sapp.set_mouse_cursor(.default)
								changed_cursor=true
								break
							}
						}
					}
				}
			}
		}
		if !changed_cursor { sapp.set_mouse_cursor(.default) }
		if !(app.focus==""){
			mut object:=get_object_by_id(app,app.focus)
			if object != null_object {
				if app.active_dialog!=""{
					object=get_dialog_object_by_id(app,app.focus)
				}
				if object["type"].str=="slider"{
					if object["click"].bol {
						if !object["vert"].bol {
							object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(x-object["x"].num,0),object["w"].num))/f32(object["w"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
						} else {
							object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(y-object["y"].num,0),object["h"].num))/f32(object["h"].num/(f32(object["vlMax"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num)}
						}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str,value:object["val"].num.str()},mut app, mut app.app_data)
						$if power_save ? {
							app.redraw_required = true
						}
					}
				} else if object["type"].str=="scrollbar"{
					if object["click"].bol {
						if !object["vert"].bol {
							object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(x-object["x"].num,0),object["w"].num))/f32(object["w"].num/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num-object["sThum"].num)}
						} else {
							object["val"]=WindowData{num:math.min(int(math.round(f32(math.min(math.max(y-object["y"].num,0),object["h"].num))/f32(object["h"].num/(f32(object["vlMax"].num-object["sThum"].num-object["vlMin"].num)/object["vStep"].num))))*object["vStep"].num+object["vlMin"].num,object["vlMax"].num-object["sThum"].num)}
						}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str,value:object["val"].num.str()},mut app, mut app.app_data)
						$if power_save ? {
							app.redraw_required = true
						}
					}
				} else {
					for widget in app.custom_widgets{
						if object["type"].str==widget.typ{
							widget.move_fn(x, y, mut object, app)
						}
					}
				}
			}
		}
	}
}

[unsafe]
fn unclick_fn(x f32, y f32, mb gg.MouseButton, mut app &Window){
	unsafe{
		if !(app.focus==""){
			mut object:=get_object_by_id(app,app.focus)
			if object != null_object {
				if app.active_dialog!=""{
					object=get_dialog_object_by_id(app,app.focus)
				}
				if object["type"].str=="slider" || object["type"].str=="scrollbar"{
					object["click"]=WindowData{bol:false}
					object["fnucl"].fun(EventDetails{event:"unclick",trigger:"mouse_left",target_type:object["type"].str,target_id:object["id"].str, value:object["val"].num.str()},mut app, mut app.app_data)
				}
				for widget in app.custom_widgets{
					if object["type"].str==widget.typ{
						widget.unclick_fn(x, y, mut object, app)
					}
				}
			}
		}
	}
	$if power_save ? {
		app.redraw_required = true
	}
}

[unsafe]
fn event_fn(event &gg.Event, mut app &Window){
	if event.typ == sapp.EventType.files_droped{
		for q in 0..dropped_files_len(){
			app.file_handler(EventDetails{event:"files_drop",trigger:"mouse_left", value:dropped_file_path(q)},mut app, mut app.app_data)
		}
	} else if event.typ == sapp.EventType.quit_requested {
		$if !android {
			sapp.cancel_quit()
			if app.ask_quit {
				if messagebox("Quit?", "Do you want to quit?", "yesno", "quit")==0 { //if no
					return
				}
			}
			app.quit_fn(EventDetails{event:"quit",trigger:"quit",value:"true"},mut app, mut app.app_data)
			sapp.quit()
		}
	} else if event.typ == sapp.EventType.touches_began {
		unsafe {
			click_fn(event.touches[0].pos_x/app.gg.scale,event.touches[0].pos_y/app.gg.scale, gg.MouseButton.left, mut app)
		}
	} else if event.typ == sapp.EventType.touches_moved {
		unsafe {
			move_fn(event.touches[0].pos_x/app.gg.scale,event.touches[0].pos_y/app.gg.scale, mut app)
		}
	} else if event.typ == sapp.EventType.touches_ended {
		unsafe {
			unclick_fn(event.touches[0].pos_x/app.gg.scale,event.touches[0].pos_y/app.gg.scale, gg.MouseButton.left, mut app)
		}
	}
}

fn init_fn(mut app &Window){
	app.init_fn(EventDetails{event:"init",trigger:"init",value:"true"},mut app, mut app.app_data)
}

[unsafe]
fn scroll_fn(event &gg.Event, mut app &Window){
	unsafe{
		if app.scrollbar {
			shift_press:=event.modifiers&1<<0==1
			if event.scroll_x!=0 || shift_press {
				mut scrollbar_horizontal:=app.get_object_by_id("@scrollbar:horizontal")[0]
				app.scroll_x=math.max(math.min(int(scrollbar_horizontal["val"].num+if !shift_press {event.scroll_x} else {event.scroll_y}*-50),scrollbar_horizontal["vlMax"].num-scrollbar_horizontal["sThum"].num), scrollbar_horizontal["vlMin"].num)
				scrollbar_horizontal["val"].num=app.scroll_x
			} else {
				mut scrollbar_vertical:=app.get_object_by_id("@scrollbar:vertical")[0]
				app.scroll_y=math.max(math.min(int(scrollbar_vertical["val"].num+event.scroll_y*-50),scrollbar_vertical["vlMax"].num-scrollbar_vertical["sThum"].num), scrollbar_vertical["vlMin"].num)
				scrollbar_vertical["val"].num=app.scroll_y
			}
		}
	}
	$if power_save ? {
		app.redraw_required = true
	}
}

[unsafe]
fn char_fn(chr u32, mut app &Window){
	unsafe {
		$if android{
			return
		}
		if app.gg.key_modifiers==.ctrl {
			chr_keybinding:="ctrl|"+utf32_to_str(chr).to_lower()
			if app.keybindings[chr_keybinding].num!=120 {
				app.keybindings[chr_keybinding].fun(EventDetails{event:"keypress",trigger:"keyboard",value:chr_keybinding}, mut app, mut app.app_data)
			}
		} else {
			keyboard_fn(chr, mut app)
		}
	}
}

[unsafe]
fn keyboard_fn(chr U32OrString, mut app &Window){
	unsafe{
		if app.focus!="" {
			mut object:=get_object_by_id(app,app.focus)
			if app.active_dialog!=""{
				object=get_dialog_object_by_id(app,app.focus)
			}

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
				"textbox","password", "spinner" {
					if key.runes().len<2{
						if object["type"].str=="spinner" {
							if !(key in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "\b", "\1"]) {
								return
							}
							object["text"].str.index("\0") or {
								object["text"].str += "\0"
							}
						}
						the_text:=object["text"].str
						the_text_part1,the_text_part2:=the_text.split("\0")[0],the_text.split("\0")[1]
						if key!="\b" && key!="\1" {
							if is_system_language_japanese() {
								object["text"]=WindowData{str:replace_romanji_with_hiragana(the_text_part1+key+"\0"+the_text_part2)}
							} else {
								object["text"]=WindowData{str:the_text_part1+key+"\0"+the_text_part2}
							}
						} else if key=="\b" {
							object["text"]=WindowData{str:the_text_part1.runes()#[0..-1].string()+"\0"+the_text_part2}
						} else {
							object["text"]=WindowData{str:the_text_part1+"\0"+the_text_part2.runes()#[1..].string()}
						}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["text"].str.replace("\0","")},mut app, mut app.app_data)
					} else if key=="right" || key=="left"{
						if object["type"].str=="spinner" {
							object["text"].str.index("\0") or {
								object["text"].str += "\0"
							}
						}
						the_text:=object["text"].str
						the_text_part1,the_text_part2:=the_text.split("\0")[0].runes(),the_text.split("\0")[1].runes()
						if key.to_lower()=="right" {
							if the_text_part2.len==0 { return }
							object["text"]=WindowData{str:the_text_part1.string()+the_text_part2[0..1].string()+"\0"+the_text_part2[1..the_text_part2.len].string()}
						} else {
							if the_text_part1.len==0 { return }
							object["text"]=WindowData{str:the_text_part1#[0..-1].string()+"\0"+the_text_part1[the_text_part1.len-1..the_text_part1.len].string()+the_text_part2.string()}
						}
					} else if (key=="down" || key=="__up") && object["type"].str=="spinner" {
						if key == "__up" {
							object["text"].str = (object["text"].str.replace("\0","").int() + 1).str()
						} else {
							object["text"].str = (object["text"].str.replace("\0","").int() - 1).str()
						}
					}
				} "textarea" {
					if key.runes().len<2 || key=="enter"{
						if key=="enter" { key="\n" }
						the_text:=object["text"].str
						the_text_part1,the_text_part2:=the_text.split("\0")[0],the_text.split("\0")[1]
						if key!="\b" && key!="\1" {
							if is_system_language_japanese() {
								object["text"]=WindowData{str:replace_romanji_with_hiragana(the_text_part1+key+"\0"+the_text_part2)}
							} else {
								object["text"]=WindowData{str:the_text_part1+key+"\0"+the_text_part2}
							}
						} else if key=="\b" {
							object["text"]=WindowData{str:the_text_part1.runes()#[0..-1].string()+"\0"+the_text_part2}
						} else {
							object["text"]=WindowData{str:the_text_part1+"\0"+the_text_part2.runes()#[1..].string()}
						}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["text"].str.replace("\0","")},mut app, mut app.app_data)
					} else if key=="right" || key=="left"{
						the_text:=object["text"].str
						the_text_part1,the_text_part2:=the_text.split("\0")[0].runes(),the_text.split("\0")[1].runes()
						if key=="right" {
							if the_text_part2.len==0 { return }
							object["text"]=WindowData{str:the_text_part1.string()+the_text_part2[0..1].string()+"\0"+the_text_part2[1..the_text_part2.len].string()}
						} else {
							if the_text_part1.len==0 { return }
							object["text"]=WindowData{str:the_text_part1#[0..-1].string()+"\0"+the_text_part1[the_text_part1.len-1..the_text_part1.len].string()+the_text_part2.string()}
						}
					} else if key=="down" || key=="__up"{
						the_text:=object["text"].str
						rows:=the_text.split("\n")
						mut cursor_loc:=[-1,-1]
						for which_row, row in rows {
							cursor:=row.index("\0") or {-1}
							if cursor!=-1 { cursor_loc=[which_row,cursor] }
						}
						mut latest_text:=""
						if key=="down"{
							if cursor_loc[0]!=rows.len-1 {
								latest_text=rows#[0..math.max(cursor_loc[0]+1,0)].join("\n").replace("\0","")
								if latest_text!="" {latest_text+="\n"}
								edited_row:=rows#[cursor_loc[0]+1..cursor_loc[0]+2][0]
								latest_text+=edited_row.runes()#[0..cursor_loc[1]].string()+"\0"+edited_row.runes()#[cursor_loc[1]..].string()
								after_rows:=rows#[cursor_loc[0]+2..].join("\n").replace("\0","")
								if after_rows!="" {
									latest_text+="\n"+after_rows
								}
							} else {
								latest_text=the_text.replace("\0","")+"\0"
							}
						} else {
							if cursor_loc[0]!=0{
								latest_text=rows#[0..math.max(cursor_loc[0]-1,0)].join("\n")
								if latest_text!="" {latest_text+="\n"}
								edited_row:=rows#[cursor_loc[0]-1..cursor_loc[0]][0]
								latest_text+=edited_row.runes()#[0..cursor_loc[1]].string()+"\0"+edited_row.runes()#[cursor_loc[1]..].string()
								after_rows:=rows#[cursor_loc[0]..].join("\n").replace("\0","")
								if after_rows!="" {
									latest_text+="\n"+after_rows
								}
							} else {
								latest_text="\0"+the_text.replace("\0","")
							}
						}
						object["text"]=WindowData{str:latest_text}
					}
				} "button" {
					if key=="enter" || key==" " {
						object["fn"].fun(EventDetails{event:"keypress",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:true.str()},mut app, mut app.app_data)
					}
				} "checkbox", "switch" {
					if key=="enter" || key==" " {
						object["c"]=WindowData{bol:!object["c"].bol}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["c"].bol.str()},mut app, mut app.app_data)
					}
				} "slider","scrollbar" {
					if key=="left" {
						object["val"]=WindowData{num:math.max(object["vlMin"].num,object["val"].num-object["vStep"].num)}
						object["fnchg"].fun(EventDetails{event:"value_change",trigger:"keyboard",target_type:object["type"].str,target_id:object["id"].str,value:object["val"].num.str()},mut app, mut app.app_data)
					} else if key=="right" {
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
	$if power_save ? {
		app.redraw_required = true
	}
}

[unsafe]
fn resized_fn(event &gg.Event, mut app &Window){
	unsafe{
		app.resized_fn(EventDetails{event:"resize",trigger:"mouse_left",value:event.window_width.str()+","+event.window_height.str()},mut app, mut app.app_data)
		app.get_object_by_id("@scrollbar:horizontal")[0]["sThum"].num=event.window_width
		app.get_object_by_id("@scrollbar:vertical")[0]["sThum"].num=event.window_height
	}
	$if power_save ? {
		app.redraw_required = true
	}
}

[unsafe]
fn keydown_fn(c gg.KeyCode, m gg.Modifier, mut app &Window){
	//super := m == .super
	shift := m == .shift
	//alt   := m == .alt
	//ctrl  := m == .ctrl
	mut key:=""
	$if !android {
		match c{
			.tab {
				unsafe {
					app.native_focus = false
					if app.active_dialog!=""{
						if shift {
							app.focus=app.get_previous_dialog_object_by_id(app.focus)[0]["id"].str
							if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
						} else {
							app.focus=app.get_next_dialog_object_by_id(app.focus)[0]["id"].str
							if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
						}
					} else {
						if shift {
							app.focus=app.get_previous_object_by_id(app.focus)[0]["id"].str
							if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
						} else {
							app.focus=app.get_next_object_by_id(app.focus)[0]["id"].str
							if app.screen_reader { screen_reader_read(app.screen_reader_parse_text(app.focus)) }
						}
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
	} $else {
		match c {
			.space{ key=" "}
			.a { key="a" }
			.b { key="b" }
			.c { key="c" }
			.d { key="d" }
			.e { key="e" }
			.f { key="f" }
			.g { key="g" }
			.h { key="h" }
			.i { key="i" }
			.j { key="j" }
			.k { key="k" }
			.l { key="l" }
			.m { key="m" }
			.n { key="n" }
			.o { key="o" }
			.p { key="p" }
			.r { key="r" }
			.s { key="s" }
			.t { key="t" }
			.u { key="u" }
			.v { key="v" }
			.y { key="y" }
			.z { key="z" }
			.x { key="x" }
			.q { key="q" }
			.w { key="w" }
			._0 { key= if shift {")"} else {"0"} }
			._1 { key= if shift {"!"} else {"1"} }
			._2 { key= if shift {"@"} else {"2"} }
			._3 { key= if shift {"#"} else {"3"} }
			._4 { key= if shift {"$"} else {"4"} }
			._5 { key= if shift {"%"} else {"5"} }
			._6 { key= if shift {"^"} else {"6"} }
			._7 { key= if shift {"&"} else {"7"} }
			._8 { key= if shift {"*"} else {"8"} }
			._9 { key= if shift {"("} else {"9"} }
			.left_bracket { key= if shift {"{"} else {"["} }
			.right_bracket { key= if shift {"}"} else {"]"} }
			.grave_accent { key= if shift {"~"} else {"`"} }
			.backslash { key= if shift {"|"} else {"\\"} }
			.kp_0 { key="0" }
			.kp_1 { key="1" }
			.kp_2 { key="2" }
			.kp_3 { key="3" }
			.kp_4 { key="4" }
			.kp_5 { key="5" }
			.kp_6 { key="6" }
			.kp_7 { key="7" }
			.kp_8 { key="8" }
			.kp_9 { key="9" }
			.apostrophe { key= if shift {"\""} else {"'"} }
			.comma { key= if shift {"<"} else {","} }
			.period { key= if shift {">"} else {"."} }
			.minus { key= if shift {"_"} else {"-"} }
			.slash { key= if shift {"?"} else {"/"} }
			.semicolon { key= if shift {":"} else {";"} }
			.equal { key= if shift {"+"} else {"="} }
			.escape { key="escape" }
			.enter { key="enter" }
			.tab { key="tab" }
			.backspace { key="\b" }
			.kp_divide { key="/" }
			.kp_equal { key="=" }
			.kp_add { key="+" }
			.kp_multiply { key="*" }
			.kp_subtract { key="-" }
			.menu { key="menu" }
			.right { key="right" }
			.left { key="left" }
			.down { key="down" }
			.up { key="up" }
			else {}
		}

		if shift {
			if key.len>1{
                unsafe {
                    keyboard_fn(key,mut app)
                }
			} else {
                unsafe {
                    keyboard_fn(key.to_upper(),mut app)
                }
			}
		} else {
            unsafe {
                keyboard_fn(key,mut app)
            }
		}
	}
}
