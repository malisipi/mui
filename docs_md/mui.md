# malisipi.mui

## Contents
- [Constants](#Constants)
- This functions not recommend
	- [add_area_graph](#add_area_graph)
	- [add_button](#add_button)
	- [add_checkbox](#add_checkbox)
	- [add_frame](#add_frame)
	- [add_group](#add_group)
	- [add_image](#add_image)
	- [add_label](#add_label)
	- [add_line_graph](#add_line_graph)
	- [add_link](#add_link)
	- [add_map](#add_map)
	- [add_password](#add_password)
	- [add_progress](#add_progress)
	- [add_radio](#add_radio)
	- [add_rect](#add_rect)
	- [add_scrollbar](#add_scrollbar)
	- [add_selectbox](#add_selectbox)
	- [add_slider](#add_slider)
	- [add_switch](#add_switch)
	- [add_tabbed_view](#add_tabbed_view)
	- [add_table](#add_table)
	- [add_textarea](#add_textarea)
	- [add_textbox](#add_textbox)
- [beep](#beep)
- [color_code_to_rgb](#color_code_to_rgb)
- [colorchooser](#colorchooser)
- [create](#create)
- [dropped_file_path](#dropped_file_path)
- [dropped_files_len](#dropped_files_len)
- [empty_custom_widget_draw](#empty_custom_widget_draw)
- [empty_custom_widget_event](#empty_custom_widget_event)
- [empty_fn](#empty_fn)
- [inputbox](#inputbox)
- [messagebox](#messagebox)
- [move_object](#move_object)
- [no_map](#no_map)
- [notifypopup](#notifypopup)
- [openfiledialog](#openfiledialog)
- [passwordbox](#passwordbox)
- [rgb_to_color_code](#rgb_to_color_code)
- [savefiledialog](#savefiledialog)
- [selectfolderdialog](#selectfolderdialog)
- [CustomWidgetDraw](#CustomWidgetDraw)
- [CustomWidgetEvent](#CustomWidgetEvent)
- [IntOrString](#IntOrString)
- [OnEvent](#OnEvent)
- [U32OrString](#U32OrString)
- [ValueMap](#ValueMap)
- [CustomWidget](#CustomWidget)
- [EventDetails](#EventDetails)
- [Modal](#Modal)
- [Widget](#Widget)
- [Window](#Window)
  - [area_graph](#area_graph)
  - [button](#button)
  - [checkbox](#checkbox)
  - [clear_dialog](#clear_dialog)
  - [clear_values](#clear_values)
  - [clone_app_objects](#clone_app_objects)
  - [create_dialog](#create_dialog)
  - [destroy](#destroy)
  - [enable_scrollbar](#enable_scrollbar)
  - [frame](#frame)
  - [get_dialog_object_by_id](#get_dialog_object_by_id)
  - [get_next_dialog_object_by_id](#get_next_dialog_object_by_id)
  - [get_next_object_by_id](#get_next_object_by_id)
  - [get_object_by_id](#get_object_by_id)
  - [get_previous_dialog_object_by_id](#get_previous_dialog_object_by_id)
  - [get_previous_object_by_id](#get_previous_object_by_id)
  - [group](#group)
  - [image](#image)
  - [label](#label)
  - [line_graph](#line_graph)
  - [link](#link)
  - [load_app_objects](#load_app_objects)
  - [map](#map)
  - [password](#password)
  - [progress](#progress)
  - [radio](#radio)
  - [rect](#rect)
  - [remove_all_objects](#remove_all_objects)
  - [remove_dialog_object_by_id](#remove_dialog_object_by_id)
  - [remove_object_by_id](#remove_object_by_id)
  - [run](#run)
  - [run_dialog](#run_dialog)
  - [scrollbar](#scrollbar)
  - [selectbox](#selectbox)
  - [set_viewarea](#set_viewarea)
  - [slider](#slider)
  - [sort_widgets_with_zindex](#sort_widgets_with_zindex)
  - [switch](#switch)
  - [tab_view](#tab_view)
  - [table](#table)
  - [textarea](#textarea)
  - [textbox](#textbox)
  - [wait_and_get_answer](#wait_and_get_answer)
- [WindowConfig](#WindowConfig)
- [WindowData](#WindowData)

## Constants
```v
const (
	theme_dark  = [40, 40, 40]
	theme_light = [225, 225, 225]
)
```


[[Return to contents]](#Contents)

## add_area_graph
```v
fn add_area_graph(mut app Window, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, title string, label []string, data [][]int, colors []gx.Color, names []string, bg gx.Color, fg gx.Color, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_button
```v
fn add_button(mut app Window, text string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, fg gx.Color, fun OnEvent, icon bool, dialog bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_checkbox
```v
fn add_checkbox(mut app Window, text string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, checked bool, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_frame
```v
fn add_frame(mut app Window, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, dialog bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_group
```v
fn add_group(mut app Window, id string, text string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_image
```v
fn add_image(mut app Window, path string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, fun OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_label
```v
fn add_label(mut app Window, text string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, fg gx.Color, fnclk OnEvent, dialog bool, tSize int, tAlin int, tMult bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_line_graph
```v
fn add_line_graph(mut app Window, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, title string, label []string, data [][]int, colors []gx.Color, names []string, bg gx.Color, fg gx.Color, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_link
```v
fn add_link(mut app Window, text string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, underline bool, link string, fg gx.Color, fnclk OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_map
```v
fn add_map(mut app Window, zoom int, lat f64, lon f64, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, fun OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_password
```v
fn add_password(mut app Window, text string, hider_char string, id string, placeholder string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, dialog bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_progress
```v
fn add_progress(mut app Window, percent int, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, dialog bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_radio
```v
fn add_radio(mut app Window, list []string, group_id string, x IntOrString, y IntOrString, wh IntOrString, selected int, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_rect
```v
fn add_rect(mut app Window, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, dialog bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_scrollbar
```v
fn add_scrollbar(mut app Window, val int, min int, max int, step int, sthum int, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, vert bool, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnclk OnEvent, fnchg OnEvent, fnucl OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_selectbox
```v
fn add_selectbox(mut app Window, text string, list []string, selected int, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_slider
```v
fn add_slider(mut app Window, val int, min int, max int, step int, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, vert bool, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnclk OnEvent, fnchg OnEvent, fnucl OnEvent, value_map ValueMap, dialog bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_switch
```v
fn add_switch(mut app Window, text string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, checked bool, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_tabbed_view
```v
fn add_tabbed_view(mut app Window, id string, tabs [][]string, hidden bool, x IntOrString, y IntOrString, w IntOrString, h IntOrString, frame string, zindex int, active_tab string)
```


[[Return to contents]](#Contents)

## add_table
```v
fn add_table(mut app Window, table [][]string, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_textarea
```v
fn add_textarea(mut app Window, text string, id string, placeholder string, phsa bool, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, codefield bool, tSize int, frame string, zindex int)
```


[[Return to contents]](#Contents)

## add_textbox
```v
fn add_textbox(mut app Window, text string, id string, placeholder string, phsa bool, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, bg gx.Color, bfg gx.Color, fg gx.Color, fnchg OnEvent, dialog bool, frame string, zindex int)
```


[[Return to contents]](#Contents)

## beep
```v
fn beep()
```


[[Return to contents]](#Contents)

## color_code_to_rgb
```v
fn color_code_to_rgb(color string) []int
```


[[Return to contents]](#Contents)

## colorchooser
```v
fn colorchooser(title string, default_color string) string
```


[[Return to contents]](#Contents)

## create
```v
fn create(args &WindowConfig) &Window
```


[[Return to contents]](#Contents)

## dropped_file_path
```v
fn dropped_file_path(w int) string
```


[[Return to contents]](#Contents)

## dropped_files_len
```v
fn dropped_files_len() int
```


[[Return to contents]](#Contents)

## empty_custom_widget_draw
```v
fn empty_custom_widget_draw(app &Window, object map[string]WindowData)
```


[[Return to contents]](#Contents)

## empty_custom_widget_event
```v
fn empty_custom_widget_event(x f32, y f32, mut object map[string]WindowData, app &Window)
```


[[Return to contents]](#Contents)

## empty_fn
```v
fn empty_fn(event_details EventDetails, mut app Window, mut app_data voidptr)
```


[[Return to contents]](#Contents)

## inputbox
```v
fn inputbox(title string, text string, default_text string) string
```


[[Return to contents]](#Contents)

## messagebox
```v
fn messagebox(title string, text string, dialog_type string, icon_type string) int
```

dialog_type => "ok", "okcancel", "yesno", "yesnocancel" icon_type   => "info", "warning", "error" 0 -> cancel/no, 1 -> ok/yes, 2 -> no (yesnocancel)

[[Return to contents]](#Contents)

## move_object
```v
fn move_object(mut app Window, object_id string, new_pos []IntOrString, move_time f64)
```


[[Return to contents]](#Contents)

## no_map
```v
fn no_map(val int) string
```


[[Return to contents]](#Contents)

## notifypopup
```v
fn notifypopup(title string, text string, icon_type string)
```


[[Return to contents]](#Contents)

## openfiledialog
```v
fn openfiledialog(title string) string
```


[[Return to contents]](#Contents)

## passwordbox
```v
fn passwordbox(title string, text string) string
```


[[Return to contents]](#Contents)

## rgb_to_color_code
```v
fn rgb_to_color_code(color []int) string
```


[[Return to contents]](#Contents)

## savefiledialog
```v
fn savefiledialog(title string) string
```


[[Return to contents]](#Contents)

## selectfolderdialog
```v
fn selectfolderdialog(title string) string
```


[[Return to contents]](#Contents)

## CustomWidgetDraw
```v
type CustomWidgetDraw = fn (&Window, map[string]WindowData)
```


[[Return to contents]](#Contents)

## CustomWidgetEvent
```v
type CustomWidgetEvent = fn (f32, f32, mut map[string]WindowData, &Window)
```


[[Return to contents]](#Contents)

## IntOrString
```v
type IntOrString = int | string
```


[[Return to contents]](#Contents)

## OnEvent
```v
type OnEvent = fn (EventDetails, mut Window, mut voidptr)
```


[[Return to contents]](#Contents)

## U32OrString
```v
type U32OrString = string | u32
```


[[Return to contents]](#Contents)

## ValueMap
```v
type ValueMap = fn (int) string
```


[[Return to contents]](#Contents)

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


[[Return to contents]](#Contents)

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


[[Return to contents]](#Contents)

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


[[Return to contents]](#Contents)

## Widget
```v
struct Widget {
pub:
	hidden         bool        //= false									//hi
	path           string      //= ""										//- => image
	text           string      //= ""										//text
	placeholder    string      //= ""										//ph
	ph_as_text     bool        //= 0										//phsa //show placeholder as text
	table          [][]string = [['']] // table
	tabs           [][]string = [['Test Tab', 'test_tab']] // tabs
	active_tab     string      //= ""										//acttb
	id             string      //= ""										//id
	link           string      //= ""										//link
	percent        int         //= 0										//perc
	value          int         //= 0										//val
	value_max      int = 10 // vlMax
	value_min      int         //= 0										//vlMin
	size_thumb     int = 6 // sThum
	checked        bool        //= false									//c
	step           int    = 1 // vStep
	hider_char     string = '*' // hc
	selected       int         //= 0										//s
	list           []string    = [''] // list
	x              IntOrString = '0' // x_raw
	y              IntOrString = '0' // y_raw
	width          IntOrString = '125' // w_raw
	height         IntOrString = '20' // h_raw
	onchange       OnEvent     = empty_fn // onchg
	onclick        OnEvent     = empty_fn // onclk
	onunclick      OnEvent     = empty_fn // onucl
	link_underline bool        = true // unlin
	graph_title    string      = 'Graph' // g_tit
	graph_label    []string    = ['', '', ''] // g_lbl
	graph_data     [][]int     = [[0, 0, 0]] // g_dat
	graph_names    []string    = [''] // g_nam
	graph_color    []gx.Color  = [gx.Color{
		r: 255
		g: 255
		b: 255
	}] // g_clr
	background     gx.Color    = gx.Color{
		r: 127
		g: 127
		b: 127
	} // bg
	value_map      ValueMap    = no_map // vlMap
	latitude       f64 = 48.856613 //- => image
	longitude      f64 = 2.352222 //- => image
	zoom           int = 10 //- => image
	vertical       bool   //= false									//vert
	icon           bool   //= false									//icon
	codefield      bool   //= false									//code
	dialog         bool   //= false									//- => app.objects || app.dialog_objects
	text_size      int = 20 // tSize
	text_align     int = 1 // tAlin
	text_multiline bool   //= false									//tMult
	frame          string //= ""										//in
	z_index        int    //= 0										//z_ind
}
```


[[Return to contents]](#Contents)

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
	keybindings    map[string]WindowData = map[string]WindowData{}
}
```


[[Return to contents]](#Contents)

## area_graph
```v
fn (mut app Window) area_graph(args Widget)
```


[[Return to contents]](#Contents)

## button
```v
fn (mut app Window) button(args Widget)
```


[[Return to contents]](#Contents)

## checkbox
```v
fn (mut app Window) checkbox(args Widget)
```


[[Return to contents]](#Contents)

## clear_dialog
```v
fn (mut app Window) clear_dialog()
```


[[Return to contents]](#Contents)

## clear_values
```v
fn (mut app Window) clear_values(id []string)
```


[[Return to contents]](#Contents)

## clone_app_objects
```v
fn (mut app Window) clone_app_objects() []map[string]WindowData
```


[[Return to contents]](#Contents)

## create_dialog
```v
fn (mut app Window) create_dialog(dialog_data Modal)
```


[[Return to contents]](#Contents)

## destroy
```v
fn (mut app Window) destroy()
```


[[Return to contents]](#Contents)

## enable_scrollbar
```v
fn (mut app Window) enable_scrollbar(enable_scrollbar bool)
```


[[Return to contents]](#Contents)

## frame
```v
fn (mut app Window) frame(args Widget)
```


[[Return to contents]](#Contents)

## get_dialog_object_by_id
```v
fn (mut app Window) get_dialog_object_by_id(id string) []map[string]WindowData
```


[[Return to contents]](#Contents)

## get_next_dialog_object_by_id
```v
fn (mut app Window) get_next_dialog_object_by_id(id string) []map[string]WindowData
```


[[Return to contents]](#Contents)

## get_next_object_by_id
```v
fn (mut app Window) get_next_object_by_id(id string) []map[string]WindowData
```


[[Return to contents]](#Contents)

## get_object_by_id
```v
fn (mut app Window) get_object_by_id(id string) []map[string]WindowData
```


[[Return to contents]](#Contents)

## get_previous_dialog_object_by_id
```v
fn (mut app Window) get_previous_dialog_object_by_id(id string) []map[string]WindowData
```


[[Return to contents]](#Contents)

## get_previous_object_by_id
```v
fn (mut app Window) get_previous_object_by_id(id string) []map[string]WindowData
```


[[Return to contents]](#Contents)

## group
```v
fn (mut app Window) group(args Widget)
```


[[Return to contents]](#Contents)

## image
```v
fn (mut app Window) image(args Widget)
```


[[Return to contents]](#Contents)

## label
```v
fn (mut app Window) label(args Widget)
```


[[Return to contents]](#Contents)

## line_graph
```v
fn (mut app Window) line_graph(args Widget)
```


[[Return to contents]](#Contents)

## link
```v
fn (mut app Window) link(args Widget)
```


[[Return to contents]](#Contents)

## load_app_objects
```v
fn (mut app Window) load_app_objects(app_objects []map[string]WindowData)
```


[[Return to contents]](#Contents)

## map
```v
fn (mut app Window) map(args Widget)
```


[[Return to contents]](#Contents)

## password
```v
fn (mut app Window) password(args Widget)
```


[[Return to contents]](#Contents)

## progress
```v
fn (mut app Window) progress(args Widget)
```


[[Return to contents]](#Contents)

## radio
```v
fn (mut app Window) radio(args Widget)
```


[[Return to contents]](#Contents)

## rect
```v
fn (mut app Window) rect(args Widget)
```


[[Return to contents]](#Contents)

## remove_all_objects
```v
fn (mut app Window) remove_all_objects()
```


[[Return to contents]](#Contents)

## remove_dialog_object_by_id
```v
fn (mut app Window) remove_dialog_object_by_id(id string)
```


[[Return to contents]](#Contents)

## remove_object_by_id
```v
fn (mut app Window) remove_object_by_id(id string)
```


[[Return to contents]](#Contents)

## run
```v
fn (mut app Window) run()
```


[[Return to contents]](#Contents)

## run_dialog
```v
fn (mut app Window) run_dialog()
```


[[Return to contents]](#Contents)

## scrollbar
```v
fn (mut app Window) scrollbar(args Widget)
```


[[Return to contents]](#Contents)

## selectbox
```v
fn (mut app Window) selectbox(args Widget)
```


[[Return to contents]](#Contents)

## set_viewarea
```v
fn (mut app Window) set_viewarea(x int, y int)
```


[[Return to contents]](#Contents)

## slider
```v
fn (mut app Window) slider(args Widget)
```


[[Return to contents]](#Contents)

## sort_widgets_with_zindex
```v
fn (mut app Window) sort_widgets_with_zindex()
```


[[Return to contents]](#Contents)

## switch
```v
fn (mut app Window) switch(args Widget)
```


[[Return to contents]](#Contents)

## tab_view
```v
fn (mut app Window) tab_view(args Widget)
```


[[Return to contents]](#Contents)

## table
```v
fn (mut app Window) table(args Widget)
```


[[Return to contents]](#Contents)

## textarea
```v
fn (mut app Window) textarea(args Widget)
```


[[Return to contents]](#Contents)

## textbox
```v
fn (mut app Window) textbox(args Widget)
```


[[Return to contents]](#Contents)

## wait_and_get_answer
```v
fn (mut app Window) wait_and_get_answer() string
```


[[Return to contents]](#Contents)

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
}
```


[[Return to contents]](#Contents)

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


[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 17 Nov 2022 18:14:23
