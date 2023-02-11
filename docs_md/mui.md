# malisipi.mui

# Consts

scrollbar_size   = 15
theme_dark       = [40, 40, 40]
theme_light      = [225, 225, 225]
user_light_theme = is_light_theme()
null_object      = {'id': WindowData{str: ''}}
window_titlebar_height = 30

# Window

## Basis Functions

```v
fn create(args &WindowConfig) &Window
fn (mut app Window) run()
fn (mut app Window) destroy()
```

## Object Operations 

```v
fn (mut app Window) get_object_by_id(id string) []map[string]WindowData
fn (mut app Window) remove_object_by_id(id string)
fn (mut app Window) get_previous_object_by_id(id string) []map[string]WindowData
fn (mut app Window) get_next_object_by_id(id string) []map[string]WindowData
fn (mut app Window) remove_all_objects()
fn (mut app Window) sort_widgets_with_zindex()
fn (mut app Window) clear_values(id []string)
```

## Cloning/Loading App

```v
fn (mut app Window) clone_app_objects() []map[string]WindowData
fn (mut app Window) load_app_objects(app_objects []map[string]WindowData)
```

You can clone & load entire app with all widgets states

> It's could be useful making logon UI or welcome page

## Change View Properties After Creation

```v
fn (mut app Window) set_title(title string)
fn (mut app Window) set_viewarea(x int, y int)
fn (mut app Window) enable_scrollbar(enable_scrollbar bool)
```

## Built-in Dialogs

```v
fn (mut app Window) clear_dialog()
fn (mut app Window) create_dialog(dialog_data Modal)
fn (mut app Window) get_next_dialog_object_by_id(id string) []map[string]WindowData
fn (mut app Window) get_dialog_object_by_id(id string) []map[string]WindowData
fn (mut app Window) get_previous_dialog_object_by_id(id string) []map[string]WindowData
fn (mut app Window) wait_and_get_answer() string
fn (mut app Window) run_dialog()
fn (mut app Window) remove_dialog_object_by_id(id string)
```

> Browse `examples/builtin_dialogs_example.v` for example

## Get Native Window Pointer

It's returning HWND on Windows. Void pointer for another OSs.
Will be implemented Linux support when Sokol have GTK pointer.

```v
fn (mut app Window) window_handle() voidptr
```

## Toolbar/Statusbar

* Set height of statusbar/toolbar
```v
mut app:=mui.create(.., toolbar:25, statusbar:25)
```

* Add widgets
```app.button(.., frame:"@toolbar")``` for toolbar
```app.button(.., frame:"@statusbar")``` for statusbar

## Menubar

> You can create menubar with app parameters

```v
mui.create(.., 
	menubar: [
		{"text":mui.WindowData{str:"Edit"}, "items":mui.WindowData{lst:[
			{"text":mui.WindowData{str:"Add User"}, "fn": mui.WindowData{fun:add_user}}
		]}},
		{"text":mui.WindowData{str:"About"}, "items":mui.WindowData{lst:[
			{"text":mui.WindowData{str:"About"}, "fn": mui.WindowData{fun:about_dialog}},
			{"text":mui.WindowData{str:"About MUI"}, "fn": mui.WindowData{fun:mui.about_dialog}}
		]}},
	], menubar_config: mui.MenubarConfig{
		width: 100,
		sub_width: 120,
		height: 30,
		text_size: 24
	})
```

## Transitions

```v
fn move_object(mut app Window, object_id string, new_pos []IntOrString, move_time f64)
```

Use seconds at `move_time`

## Registering Custom Widgets

```
import <custom_widget_library> as custom_widget

custom_widget.load_into_app(mut app)
custom_widget.new(mut app, m.Widget{ id:"custom_button", x:"5%x", y:"5%y", width:"90%x", height:"90%y", text:"Custom Widget" }))
```

> This way is recommend for custom widget creators. But this way can be changed with creators, you should look up their docs.

## Keybindings

```v
app.keybindings["ctrl|p"].fun=fn (event_details m.EventDetails, mut app &m.Window, mut app_data voidptr){ println("Hello!\n") }
               ^^^^^^^^^^     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			    Shorcut                                           The Function That You Want Register
```

# Dialogs

```v
fn beep()
fn colorchooser(title string, default_color string) string
fn inputbox(title string, text string, default_text string) string
fn messagebox(title string, text string, dialog_type string, icon_type string) int
fn notifypopup(title string, text string, icon_type string)
fn openfiledialog(title string) string
fn passwordbox(title string, text string) string
fn savefiledialog(title string) string
fn selectfolderdialog(title string) string
```

# Widgets

```v
fn (mut app Window) area_graph(args Widget)
fn (mut app Window) button(args Widget)
fn (mut app Window) checkbox(args Widget)
fn (mut app Window) frame(args Widget)
fn (mut app Window) group(args Widget)
fn (mut app Window) image(args Widget)
fn (mut app Window) label(args Widget)
fn (mut app Window) line_graph(args Widget)
fn (mut app Window) link(args Widget)
fn (mut app Window) list(args Widget)
fn (mut app Window) map(args Widget)
fn (mut app Window) password(args Widget)
fn (mut app Window) progress(args Widget)
fn (mut app Window) radio(args Widget)
fn (mut app Window) rect(args Widget)
fn (mut app Window) scrollbar(args Widget)
fn (mut app Window) selectbox(args Widget)
fn (mut app Window) slider(args Widget)
fn (mut app Window) spinner(args Widget)
fn (mut app Window) switch(args Widget)
fn (mut app Window) tab_view(args Widget)
fn (mut app Window) table(args Widget)
fn (mut app Window) textarea(args Widget)
fn (mut app Window) textbox(args Widget)
```

