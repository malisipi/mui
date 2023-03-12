import malisipi.mui
import miniaudio as ma // v install https://github.com/malisipi/miniaudio
import math
import time

const (
    open_file_emoji="⤵"
    play_emoji="▶️"
    pause_emoji="⏸️"
)

struct AppData{
mut:
    file        string
    device      &ma.AudioDevice
    music       ma.Sound
}

fn map_play_time(the_time int) string{
    return "${the_time/60:02}:${the_time%60:02}"
}

fn move_play_slider(mut app &mui.Window, mut app_data &AppData){
    if app_data.music.audio_buffer==voidptr(0) { return }
    if app_data.music.audio_buffer.playing{
        unsafe{
            app.get_object_by_id("play_slider")[0]["val"].num=math.min(app.get_object_by_id("play_slider")[0]["val"].num+1,app.get_object_by_id("play_slider")[0]["vlMax"].num)
        }
    }
}

fn update_play_slider(mut app &mui.Window, mut app_data &AppData){
    for {
        time.sleep(1000*time.millisecond)
        go move_play_slider(mut &app, mut &app_data)
    }
}

fn load_music(file_path string, mut app &mui.Window, mut app_data &AppData){
    file_ext:=file_path.split(".")[file_path.split(".").len-1]
    if !(file_ext=="mp3" ||  file_ext=="wav" ||  file_ext=="flac"){
        mui.messagebox("MPlayer","."+file_ext+" Files Not Supported","ok","error")
        return
    }
    app_data.music=ma.Sound{audio_buffer:voidptr(0)}
    app_data.device.free()
    app_data.device=ma.device()
    app_data.music=ma.sound( file_path )
    app_data.device.add("",app_data.music)
    app_data.music.play()
    unsafe {
        app.get_object_by_id("play_button")[0]["text"].str=pause_emoji
        app.get_object_by_id("play_slider")[0]["vlMax"].num=int(app_data.music.length()/1000)
        app.get_object_by_id("play_slider")[0]["val"].num=0
        app.get_object_by_id("volume_slider")[0]["val"].num=100
        mut file_name:=file_path.split("/")[file_path.split("/").len-1]
        file_name=file_name.split("\\")[file_name.split("\\").len-1]
        app.get_object_by_id("now_playing")[0]["text"].str=file_name
    }
}

fn load_music_file_dialog(mut app &mui.Window, mut app_data &AppData){
    file_path:=mui.openfiledialog("MPlayer")
    if file_path!=""{
        load_music(file_path, mut app, mut app_data)
    }
}

fn load_music_button(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    go load_music_file_dialog(mut app, mut app_data)
}

fn load_music_file_handler(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    load_music(event_details.value, mut app, mut app_data)
}

fn seek_to_time(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    if app_data.music.audio_buffer==voidptr(0) { mui.messagebox("MPlayer","Open a music file","ok","warning") return }
    app_data.music.pause()
    app_data.music.seek(event_details.value.int()*1000)
    app_data.music.play()
    unsafe {
        app.get_object_by_id("play_button")[0]["text"].str=pause_emoji
    }
}

fn change_vol(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    if app_data.music.audio_buffer==voidptr(0) { mui.messagebox("MPlayer","Open a music file","ok","warning") return }
    app_data.music.volume(f32(event_details.value.int())/100)
}

fn toggle_music(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    if app_data.music.audio_buffer==voidptr(0) { mui.messagebox("MPlayer","Open a music file","ok","warning") return }
    if app_data.music.audio_buffer.playing{
        app_data.music.pause()
        unsafe {
            app.get_object_by_id("play_button")[0]["text"].str=play_emoji
        }
    } else {
        app_data.music.play()
        unsafe {
            app.get_object_by_id("play_button")[0]["text"].str=pause_emoji
        }
    }
}

fn main(){
    mut app_data:=AppData{
        device:ma.device()
    }

    mut app:=mui.create(mui.WindowConfig{ title:"MPlayer - MUI Example", height: 100, width:600, app_data:&app_data, file_handler:load_music_file_handler})

    app.label(mui.Widget{ id:"now_playing" x: 10, y:10, width: "100%x -20", height:"100%y -55", text:"No Song Playing"})
    app.button(mui.Widget{ id:"load_button", x: 10, y:"# 10", width:"25", height:"25" text:open_file_emoji, onclick:load_music_button, icon:true})
    app.button(mui.Widget{ id:"play_button", x: 40, y:"# 10", width:"25", height:"25" text:play_emoji, onclick:toggle_music, icon:true})
    app.slider(mui.Widget{ id:"play_slider", x: 70, y:"# 10", width:"100%x -220", height:25, value_max:1, onunclick:seek_to_time, value_map:map_play_time })
    app.slider(mui.Widget{ id:"volume_slider", x: "# 40", y:"# 10", width:"60", height:25, value:100, value_max:100, step:10, onunclick:change_vol })

    go update_play_slider(mut app, mut &app_data)
    app.run()
}
