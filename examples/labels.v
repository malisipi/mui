import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Labels - MUI Example", height:400, width:400 })

app.label(m.Widget{ id:"label1", x:"5%x", y:"20", width:"90%x", height:"30", text_size:30, text_align:0, text:"Test 1" })
app.label(m.Widget{ id:"label2", x:"5%x", y:"60", width:"90%x", height:"30", text_size:20, text_align:1, text:"Test 2" })
app.label(m.Widget{ id:"label3", x:"5%x", y:"100", width:"90%x", height:"30", text_size:10, text_align:2, text:"Test 3" })

app.label(m.Widget{ id:"label4", x:"5%x", y:"140", width:"90%x", height:"60", text_size:30, text_align:0, text:"Test 4\nTest 4", text_multiline:true })
app.label(m.Widget{ id:"label5", x:"5%x", y:"220", width:"90%x", height:"60", text_size:20, text_align:1, text:"Test 5\nTest 5", text_multiline:true })
app.label(m.Widget{ id:"label6", x:"5%x", y:"300", width:"90%x", height:"60", text_size:10, text_align:2, text:"Test 6\nTest 6", text_multiline:true })

app.run()
