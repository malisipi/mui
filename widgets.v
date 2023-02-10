module mui

pub fn (mut app Window) rect ( args Widget ){
	add_rect (mut app, args.id, args.x, args.y, args.width, args.height, args.hidden, args.background, args.dialog, args.frame, args.z_index-2)
}

pub fn (mut app Window) frame ( args Widget ){
	add_frame (mut app, args.id, args.x, args.y, args.width, args.height, args.hidden, args.background, args.dialog, args.frame, args.z_index, args.view_area)
}

pub fn (mut app Window) line_graph ( args Widget ){ //dialog support not done
	add_line_graph (mut app, args.id, args.x, args.y, args.width, args.height, args.hidden, args.graph_title, args.graph_label, args.graph_data, args.graph_color, args.graph_names, args.background, app.color_scheme[3], args.frame, args.z_index)
}

pub fn (mut app Window) area_graph ( args Widget ){ //dialog support not done
	add_area_graph (mut app, args.id, args.x, args.y, args.width, args.height, args.hidden, args.graph_title, args.graph_label, args.graph_data, args.graph_color, args.graph_names, args.background, app.color_scheme[3], args.frame, args.z_index)
}

pub fn (mut app Window) table ( args Widget ){ //dialog support not done
	add_table (mut app, args.table, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[0], app.color_scheme[2], app.color_scheme[3], args.frame, args.z_index, args.text_size, args.row_height)
}

pub fn (mut app Window) list ( args Widget ){ //dialog support not done
	add_list (mut app, args.table, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[0], app.color_scheme[2], app.color_scheme[3], args.frame, args.z_index, args.onchange, args.selected, args.text_size, args.row_height)
}

pub fn (mut app Window) group ( args Widget ){ //dialog support not done
	add_group (mut app, args.id, args.text, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[0], app.color_scheme[2], app.color_scheme[3], args.frame, args.z_index-1)
}

pub fn (mut app Window) label ( args Widget ){
	add_label (mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[3], args.onclick, args.dialog, args.text_size, args.text_align, args.text_multiline, args.frame, args.z_index)
}

pub fn (mut app Window) button ( args Widget ){
	add_button (mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[1], app.color_scheme[3], args.onclick, args.icon, args.dialog, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) image ( args Widget ){ //dialog support not done
	add_image (mut app, args.path, args.id, args.x, args.y, args.width, args.height, args.hidden, args.onclick, args.frame, args.z_index)
}

pub fn (mut app Window) map ( args Widget ){ //dialog support not done
	add_map (mut app, args.zoom, args.latitude, args.longitude, args.id, args.x, args.y, args.width, args.height, args.hidden, args.onclick, args.frame, args.z_index)
}

pub fn (mut app Window) progress ( args Widget ){
	add_progress (mut app, args.percent, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[1], app.color_scheme[2],  app.color_scheme[3], args.dialog, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) textbox ( args Widget ){
	add_textbox (mut app, args.text, args.id, args.placeholder, args.ph_as_text, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1], app.color_scheme[3], args.onchange, args.dialog, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) spinner ( args Widget ){
	add_spinner (mut app, args.text, args.id, args.placeholder, args.ph_as_text, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1], app.color_scheme[3], args.onchange, args.dialog, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) textarea ( args Widget ){ //dialog support not done
	add_textarea (mut app, args.text, args.id, args.placeholder, args.ph_as_text, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1], app.color_scheme[3], args.onchange, args.codefield, args.text_size, args.frame, args.z_index)
}

pub fn (mut app Window) password ( args Widget ){
	add_password (mut app, args.text, args.hider_char, args.id, args.placeholder, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1], app.color_scheme[3], args.onchange, args.dialog, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) checkbox ( args Widget ){ //dialog support not done
	add_checkbox(mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.checked , args.hidden, app.color_scheme[1], app.color_scheme[2], app.color_scheme[3], args.onchange, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) switch ( args Widget ){ //dialog support not done
	add_switch(mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.checked , args.hidden, app.color_scheme[1], app.color_scheme[2], app.color_scheme[3], args.onchange, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) radio ( args Widget ){ //dialog support not done
	add_radio(mut app, args.list, args.id, args.x, args.y, args.height, args.selected , args.hidden, app.color_scheme[1], app.color_scheme[2], app.color_scheme[3], args.onchange, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) selectbox ( args Widget ){ //dialog support not done
	add_selectbox(mut app, args.text, args.list, args.selected, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1],  app.color_scheme[3], args.onchange, args.frame, args.z_index)
}

pub fn (mut app Window) slider ( args Widget ){
	add_slider(mut app, args.value, args.value_min, args.value_max, args.step, args.id, args.x, args.y, args.width, args.height, args.vertical, args.hidden, app.color_scheme[1], app.color_scheme[2], app.color_scheme[3], args.onclick, args.onchange, args.onunclick, args.value_map, args.dialog, args.frame, args.z_index, args.text_size)
}

pub fn (mut app Window) scrollbar ( args Widget ){ //dialog support not done
	add_scrollbar(mut app, args.value, args.value_min, args.value_max, args.step, args.size_thumb, args.id, args.x, args.y, args.width, args.height, args.vertical, args.hidden, app.color_scheme[1], app.color_scheme[2], app.color_scheme[3], args.onclick, args.onchange, args.onunclick, args.frame, args.z_index, args.connected_widget)
}

pub fn (mut app Window) link ( args Widget ){ //dialog support not done
	add_link (mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.hidden, args.link_underline, args.link, app.color_scheme[2], args.onclick, args.frame, args.z_index)
}

pub fn (mut app Window) tab_view ( args Widget ){
	unsafe {
		add_tabbed_view (mut app, args.id, args.tabs, args.hidden, args.x, args.y, args.width, args.height, args.frame, args.z_index, args.active_tab)
	}
}
