module mui

import gg
import gx
import os.font

const (
	null_object={"id":WindowData{str:""}}
)

pub type OnEvent=fn(EventDetails, mut Window, voidptr)
pub type ValueMap=fn(int) string

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

pub struct WindowConfig {
pub mut:
	title			string							//= ""
	width			int								= 800
	height			int								= 600
	font			string							= font.default()
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
}

pub struct EventDetails{
pub mut:
	event			string		// click, value_change, unclick, keypress
	trigger			string		// mouse_left, mouse_right, mouse_middle, keyboard
	value			string
	target_type		string
	target_id		string
}

pub struct Window {
pub mut:
    objects     	[]map[string]WindowData
    focus       	string
    color_scheme	[]gx.Color
    app_data		voidptr
    gg          	&gg.Context
    screen_reader	bool
    menubar			[]map[string]WindowData
    x_offset		int
	y_offset		int
	xn_offset		int
	yn_offset		int
	scrollbar		bool
	scroll_x		int
	scroll_y		int
}

pub struct Widget {
	hidden			bool			//= false									//hi
	path			string			//= ""										//- => image
	text			string			//= ""										//text
	placeholder		string			//= ""										//ph
	ph_as_text		bool			//= 0										//phsa //show placeholder as text
	table			[][]string		= [[""]]									//table
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
	x				int|string		= "0"										//x_raw
	y				int|string		= "0"										//y_raw
	width			int|string		= "125"										//w_raw
	height			int|string		= "20"										//h_raw
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
	vertical		bool			//=false									//vert
	icon			bool			//=false									//icon
}

pub fn empty_fn(event_details EventDetails, mut app &Window, app_data voidptr){}
pub fn no_map(val int) string { return val.str() }
