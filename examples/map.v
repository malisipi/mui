import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"MUI Demo", width:296, height:296})

app.map(m.Widget{ id:"map", x: "20", y:"20", width:256, height:256})

m.run(mut app)
