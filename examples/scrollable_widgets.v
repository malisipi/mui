import malisipi.mui as m

user_list:=[
	["Sam",   "Johnson", "29","United States"],
	["Kate",  "Williams","26","Canada"       ],
	["Hank",  "Anderson","34","United States"],
	["Nathan","Drake",   "28","Canada"       ]
]

mut app:=m.create(title:"MUI", scrollbar:true, width:800, height: 600 view_area:[1000,1000])

app.textarea(id:"textarea", x:20, y:20, width:160, height:200, text:"1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20")
app.scrollbar(id:"textarea_scrollbar", x:180, y:20, width: 20, height:200, vertical:true, connected_widget:app.get_object_by_id("textarea")[0])

app.table(id:"table", table:user_list, x:300, y:20, width:380, height:100, row_height:40)
app.scrollbar(id:"table_scrollbar", x:680, y:20, width: 20, height:100, vertical:true, connected_widget:app.get_object_by_id("table")[0])

app.frame(id:"frame", x:20, y:320, width:480, height:230, view_area:[800,600])
app.scrollbar(id:"frame_scrollbar_v", x:500, y:320, width: 20, height:250, vertical:true, connected_widget:app.get_object_by_id("frame")[0])
app.scrollbar(id:"frame_scrollbar_h", x:20, y:550, width: 480, height:20, connected_widget:app.get_object_by_id("frame")[0])

app.list(id:"list", table:user_list, x:20, y:20, width:380, height:100, row_height:40, frame:"frame")
app.scrollbar(id:"list_scrollbar", x:400, y:20, width: 20, height:100, vertical:true, connected_widget:app.get_object_by_id("list")[0], frame:"frame")

app.run()
