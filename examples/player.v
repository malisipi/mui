import malisipi.mui
import malisipi.miniaudio as ma // v install https://github.com/malisipi/miniaudio
import math
import time

struct AppData{
mut:
    file        string
    device      &ma.AudioDevice
    music       ma.Sound
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

fn load_music(mut app &mui.Window, mut app_data &AppData){
    file_path:=mui.openfiledialog("MPlayer")
    if file_path!=""{
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
            app.get_object_by_id("play_slider")[0]["vlMax"].num=int(app_data.music.length()/1000)
            app.get_object_by_id("play_slider")[0]["val"].num=0
            app.get_object_by_id("volume_slider")[0]["val"].num=100
            mut file_name:=file_path.split("/")[file_path.split("/").len-1]
            file_name=file_name.split("\\")[file_name.split("\\").len-1]
            app.get_object_by_id("now_playing")[0]["text"].str=file_name
        }
    }
}

fn load_music_button(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    go load_music(mut app, mut app_data)
}

fn seek_to_time(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    if app_data.music.audio_buffer==voidptr(0) { mui.messagebox("MPlayer","Open a music file","ok","warning") return }
    app_data.music.pause()
    app_data.music.seek(event_details.value.int()*1000)
    app_data.music.play()
}

fn change_vol(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    if app_data.music.audio_buffer==voidptr(0) { mui.messagebox("MPlayer","Open a music file","ok","warning") return }
    app_data.music.volume(f32(event_details.value.int())/100)
}

fn toggle_music(event_details mui.EventDetails, mut app &mui.Window, mut app_data &AppData){
    if app_data.music.audio_buffer==voidptr(0) { mui.messagebox("MPlayer","Open a music file","ok","warning") return }
    if app_data.music.audio_buffer.playing{
        app_data.music.pause()
    } else {
        app_data.music.play()
    }
}

fn main(){
    mut app_data:=AppData{
        device:ma.device()
    }

    mut app:=mui.create(mui.WindowConfig{ title:"MPlayer - MUI Example", height: 100, width:600, app_data:&app_data})

    app.button(mui.Widget{ id:"load_button", x: 10, y:"# 10", width:"25", height:"25" text:"O", onclick:load_music_button})
    app.button(mui.Widget{ id:"play_button", x: 40, y:"# 10", width:"25", height:"25" text:"P", onclick:toggle_music})
    app.slider(mui.Widget{ id:"volume_slider", x: "# 30", y:"# 10", width:"60", height:25, value:100, value_max:100, step:10, onunclick:change_vol })
    app.slider(mui.Widget{ id:"play_slider", x: 70, y:"# 10", width:"100%x -180", height:25, value_max:1, onunclick:seek_to_time })
    app.label(mui.Widget{ id:"now_playing" x: 10, y:10, width: "100%x -20", height:"100%y -55", text:"No Song Playing"})

    go update_play_slider(mut app, mut &app_data)
    mui.run(mut app)
}
