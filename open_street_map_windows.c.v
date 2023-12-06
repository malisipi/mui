module mui

import math
import net.http
import os
import gg
import gx

const (
    map_source="© OpenStreetMap"
)

// https://wiki.openstreetmap.org/w/index.php?title=Slippy_map_tilenames&oldid=2309797
// Python - Lon./lat. to tile numbers
fn map_deg2num(lat_deg f64, lon_deg f64, zoom int) (int, int) {
    lat_rad := math.radians(lat_deg)
    n := math.pow(2.0,zoom)
    xtile := int((lon_deg + 180.0) / 360.0 * n)
    ytile := int((1.0 - math.asinh(math.tan(lat_rad)) / math.pi) / 2.0 * n)
    return xtile, ytile
}

fn map_download(zoom int, x int, y int) string{
    if !os.exists(os.temp_dir()+"/openstreetmap_"+zoom.str()+"_"+x.str()+"_"+y.str()+".png"){
        resp := http.get("https://a.tile.openstreetmap.org/"+zoom.str()+"/"+x.str()+"/"+y.str()+".png") or {
            println('Failed to fetch data from the server')
            return ""
        }
        os.write_file(os.temp_dir()+"/openstreetmap_"+zoom.str()+"_"+x.str()+"_"+y.str()+".png", resp.body) or {return ""}
    }
    return os.temp_dir()+"/openstreetmap_"+zoom.str()+"_"+x.str()+"_"+y.str()+".png"
}

pub fn add_map(mut app &Window, zoom int, lat f64, lon f64, id string, x IntOrString, y IntOrString, w IntOrString, h IntOrString, hi bool, fun OnEvent, frame string, zindex int){
    map_x_tile,map_y_tile:=map_deg2num(lat, lon, zoom)
    app.objects << {
        "type": WindowData{str:"map"},
        "id":   WindowData{str:id},
        "in":   WindowData{str:frame},
        "z_ind":WindowData{num:zindex},
	"image":WindowData{img:app.gg.create_image(map_download(zoom, map_x_tile, map_y_tile)) or { gg.Image{} } }
        "x":    WindowData{num:0},
        "y":    WindowData{num:0},
        "w":    WindowData{num:0},
        "h":    WindowData{num:0},
	"x_raw":WindowData{str: match x{ int{ x.str() } string{ x } } },
	"y_raw":WindowData{str: match y{ int{ y.str() } string{ y } } },
	"w_raw":WindowData{str: match w{ int{ w.str() } string{ w } } },
	"h_raw":WindowData{str: match h{ int{ h.str() } string{ h } } },
        "hi":	WindowData{bol:hi},
        "fn":   WindowData{fun:fun}
    }
}

@[unsafe]
fn draw_map(app &Window, object map[string]WindowData){
    unsafe{
        draw_image(app, object)
        app.gg.set_text_cfg(size:20)
        text_width, text_height:=app.gg.text_size(map_source)
        app.gg.draw_rounded_rect_filled(object["x"].num, object["y"].num+object["h"].num-text_height-8, text_width+8, text_height+8, app.round_corners, gx.Color{r:0, g:0, b:0, a:190})
        app.gg.draw_text(object["x"].num+4, object["y"].num+object["h"].num-text_height/2-4, map_source, gx.TextCfg{
            color: gx.white
            size: 20
            align: .left
            vertical_align: .middle
        })
    }
}
