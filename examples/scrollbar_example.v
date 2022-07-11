import malisipi.mui as m

mut app:=m.create(m.WindowConfig{ title:"Scrollbar - MUI Example", height:300, width:300, scrollbar:true, view_area:[300,800] })

app.label(m.Widget{ id:"text1", x:"10%x", y:"50", width:"80%x", height:"50" text:"Example Text - Scroll Down" })
app.label(m.Widget{ id:"text2", x:"& 10%x", y:"& 125", width:"80%x", height:"50" text:"Example Text 2 - Fixed Position" })
app.label(m.Widget{ id:"text3", x:"10%x", y:"650", width:"80%x", height:"50" text:"Example Text 3 - Hi!" })

app.run()
