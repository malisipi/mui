import malisipi.mui

fn main(){
    mut app:=mui.create(mui.WindowConfig{ title:"Vertical Slider - MUI Example", height: 350, width:350})
    app.slider(mui.Widget{ id:"@scrollbar:horizontal", x: 10, y:10, width:25, height:200, value_max:10, vertical:true})
    mui.run(mut app)
}


