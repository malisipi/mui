module mui

import gg
import gx

const (
	null_object={"id":WindowData{str:""}}
)

pub type IntOrString=int|string
pub type U32OrString=u32|string
pub type OnEvent=fn(EventDetails, mut &Window, mut voidptr)
pub type ValueMap=fn(int) string

pub type CustomWidgetDraw=fn(&Window, map[string]WindowData)
pub type CustomWidgetEvent=fn(f32, f32, mut map[string]WindowData, &Window)

pub fn empty_custom_widget_draw(app &Window, object map[string]WindowData){}
pub fn empty_custom_widget_event(x f32, y f32, mut object map[string]WindowData, app &Window){}

pub union WindowData {
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

pub struct CustomWidget {
pub mut:
	typ			string
    draw_fn		CustomWidgetDraw	= empty_custom_widget_draw
    click_fn	CustomWidgetEvent	= empty_custom_widget_event
    move_fn		CustomWidgetEvent	= empty_custom_widget_event
    unclick_fn	CustomWidgetEvent	= empty_custom_widget_event
}

pub struct WindowConfig {
pub mut:
	title			string							//= ""
	width			int								= 800
	height			int								= 600
	font			string							= os_font
    app_data		voidptr
    screen_reader	bool							= true
    menubar			[]map[string]WindowData			= []map[string]WindowData{}
    x_offset		int								//=0
	y_offset		int								//=0
	xn_offset		int								//=0
	yn_offset		int								//=0
	color			[]int							= [-1,-1,-1]
	scrollbar		bool							//= false
	view_area		[]int							= [-1,-1]
	file_handler	OnEvent							= empty_fn
	ask_quit		bool							//= false
	quit_fn			OnEvent							= empty_fn
	resized_fn		OnEvent							= empty_fn
	background		[]int							= [-1,-1,-1]
}

pub struct EventDetails{
pub mut:
	event			string		// click, value_change, unclick, keypress, files_drop, resize
	trigger			string		// mouse_left, mouse_right, mouse_middle, keyboard
	value			string		= "true"
	target_type		string		= "window" //window, menubar, and widget_types
	target_id		string		//= ""
}

pub struct Window {
pub mut:
    objects     		[]map[string]WindowData
    focus       		string
    color_scheme		[]gx.Color
    app_data			voidptr
    gg          		&gg.Context
    screen_reader		bool
    menubar				[]map[string]WindowData
    x_offset			int
	y_offset			int
	xn_offset			int
	yn_offset			int
	scrollbar			bool
	scroll_x			int
	scroll_y			int
	file_handler		OnEvent
	ask_quit			bool
	quit_fn				OnEvent
	resized_fn			OnEvent
	active_dialog		string			//= "" //messagebox, input, password, progress, color, date, notification, openfile, savefile, openfolder, custom
	dialog_answer		string					= dialogs_null_answer
    dialog_objects		[]map[string]WindowData // for dialogs
    custom_widgets		[]CustomWidget
	keybindings			map[string]WindowData 	= map[string]WindowData{}
}

pub struct Widget {
pub:
	hidden			bool			//= false									//hi
	path			string			//= ""										//- => image
	text			string			//= ""										//text
	placeholder		string			//= ""										//ph
	ph_as_text		bool			//= 0										//phsa //show placeholder as text
	table			[][]string		= [[""]]									//table
	tabs			[][]string		= [["Test Tab","test_tab"]]					//tabs
	active_tab		string			//= ""										//acttb
	id				string			//= ""										//id
	link			string			//= ""										//link
	percent			int				//= 0										//perc
	value			int				//= 0										//val
	value_max		int				= 10										//vlMax
	value_min		int				//= 0										//vlMin
	size_thumb		int				= 6											//sThum
	checked			bool			//= false									//c
	step			int				= 1											//vStep
	hider_char		string			= "*"										//hc
	selected		int				//= 0										//s
	list			[]string		= [""]										//list
	x				IntOrString		= "0"										//x_raw
	y				IntOrString		= "0"										//y_raw
	width			IntOrString		= "125"										//w_raw
	height			IntOrString		= "20"										//h_raw
	onchange		OnEvent			= empty_fn									//onchg
	onclick			OnEvent			= empty_fn									//onclk
	onunclick		OnEvent			= empty_fn									//onucl
	link_underline	bool			= true										//unlin
	graph_title		string			= "Graph"									//g_tit
	graph_label		[]string		= ["","",""]								//g_lbl
	graph_data		[][]int			= [[0,0,0]]									//g_dat
	graph_names		[]string		= [""]										//g_nam
	graph_color		[]gx.Color		= [gx.Color{r: 255, g: 255, b: 255}]		//g_clr
	background		gx.Color		= gx.Color{r: 127, g: 127, b: 127}			//bg
	value_map		ValueMap		= no_map									//vlMap
	latitude		f64				= 48.856613									//- => image
	longitude		f64				= 2.352222									//- => image
	zoom			int				= 10										//- => image
	vertical		bool			//= false									//vert
	icon			bool			//= false									//icon
	codefield		bool			//= false									//code
	dialog			bool			//= false									//- => app.objects || app.dialog_objects
	text_size		int				= 20										//tSize
	text_align		int				= 1											//tAlin
	text_multiline	bool			//= false									//tMult
	frame			string			//= ""										//in
	z_index			int				//= 0										//z_ind
}

pub struct Modal {
	title			string		= "MUI"
	message			string		//= ""
	typ				string		= "messagebox"
	file_ext		string		= "*"
	default_entry	string		//= ""
}

pub fn empty_fn(event_details EventDetails, mut app &Window, mut app_data voidptr){}
pub fn no_map(val int) string { return val.str() }
