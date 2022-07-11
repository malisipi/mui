import malisipi.mui as m

#flag -w // for easy debugging

mut app:=m.create(m.WindowConfig{ title:"MUI", scrollbar:true, width:400, height: 500 view_area:[1000,1000] })

app.rect(m.Widget{ id:"rect", x:0, y:0, width:170, height:420 })
app.label(m.Widget{ id:"label", x: 20, y:20, text:"This is a label" })
app.button(m.Widget{ id:"button", x: 20, y:50, text:"Button" })
app.progress(m.Widget{ id:"progress", x:20, y: 80, percent:25 })
app.textbox(m.Widget{ id:"textbox", x:20, y:110, text:"I'm a textbox"})
app.password(m.Widget{ id:"password", x:20, y:140, text:"Password"})
app.checkbox(m.Widget{ id:"checkbox", x:20, y:170, width:20, text:"Check me!"})
app.selectbox(m.Widget{ id:"selectbox", x:20, y:200, list:["English","Turkish","Spanish"], text:"Language" })
app.slider(m.Widget{ id:"slider", x:20, y:230, value_max:50 })
app.link(m.Widget{ id:"link", x:20, y:260, text:"MUI (Github)", link:"https://github.com/malisipi/mui/" })
app.group(m.Widget{ id:"group", x:20, y:290, height:110, text:"Animal" })
app.radio(m.Widget{ id:"radio", x:40, y:310, height:20, list:["Cat","Dog","Bird"]})
app.switch(m.Widget{ id:"switch", x:200, y:20, width:50 text:"Switch me!"})
app.image(m.Widget{ id:"image", x: 200, y:50, path:"v-logo.png", width:100, height:100 })

app.run()
