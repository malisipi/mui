module mui

fn about_dialog(event_details EventDetails, mut app &Window, app_data voidptr){
	mut main_text:="MUI -  1.0.0 (Apache 2.0)\n* TinyFileDialogs: 3.8.8 (ZLib)"
	$if no_emoji? {
	} $else {
		main_text+="\n* Noto Emoji Font (OFL)"
	}
	messagebox("MUI",main_text,"ok","info")
}
