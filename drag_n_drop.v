module mui

import sokol.sapp

pub fn dropped_files_len() int {
	return sapp.get_num_dropped_files()
}

pub fn dropped_file_path(w int) string {
	return sapp.get_dropped_file_path(w)
}
