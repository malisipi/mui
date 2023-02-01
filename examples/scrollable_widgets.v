import malisipi.mui as m

mut app:=m.create(title:"MUI", scrollbar:true, width:800, height: 600 view_area:[1000,1000])

app.textarea(id:"textarea", x:20, y:20, width:160, height:200, text:"1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20")
app.scrollbar(id:"textarea_scrollbar", x:180, y:20, width: 20, height:200, vertical:true, connected_widget:app.get_object_by_id("textarea")[0])

app.run()
