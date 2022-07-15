module mui

fn about_dialog(event_details EventDetails, mut app &Window, app_data voidptr){
	mut main_text:="MUI -  1.0.0 (Apache 2.0)"
	$if !android {
		main_text+="\n* TinyFileDialogs: 3.8.8 (ZLib)"
	}
	$if no_emoji? {
	} $else {
		main_text+="\n* Noto Emoji Font (OFL)"
	}
	$if !android {
		messagebox("MUI",main_text,"ok","info")
	} $else {
		app.create_dialog(Modal{typ:"messagebox",message:main_text,title:"MUI"})
	}
}
