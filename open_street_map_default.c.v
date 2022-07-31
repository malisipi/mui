module mui

fn map_deg2num(lat_deg f64, lon_deg f64, zoom int) (int, int) {
    return 0,0
}

fn map_download(zoom int, x int, y int) string{
    return ""
}

pub fn add_map(mut app &Window, zoom int, lat f64, lon f64, id string, x string|int, y string|int, w string|int, h string|int, hi bool, fun OnEvent, frame string){
}

[unsafe]
fn draw_map(app &Window, object map[string]WindowData){
}
