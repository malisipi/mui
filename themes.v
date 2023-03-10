module mui

import os
import strconv
import gx
import math

pub const (
	theme_dark=[40,40,40]
	theme_light=[225,225,225]
	user_light_theme=is_light_theme()
	user_accent_color=theme_accent_color()
)

const (
	theme_windows_light=PredefinedTheme{
		color_scheme: [gx.Color{r:240,g:240,b:240}, gx.Color{r:253,g:253,b:253}, gx.Color{r:0,g:120,b:212}, gx.Color{r:0,g:0,b:0}]
		round_corner: 5
	}
	theme_windows_dark=PredefinedTheme{
		color_scheme: [gx.Color{r:32,g:33,b:36}, gx.Color{r:53,g:54,b:58}, gx.Color{r:69,g:178,b:235}, gx.Color{r:243,g:243,b:243}],
		round_corner: 5
	}
	theme_linux_light=PredefinedTheme{
		color_scheme: [gx.Color{r:250,g:250,b:250}, gx.Color{r:212,g:212,b:212}, gx.Color{r:236,g:100,b:53}, gx.Color{r:42,g:42,b:42}]
		round_corner: 5
	}
	theme_linux_dark=PredefinedTheme{
		color_scheme: [gx.Color{r:48,g:48,b:48}, gx.Color{r:68,g:68,b:68}, gx.Color{r:236,g:100,b:53}, gx.Color{r:255,g:255,b:255}],
		round_corner: 5
	}
)

fn hex_to_rgb(clr string) []int {

	return [ int(strconv.parse_int(clr[6..8],16,0) or {return [-1,-1,-1]}) , int(strconv.parse_int(clr[4..6],16,0) or {return [-1,-1,-1]}) , int(strconv.parse_int(clr[2..4],16,0) or {return [-1,-1,-1]}) ]
}

fn is_light_theme() bool{
	$if emscripten? {

		unsafe {
			return C.emscripten_run_script_string(cstr("String(window.matchMedia('(prefers-color-scheme: light)').matches)")).vstring()=="true"
		}

	} $else $if windows {
            is_light := unsafe { string_from_wide(C.mui_get_regedit_dword("Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize".to_wide(), "AppsUseLightTheme".to_wide())) }

		return is_light=="1"

	} $else $if linux {

	    mut output:=os.execute("")

		if os.exists_in_system_path("dconf"){
			output=os.execute("dconf read /org/gnome/desktop/interface/color-scheme")
		} else if os.exists_in_system_path("gsettings") {
			output=os.execute("gsettings get org.gnome.desktop.interface color-scheme")
		}

		return output.output.replace("\n","").replace("\r","").replace("'","")!="prefer-dark"

	} $else {

		return true

	}
}

fn theme_accent_color() []int{
	$if windows {
		accent_color := unsafe { string_from_wide(C.mui_get_regedit_dword("Software\\Microsoft\\Windows\\DWM".to_wide(), "AccentColor".to_wide())) }

		return hex_to_rgb(accent_color)

	} $else $if linux {

		if os.exists_in_system_path("cat") && os.exists_in_system_path("grep") && os.exists(os.home_dir()+"/.config/kdeglobals"){
			output:=os.execute("cat ~/.config/kdeglobals | grep \"^AccentColor=\"")
			colors:=output.output.replace("AccentColor=","").replace("\n","").replace("\r","").replace(" ","").split(",")
			if colors.len<2 {
				return [-1,-1,-1]
			}
			return [colors[0].int(), colors[1].int(), colors[2].int()]
		} else {
			return [-1,-1,-1]
		}

	}

	return [-1,-1,-1]

}

fn create_color_scheme_from_accent_color(accent_color []int) ([][]int, bool) {
	mut font_color:=[0, 0, 0]
	if accent_color[0]+accent_color[1]+accent_color[2]/3<255*3/2 {
		font_color=[255, 255, 255]
	}

	return [
		[accent_color[0]/3,accent_color[1]/3,accent_color[2]/3],
		accent_color,
		[accent_color[0]*5/3,accent_color[1]*5/3,accent_color[2]*5/3]
		font_color
	], font_color == [0, 0, 0]
}

fn create_color_scheme() ([][]int, bool) {
	accent_color:=user_accent_color.clone()

	if accent_color!=[-1,-1,-1] {
		return create_color_scheme_from_accent_color(accent_color)
	}

	color_scheme:=user_light_theme
	if color_scheme { // if light theme
		return create_color_scheme_from_accent_color(theme_light)
	}

	return create_color_scheme_from_accent_color(theme_dark)
}

fn create_gx_color_from_color_scheme() ([]gx.Color, bool) {
	color_scheme, is_light_theme_mode:=create_color_scheme()
	mut gx_colors:=[]gx.Color{}
	for color in color_scheme {
		gx_colors << gx.Color{
			r:u8(math.max(math.min(color[0],255),0)),
			g:u8(math.max(math.min(color[1],255),0)),
			b:u8(math.max(math.min(color[2],255),0))}
	}
	return gx_colors, is_light_theme_mode
}

fn create_gx_color_from_manuel_color(the_color []int) ([]gx.Color, bool){
	color_scheme, is_light_theme_mode:=create_color_scheme_from_accent_color(the_color)
	mut gx_colors:=[]gx.Color{}
	for color in color_scheme {
		gx_colors << gx.Color{
			r:u8(math.max(math.min(color[0],255),0)),
			g:u8(math.max(math.min(color[1],255),0)),
			b:u8(math.max(math.min(color[2],255),0))}
	}
	return gx_colors, is_light_theme_mode
}

fn draw_mode_config(draw_mode DrawingMode) DrawingMode {
	unsafe {
		if int(draw_mode)|7^7 == 248 {
			$if windows {
				return DrawingMode(int(draw_mode)|240^240) // 1
			} $else $if linux {
				return DrawingMode(int(draw_mode)|232^232) // 2
			} $else {
				return .cross_platform
			}
		} else {
			return draw_mode
		}
	}
}