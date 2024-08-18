module mui

import os
import os.font

const text_cursor="|"
const os_font=get_os_font()

fn get_os_font()string{
    if os.exists("C:/Windows/Fonts/segoeui.ttf"){
        return "C:/Windows/Fonts/segoeui.ttf"
    }
    return font.default()
}