import malisipi.mui.webview
import json

struct AppData {
mut:
	web	webview.Webview_t
	arts	[]Article
}

struct Article {
	id	int
	title	string
	text	string
}

fn find_article(arts []Article, id int) Article{
	for art in arts {
		if art.id==id {
			return art
		}
	}
	return Article{}
}

fn handler(seq &char, req &char, mut app_data &AppData) {
	unsafe {
		args:=json.decode([]string,req.vstring())or{return}
		if args[0]=="get_list" {
			app_data.web.rturn(seq, json.encode(app_data.arts))
		} else if args[0]=="get_article" {
			app_data.web.rturn(seq, json.encode(find_article(app_data.arts,args[1].int())))
		}
	}
}

mut app_data:=AppData{
	web:	webview.create(1)
	arts:	[
		Article{id:1, title:"Covid", text:"Article about Covid"},
		Article{id:2, title:"Windows", text:"Article about Windows"},
		Article{id:3, title:"GitHub", text:"Article about GitHub"}
	]
}

app_data.web.set_title("Articles")
app_data.web.set_size(800, 600)
app_data.web.load_html_file("./index.html")
app_data.web.bind("handler", handler, mut &app_data)
app_data.web.run()
app_data.web.destroy()
