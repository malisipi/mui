# MUI - A Cross-Platform UI Library _for V_

![MUI Demo](./pictures/MUI_Demo.gif "MUI Demo")

> **Supports Windows, Linux & Android<sup>1</sup>**. *Not tested on MacOS<sup>2</sup>.*

> 1: System themes & map widget not working on Android now. If you interested with compiling for android, look [here](#compile-for-android)

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
    * Map (Desktop Only)
    * Switch
    * Textarea
    * Codefield
    * Scrollbar (Verical & Horizontal)
* Custom/Thirdparty Widget Support (Not Finished Completely Yet)
* Screen Reader Support (Experimental - Desktop Only)
* Emoji Icon Support (Desktop Only)
* Dialogs
    * Messagebox (Tinyfiledialogs & built-in)
    * Inputbox (Tinyfiledialogs & built-in)
    * Passwordbox (Tinyfiledialogs & built-in)
    * Color Chooser (Tinyfiledialogs & built-in)
    * File Open/Save Dialog (Tinyfiledialogs)
    * Folder Open Dialog (Tinyfiledialogs)
    * Notification Support (Tinyfiledialogs)
    * Custom Dialog Support (Not Finished Completely Yet)
* Anchor System
* Transition Animations (Supports Anchors)
* File Drag-n-Drop (Desktop Only)
* Ask Quit Dialog & Quit Function (Desktop Only)

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

## Compile-Time Flags

| Flags       | Description                              |
|-------------|------------------------------------------|
| -d show_fps | Show FPS of the window                   |
| -d no_emoji | Disable emoji support and font embedding |

## Compile for android

* You need to use [V Android Bootstrapper](https://github.com/vlang/vab) to compile for Android.
* Tinyfiledialogs won't work on Android, but you can use built-in dialogs.
* If you want to working keyboard, you need patch the sokol library that placed into v/thirdparty. You can found the patch file from `./patches`.

## Known Bugs

* Anchor system won't works correctly with radio button.

> If you have a problem/question or feature request about MUI, you can create a issue.

## Suggestions

* You should run processes that required more time than 0.2s as concurrent. If you don't, app couldn't response until finish processes.
    * Also dialogs (specially, built-in dialogs) must to be runned concurrent as different functions than main threads. If don't, app never response.
    ```v
    //Don't (App never response when call the function)
    fn run_dialog(event_details m.EventDetails,mut app &m.Window, app_data voidptr){
        app.create_dialog(m.Modal{typ:"messagebox",message:"Hello, "+app.wait_and_get_answer(),title:"Hi!"})
        print(app.wait_and_get_answer())
    }

    //Do
    fn do_another_process(mut app &m.Window){
        app.create_dialog(m.Modal{typ:"messagebox",message:"Hello, "+app.wait_and_get_answer(),title:"Hi!"})
        print(app.wait_and_get_answer())
    }

    fn run_dialog(event_details m.EventDetails,mut app &m.Window, app_data voidptr){
        go do_another_process(mut app)
    }
    ```

## License

* **This project licensed by [Apache License 2.0](./LICENSE).**
* [Tinyfiledialogs](https://sourceforge.net/projects/tinyfiledialogs/) (`./tinyfiledialogs/`) licensed by Zlib License.
* [Noto Emoji Font](https://fonts.google.com/noto/specimen/Noto+Emoji) (`./noto_emoji_font/`) licensed by OFL License.
* [V-logo](https://github.com/vlang/v-logo) (`./examples/v-logo.png`) licensed by MIT license.
* [Original Sokol](https://github.com/floooh/sokol) and [Sokol Patch](https://github.com/floooh/sokol/pull/503) (`./patches/sokol.patch`) licensed by Zlib license.

## Documentation

You can read documentation from [here](./docs.md)
