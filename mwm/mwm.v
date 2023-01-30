module mwm
import malisipi.mui

pub const (
	destroy = "@MUI_DESTROY" 
)

pub struct MuiWindowManager{
pub mut:
	old_active_ui	string	= "none"
	active_ui	string
	uis		map[string]&mui.Window
}

pub fn new_window_manager() MuiWindowManager {
	return MuiWindowManager{}
}

pub fn (mut manager MuiWindowManager) run () {
	
	for ;!(manager.active_ui == destroy || manager.active_ui == manager.old_active_ui); {
		manager.old_active_ui = manager.active_ui
		mut active_ui := manager.uis[manager.active_ui] or {
			println("`${manager.active_ui}` is not found!")
			exit(0)
		}
		active_ui.run()
	}
}
