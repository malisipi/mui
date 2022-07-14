module mui

import sokol.sapp

fn show_keyboard(visible bool){
    if visible {
        if !sapp.keyboard_shown(){
            sapp.show_keyboard(true)
        }
    } else {
        if sapp.keyboard_shown(){
            sapp.show_keyboard(false)
        }
    }
}