# Structs & Unions

## CustomWidget

```v
struct CustomWidget {
pub mut:
	typ        string
	draw_fn    CustomWidgetDraw  = empty_custom_widget_draw
	click_fn   CustomWidgetEvent = empty_custom_widget_event
	move_fn    CustomWidgetEvent = empty_custom_widget_event
	unclick_fn CustomWidgetEvent = empty_custom_widget_event
}
```

## MenubarConfig

```v
struct MenubarConfig {
pub mut:
// for each box
	height    int = 25
	sub_width int = 160
	width     int = 80
	text_size int = 20
}
```

## EventDetails
```v
struct EventDetails {
pub mut:
	event       string // click, value_change, unclick, keypress, file_drop
	trigger     string // mouse_left, mouse_right, mouse_middle, keyboard
	value       string = 'true'
	target_type string = 'window' // window, menubar, and widget_types
	target_id   string //= ""
}
```

## Modal
```v
struct Modal {
	title         string = 'MUI'
	message       string //= ""
	typ           string = 'messagebox'
	file_ext      string = '*'
	default_entry string //= ""
}
```

## Widget
```v
struct Widget {
pub:
	hidden         bool        //= false									//hi
	path           string      //= ""										//- => image
	text           string      //= ""										//text
	placeholder    string      //= ""										//ph
	ph_as_text     bool        //= 0										//phsa //show placeholder as text
	table          [][]string  = [['']] 									// table
	tabs           [][]string  = [['Test Tab', 'test_tab']]					// tabs
	active_tab     string      //= ""										//acttb
	id             string      //= ""										//id
	link           string      //= ""										//link
	percent        int         //= 0										//perc
	value          int         //= 0										//val
	value_max      int         = 10 										// vlMax
	value_min      int         //= 0										//vlMin
	size_thumb     int         = 6 											// sThum
	checked        bool        //= false									//c
	step           int    	   = 1 											// vStep
	hider_char     string      = '*' 										// hc
	selected       int         //= 0										//s
	list           []string    = [''] 										// list
	x              IntOrString = '0' 										// x_raw
	y              IntOrString = '0' 										// y_raw
	width          IntOrString = '125'										// w_raw
	height         IntOrString = '20' 										// h_raw
	onchange       OnEvent     = empty_fn 									// onchg
	onclick        OnEvent     = empty_fn 									// onclk
	onunclick      OnEvent     = empty_fn 									// onucl
	link_underline bool        = true 										// unlin
	graph_title    string      = 'Graph'									// g_tit
	graph_label    []string    = ['', '', ''] 								// g_lbl
	graph_data     [][]int     = [[0, 0, 0]] 								// g_dat
	graph_names    []string    = ['']										// g_nam
	graph_color    []gx.Color  = [gx.Color{
		r: 255
		g: 255
		b: 255
	}] 																		// g_clr
	background     gx.Color    = gx.Color{
		r: 127
		g: 127
		b: 127
	} 																		// bg
	value_map      ValueMap		= no_map									// vlMap
	latitude       f64			= 48.856613									//- => image
	longitude      f64			= 2.352222									//- => image
	zoom           int			= 10										//- => image
	vertical       bool			//= false									//vert
	icon           bool			//= false									//icon
	codefield      bool			//= false									//code
	dialog         bool			//= false									//- => app.objects || app.dialog_objects
	text_size      int = 20		// tSize
	text_align     int = 1		// tAlin
	text_multiline bool			//= false									//tMult
	frame          string		//= ""										//in
	z_index        int			//= 0										//z_ind
}
```

## Window
```v
struct Window {
pub mut:
	objects        []map[string]WindowData
	focus          string
	color_scheme   []gx.Color
	app_data       voidptr
	gg             &gg.Context
	screen_reader  bool
	menubar        []map[string]WindowData
	x_offset       int
	y_offset       int
	xn_offset      int
	yn_offset      int
	scrollbar      bool
	scroll_x       int
	scroll_y       int
	file_handler   OnEvent
	ask_quit       bool
	quit_fn        OnEvent
	active_dialog  string //= "" //messagebox, input, password, progress, color, date, notification, openfile, savefile, openfolder, custom
	dialog_answer  string = .dialogs_null_answer
	dialog_objects []map[string]WindowData // for dialogs
	custom_widgets []CustomWidget
	keybindings     map[string]WindowData = map[string]WindowData{}
	menubar_config  MenubarConfig
	redraw_required bool = true
	force_redraw    bool //= false
	prefer_native   bool
	native_focus    bool //=false
	round_corners   int
}
```

## WindowConfig
```v
struct WindowConfig {
pub mut:
	title         string //= ""
	width         int    = 800
	height        int    = 600
	font          string = .os_font
	app_data      voidptr
	screen_reader bool = true
	menubar       []map[string]WindowData = []map[string]WindowData{}
	x_offset      int //=0
	y_offset      int //=0
	xn_offset     int //=0
	yn_offset     int //=0
	color         []int = [-1, -1, -1]
	scrollbar     bool //= false
	view_area     []int   = [-1, -1]
	file_handler  OnEvent = empty_fn
	ask_quit      bool //= false
	quit_fn       OnEvent = empty_fn
	prefer_native bool //= true
	round_corners int = -1
}
```

## WindowData
```v
union WindowData {
pub mut:
	num int
	str string
	clr gx.Color
	bol bool
	fun OnEvent
	img gg.Image
	tbl [][]string
	dat [][]int
	lcr []gx.Color
	vmp ValueMap
	lst []map[string]WindowData
}
```