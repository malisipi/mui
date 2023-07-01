module mui

fn show_keyboard(visible bool){
	unsafe {
		if visible {
			if C.emscripten_run_script_string(c"navigator.virtualKeyboard?.boundingRect?.height == 0").vstring() == "true" {
				C.emscripten_run_script(c"mui.trigger = \"keyboard-show\"")
			}
		} else {
			if C.emscripten_run_script_string(c"navigator.virtualKeyboard?.boundingRect?.height > 0").vstring() == "true" {
				C.emscripten_run_script(c"mui.trigger = \"keyboard-hide\"")
			}
		}
	}
}
