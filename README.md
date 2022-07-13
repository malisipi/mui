# MUI - A Cross-Platform UI Library _for V_

![MUI Demo](./pictures/MUI_Demo.gif "MUI Demo")

> **Supports Windows, Linux & Android (Very Experimental)<sup>1</sup>**. *Not tested on MacOS<sup>2</sup>.*

> 1: Themes, screen reader, dialogs, virtual keyboard & map widget not working on Android now, also touch support could be faulty. Also, you need to use [V Android Bootstrapper](https://github.com/vlang/vab) to compile for Android.

> 2: All critical processes (like Widget drawing, click handling etc.) should work on MacOS. But themes and screen reader won't work, and could be include MacOS-only bug.

## Example

```v
import mui as m

fn increase_count(event_details m.EventDetails,mut app &m.Window, app_data voidptr){
	unsafe{   app.get_object_by_id("count")[0]["text"].str=(app.get_object_by_id("count")[0]["text"].str.int()+1).str()   }
}

mut app:=m.create(m.WindowConfig{ title:"Counter - MUI Example", height:100, width:400 })

app.label(m.Widget{ id:"count", x:"5%x", y:"5%y", width:"45%x", height:"90%y" text:"0" })
app.button(m.Widget{ id:"count_button", x:"# 5%x", y:"5%y", width:"45%x", height:"90%y", text:"Count", onclick:increase_count })

app.run()
```

You can find more examples in `./examples/` folder.

## Abilities

* Theme from system accent color, _If couldn't found accent color, use dark/light theme preference. If couldn't found dark/light theme preference, choose light theme_
![Themes](./pictures/Themes.png "Themes")
* Widgets
    * Slider (Verical & Horizontal)
    * Button
    * Label
    * Textbox
    * Password
    * Group
    * Rect
    * Image
    * Progress
    * Radio Button
    * Checkbox
    * Link
    * Selectbox
    * Table
    * Graphs
    * Menubar
    * Map
    * Switch
    * Textarea
    * Codefield
    * Scrollbar (Verical & Horizontal)
* Screen Reader Support (Experimental)
* Emoji Icon Support
* Dialogs
    * Messagebox
    * Inputbox
    * Passwordbox
    * Color Chooser
    * File Open/Save Dialog
    * Folder Open Dialog
    * Notification Support
* Anchor System
* Transition Animations (Supports Anchors)
* File Drag-n-Drop
* Ask Quit Dialog & Quit Function

## To-Do List

* Syntax Highlighting For Codefield
* Tabs
* Treeview
* Status Bar
* Spinner
* Spin Button
* Editable Label
* Disable Status (for Buttons, Checkboxs, Selectboxs, etc.)
* Custom Colors for Widgets (except Themes)
* Handle Appearance Preferences (like Background Color, Text Color)
* Improve Light Theme
* GUI Builder
* Hot Code Reloading
* Load UI from External XML/JSON File
* Improve Documentation
* Context Menu
* Bar Chart
* Pie Chart
* Column Chart
* Gauge chart
* Area Graph
* Keybindings

## Installation

> To install, run `v install https://github.com/malisipi/mui`

> To remove, run `v remove malisipi.mui`

# Compile-Time Flags

| Flags       | Description                              |
|-------------|------------------------------------------|
| -d show_fps | Show FPS of the window                   |
| -d no_emoji | Disable emoji support and font embedding |

## Known Bugs

* Draws widget overflowing from the window. That cause' more cpu usage.
* Anchor system won't works correctly with radio button.

## License

* **This project licensed by [Apache License 2.0](./LICENSE).**
* [Tinyfiledialogs](https://sourceforge.net/projects/tinyfiledialogs/) (`./tinyfiledialogs/`) licensed by Zlib License.
* [Noto Emoji Font](https://fonts.google.com/noto/specimen/Noto+Emoji) (`./noto_emoji_font/`) licensed by OFL License.
* [V-logo](https://github.com/vlang/v-logo) (`./examples/v-logo.png`) licensed by MIT license.

## Documentation

You can read documentation from [here](./docs.md)
