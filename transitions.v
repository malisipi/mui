module mui

import time

const (
    transition_fps=60
    transition_time=f64(1)/transition_fps
)

[unsafe]
pub fn move_object(mut app &Window, object_id string, new_pos []int|string, move_time f64){
    unsafe {
        mut object:=app.get_object_by_id(object_id)[0]
        total_step:=move_time/transition_time
        old_x_raw,old_y_raw:=object["x_raw"].str,object["y_raw"].str

        for now_step in 0..int(total_step) {
            real_size:=app.gg.window_size()
            window_info:=[real_size.width-app.x_offset-app.xn_offset,real_size.height-app.y_offset-app.yn_offset,real_size.width,real_size.height,app.scroll_x,app.scroll_y].clone()

            calc_old_pos:=calc_points(window_info,old_x_raw,old_y_raw,object["w"].num,object["h"].num)
            calc_new_pos:=calc_points(window_info,new_pos[0],new_pos[1],object["w"].num,object["h"].num)
            object["x_raw"].str=int(calc_old_pos[0]+f32(calc_new_pos[0]-calc_old_pos[0])/total_step*now_step).str()
            object["y_raw"].str=int(calc_old_pos[1]+f32(calc_new_pos[1]-calc_old_pos[1])/total_step*now_step).str()
            time.sleep(transition_time*time.second)
        }
        for w,last_x_y in new_pos{
            match last_x_y{
                int{
                    object[["x_raw","y_raw"][w]].str=last_x_y.str()
                } string {
                    object[["x_raw","y_raw"][w]].str=last_x_y
                }
            }
        }
    }
}
