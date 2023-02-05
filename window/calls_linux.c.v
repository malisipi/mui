module window

$if !tinyc {
	#pkgconfig gtk+-3.0
}

fn C.gtk_widget_hide(win voidptr)
fn C.gtk_widget_show(win voidptr)

fn C.putenv(&char) int
