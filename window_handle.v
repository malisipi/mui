module mui

import sokol.sapp

pub fn (mut app Window) window_handle() voidptr {
      $if windows {
		return sapp.win32_get_hwnd()
	}
	return unsafe { nil }

}