module mui

pub fn (mut app Window) rect ( args Widget ){
	add_rect (mut app, args.id, args.x, args.y, args.width, args.height, args.hidden, args.background)
}

pub fn (mut app Window) line_graph ( args Widget ){
	add_line_graph (mut app, args.id, args.x, args.y, args.width, args.height, args.hidden, args.graph_title, args.graph_label, args.graph_data, args.graph_color, args.graph_names, args.background, app.color_scheme[3])
}

pub fn (mut app Window) table ( args Widget ){
	add_table (mut app, args.table, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[0], app.color_scheme[2], app.color_scheme[3])
}

pub fn (mut app Window) group ( args Widget ){
	add_group (mut app, args.id, args.text, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[0], app.color_scheme[2], app.color_scheme[3])
}

pub fn (mut app Window) label ( args Widget ){
	add_label (mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[3], args.onclick)
}

pub fn (mut app Window) button ( args Widget ){
	add_button (mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[1], app.color_scheme[3], args.onclick, args.icon)
}

pub fn (mut app Window) image ( args Widget ){
	add_image (mut app, args.path, args.id, args.x, args.y, args.width, args.height, args.hidden, args.onclick)
}

pub fn (mut app Window) map ( args Widget ){
	add_map (mut app, args.zoom, args.latitude, args.longitude, args.id, args.x, args.y, args.width, args.height, args.hidden, args.onclick)
}

pub fn (mut app Window) progress ( args Widget ){
	add_progress (mut app, args.percent, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[1], app.color_scheme[2],  app.color_scheme[3])
}

pub fn (mut app Window) textbox ( args Widget ){
	add_textbox (mut app, args.text, args.id, args.placeholder, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1], app.color_scheme[3], args.onchange)
}

pub fn (mut app Window) password ( args Widget ){
	add_password (mut app, args.text, args.hider_char, args.id, args.placeholder, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1], app.color_scheme[3], args.onchange)
}

pub fn (mut app Window) checkbox ( args Widget ){
	add_checkbox(mut app, args.text, args.id, args.x, args.y, args.height, args.checked , args.hidden, app.color_scheme[1], app.color_scheme[3], app.color_scheme[3], args.onchange)
}

pub fn (mut app Window) radio ( args Widget ){
	add_radio(mut app, args.list, args.id, args.x, args.y, args.height, args.selected , args.hidden, app.color_scheme[1], app.color_scheme[3], app.color_scheme[3], args.onchange)
}

pub fn (mut app Window) selectbox ( args Widget ){
	add_selectbox(mut app, args.text, args.list, args.selected, args.id, args.x, args.y, args.width, args.height, args.hidden, app.color_scheme[2], app.color_scheme[1],  app.color_scheme[3], args.onchange)
}

pub fn (mut app Window) slider ( args Widget ){
	add_slider(mut app, args.value, args.value_min, args.value_max, args.step, args.id, args.x, args.y, args.width, args.height, args.vertical, args.hidden, app.color_scheme[1], app.color_scheme[2], app.color_scheme[3], args.onclick, args.onchange, args.onunclick, args.value_map)
}

pub fn (mut app Window) scrollbar ( args Widget ){
	add_scrollbar(mut app, args.value, args.value_min, args.value_max, args.step, args.size_thumb, args.id, args.x, args.y, args.width, args.height, args.vertical, args.hidden, app.color_scheme[1], app.color_scheme[2], app.color_scheme[3], args.onclick, args.onchange, args.onunclick)
}
pub fn (mut app Window) link ( args Widget ){
	add_link (mut app, args.text, args.id, args.x, args.y, args.width, args.height, args.hidden, args.link_underline, args.link, app.color_scheme[3], args.onclick)
}
