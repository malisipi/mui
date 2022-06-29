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

[unsafe]
pub fn (mut app Window) clear_values (id []string){
	unsafe{
		for widget_id in id{
			clear_values(mut app, widget_id)
		}
	}
}
