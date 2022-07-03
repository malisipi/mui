module mui

[unsafe]
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

[unsafe]
pub fn (mut app Window) get_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_object_by_id(app, id)]
	}
}

[unsafe]
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

[unsafe]
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
				if previous_object["realT"].str=="radio"{
					return app.get_object_by_id(previous_object["id"].str+"_"+previous_object["s"].num.str())[0]
				}
				return previous_object
			}

			if object["type"].str!="rect" && object["type"].str!="group" && object["type"].str!="table" && object["type"].str!="radio"{
				previous_object=object.move()
			}
		}

		if previous_object["realT"].str=="radio"{
			return app.get_object_by_id(previous_object["id"].str+"_"+previous_object["s"].num.str())[0]
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
					if object["realT"].str=="radio"{
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

[unsafe]
pub fn (mut app Window) get_previous_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_previous_object_by_id(app, id)]
	}
}

[unsafe]
pub fn (mut app Window) get_next_object_by_id(id string) []map[string]WindowData{
	unsafe{
		return [get_next_object_by_id(app, id)]
	}
}

[unsafe]
pub fn (mut app Window) clear_values (id []string){
	unsafe{
		for widget_id in id{
			clear_values(mut app, widget_id)
		}
	}
}
