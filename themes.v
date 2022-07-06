module mui

import os
import strconv
import gx
import math

pub const (
	theme_dark=[40,40,40]
	theme_light=[225,225,225]
)

fn hex_to_rgb(clr string) []int {

	return [ int(strconv.parse_int(clr[6..8],16,0) or {return [-1,-1,-1]}) , int(strconv.parse_int(clr[4..6],16,0) or {return [-1,-1,-1]}) , int(strconv.parse_int(clr[2..4],16,0) or {return [-1,-1,-1]}) ]
}

fn is_light_theme() bool{
	$if windows {

		output:=os.execute("REG QUERY HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize /v AppsUseLightTheme")

		return output.output.replace("HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize","").replace("AppsUseLightTheme","").replace("REG_DWORD","").replace("\n","").replace("\r","").replace(" ","").replace("x","").int()==1

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

		output:=os.execute("REG QUERY HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\DWM /v AccentColor")

		return hex_to_rgb(output.output.replace("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\DWM","").replace("REG_DWORD","").replace("AccentColor","").replace(" ","").replace("\n","").replace("\r","").replace("0x","")[0..8])

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

fn create_color_scheme_from_accent_color(accent_color []int) [][]int {
	mut font_color:=[0,0,0]
	if accent_color[0]+accent_color[1]+accent_color[2]/3<255*3/2 {
		font_color=[255,255,255]
	}

	return [
		[accent_color[0]/3,accent_color[1]/3,accent_color[2]/3],
		accent_color,
		[accent_color[0]*5/3,accent_color[1]*5/3,accent_color[2]*5/3]
		font_color
	]
}

fn create_color_scheme() [][]int{
	accent_color:=theme_accent_color()

	if accent_color!=[-1,-1,-1] {
		return create_color_scheme_from_accent_color(accent_color)
	}

	color_scheme:=is_light_theme()
	if color_scheme { // if light theme
		return create_color_scheme_from_accent_color(theme_light)
	}

	return create_color_scheme_from_accent_color(theme_dark)
}

fn create_gx_color_from_color_scheme() []gx.Color{
	color_scheme:=create_color_scheme()
	mut gx_colors:=[]gx.Color{}
	for color in color_scheme {
		gx_colors << gx.Color{
			r:u8(math.max(math.min(color[0],255),0)),
			g:u8(math.max(math.min(color[1],255),0)),
			b:u8(math.max(math.min(color[2],255),0))}
	}
	return gx_colors
}

fn create_gx_color_from_manuel_color(the_color []int) []gx.Color{
	color_scheme:=create_color_scheme_from_accent_color(the_color)
	mut gx_colors:=[]gx.Color{}
	for color in color_scheme {
		gx_colors << gx.Color{
			r:u8(math.max(math.min(color[0],255),0)),
			g:u8(math.max(math.min(color[1],255),0)),
			b:u8(math.max(math.min(color[2],255),0))}
	}
	return gx_colors
}
