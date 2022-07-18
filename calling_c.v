module mui

fn cstr(the_string string) &char {
	return &char(the_string.str)
}

