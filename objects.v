module mui

fn get_object_by_id(app &Window, id string) map[string]WindowData{
	unsafe{
		for object in app.objects{
			if object["id"].str==id {
				return object
			}
		}
	}
    return null_object
}

pub fn (mut app Window) get_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_object_by_id(app, id)]
	}
}

fn get_dialog_object_by_id(app &Window, id string) map[string]WindowData{
	unsafe{
		for object in app.dialog_objects{
			if object["id"].str==id {
				return object
			}
		}
	}
    return null_object
}

pub fn (mut app Window) get_dialog_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_dialog_object_by_id(app, id)]
	}
}

pub fn (mut app Window) remove_object_by_id(id string){
	unsafe{
		app_objects:=[]map[string]WindowData{}
		for object in app.objects{
			if object["id"].str!=id{
				app_objects << object
			}
		}
		app.objects=app_objects
	}
}

pub fn (mut app Window) remove_dialog_object_by_id(id string){
	unsafe{
		app_objects:=[]map[string]WindowData{}
		for object in app.dialog_objects{
			if object["id"].str!=id{
				app_objects << object
			}
		}
		app.objects=app_objects
	}
}

fn clear_values(mut app Window, id string){
	unsafe{
		mut object:=app.get_object_by_id(id)[0]
		match object["type"].str{
			"progress"{
				object["perc"].num=0
			}"textbox"{
				object["text"].str="\0"
			}"password"{
				object["text"].str="\0"
			}"checkbox"{
				object["c"].bol=false
			}"selectbox"{
				object["s"].num=0
				object["text"].str=object["list"].str.split("\0")[0]
			}"slider"{
				object["val"].num=object["vlMin"].num
			}"hidden"{
				if object["realT"].str=="radio"{
					object["s"].num=0
					for box in 0..object["len"].num{
						app.get_object_by_id(id+"_"+box.str())[0]["c"].bol=box==0
					}
				}
			} else {}
		}
	}
}

fn get_previous_object_by_id(app &Window, _id string) map[string]WindowData{
	unsafe{
		mut id:=_id
		if app.get_object_by_id(_id)[0]["type"].str=="radio"{
			id=_id.split("_")#[0..-1].join("_")
		}

		mut previous_object:=null_object.clone()
		for object in app.objects{
			if object["id"].str==id {
				if previous_object==null_object {
					continue
				}
				if previous_object["type"].str=="hidden" && previous_object["realT"].str=="radio"{
					return app.get_object_by_id(previous_object["id"].str+"_"+previous_object["s"].num.str())[0]
				}
				return previous_object
			}

			if object["type"].str!="rect" && object["type"].str!="group" && object["type"].str!="table" && object["type"].str!="radio"{
				previous_object=object.move()
			}
		}

		if previous_object["type"].str=="hidden" && previous_object["realT"].str=="radio"{
			return app.get_object_by_id(previous_object["id"].str+"_"+previous_object["s"].num.str())[0]
		}
		return previous_object
	}
}


fn get_previous_dialog_object_by_id(app &Window, _id string) map[string]WindowData{
	unsafe{
		mut id:=_id
		if app.get_dialog_object_by_id(_id)[0]["type"].str=="radio"{
			id=_id.split("_")#[0..-1].join("_")
		}

		mut previous_object:=null_object.clone()
		for object in app.dialog_objects{
			if object["id"].str==id {
				if previous_object==null_object {
					continue
				}
				if previous_object["type"].str=="hidden" && previous_object["realT"].str=="radio"{
					return app.get_dialog_object_by_id(previous_object["id"].str+"_"+previous_object["s"].num.str())[0]
				}
				return previous_object
			}

			if object["type"].str!="rect" && object["type"].str!="group" && object["type"].str!="table" && object["type"].str!="radio"{
				previous_object=object.move()
			}
		}

		if previous_object["type"].str=="hidden" && previous_object["realT"].str=="radio"{
			return app.get_dialog_object_by_id(previous_object["id"].str+"_"+previous_object["s"].num.str())[0]
		}
		return previous_object
	}
}

fn get_next_object_by_id(app &Window, id string) map[string]WindowData{
	unsafe{
		mut temp:=app.focus==""
		for object in app.objects{
			if temp{
				if object["type"].str!="rect" && object["type"].str!="group" && object["type"].str!="table" && object["type"].str!="radio"{
					if object["type"].str=="hidden" && object["realT"].str=="radio"{
						return app.get_object_by_id(object["id"].str+"_"+object["s"].num.str())[0]
					}
					return object
				}
			}
			if object["id"].str==id {
				temp=true
			}
		}
	}
    return null_object
}

fn get_next_dialog_object_by_id(app &Window, id string) map[string]WindowData{
	unsafe{
		mut temp:=app.focus==""
		for object in app.dialog_objects{
			if temp{
				if object["type"].str!="rect" && object["type"].str!="group" && object["type"].str!="table" && object["type"].str!="radio"{
					if object["type"].str=="hidden" && object["realT"].str=="radio"{
						return app.get_object_by_id(object["id"].str+"_"+object["s"].num.str())[0]
					}
					return object
				}
			}
			if object["id"].str==id {
				temp=true
			}
		}
	}
    return null_object
}

pub fn (mut app Window) get_previous_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_previous_object_by_id(app, id)]
	}
}

pub fn (mut app Window) get_next_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_next_object_by_id(app, id)]
	}
}

pub fn (mut app Window) get_previous_dialog_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_previous_dialog_object_by_id(app, id)]
	}
}

pub fn (mut app Window) get_next_dialog_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_next_dialog_object_by_id(app, id)]
	}
}

pub fn (mut app Window) clear_values (id []string){
	unsafe{
		for widget_id in id{
			clear_values(mut app, widget_id)
		}
	}
}

pub fn (mut app Window) remove_all_objects () {
	app.objects.clear()
	app.dialog_objects.clear()
	app.focus=""
	app.scrollbar(Widget{ id:"@scrollbar:horizontal", x:"!& 0", y:"!&# 0", width:"! 100%x -15", height:"! 15", value_max:0, onchange: update_scroll_hor, z_index:999999, hidden:true})
	app.scrollbar(Widget{ id:"@scrollbar:vertical", x:"!&# 0", y:"!& 0", width:"! 15", height:"! 100%y -15", value_max:0, onchange: update_scroll_ver, vertical:true, z_index:999999, hidden:true})
	app.rect(Widget{ id:"@scrollbar:extra", x:"!&# 0", y:"!&# 0", width:"15", height:"15", background: app.color_scheme[1], z_index:999999, hidden:true})
}

pub fn (mut app Window) clone_app_objects () []map[string]WindowData {
	return app.objects.clone()
}

pub fn (mut app Window) load_app_objects (app_objects []map[string]WindowData) {
	app.objects = app_objects.clone()
}
