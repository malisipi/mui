# malisipi.mui.webview

## Contents
- [create](#create)
- [Webview_t](#Webview_t)
  - [destroy](#destroy)
  - [terminate](#terminate)
  - [run](#run)
  - [set_title](#set_title)
  - [set_size](#set_size)
  - [set_html](#set_html)
  - [navigate](#navigate)
  - [get_window](#get_window)
  - [eval](#eval)
  - [load_html_file](#load_html_file)
  - [bind](#bind)
  - [unbind](#unbind)
  - [rturn](#rturn)
  - [init](#init)

## create
```v
fn create(debug int) Webview_t
```


[[Return to contents]](#Contents)

## Webview_t
## destroy
```v
fn (webview Webview_t) destroy()
```


[[Return to contents]](#Contents)

## terminate
```v
fn (webview Webview_t) terminate()
```


[[Return to contents]](#Contents)

## run
```v
fn (webview Webview_t) run()
```


[[Return to contents]](#Contents)

## set_title
```v
fn (webview Webview_t) set_title(title string)
```


[[Return to contents]](#Contents)

## set_size
```v
fn (webview Webview_t) set_size(width int, height int)
```


[[Return to contents]](#Contents)

## set_html
```v
fn (webview Webview_t) set_html(html string)
```


[[Return to contents]](#Contents)

## navigate
```v
fn (webview Webview_t) navigate(url string)
```


[[Return to contents]](#Contents)

## get_window
```v
fn (webview Webview_t) get_window() voidptr
```


[[Return to contents]](#Contents)

## eval
```v
fn (webview Webview_t) eval(code string)
```


[[Return to contents]](#Contents)

## load_html_file
```v
fn (webview Webview_t) load_html_file(file string)
```


[[Return to contents]](#Contents)

## bind
```v
fn (webview Webview_t) bind(func_name string, func fn (&char, &char, mut voidptr), mut app_data voidptr)
```


[[Return to contents]](#Contents)

## unbind
```v
fn (webview Webview_t) unbind(func_name string)
```


[[Return to contents]](#Contents)

## rturn
```v
fn (webview Webview_t) rturn(seq &char, the_string string)
```


[[Return to contents]](#Contents)

## init
```v
fn (webview Webview_t) init(code string)
```


[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 17 Nov 2022 18:22:49
