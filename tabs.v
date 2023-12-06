module mui
/*
tabs:[
    ["Test Tab","test_tab"]
]
*/
@[unsafe]
fn tabbed_view_button_onclick(event_details EventDetails, mut app &Window, mut app_data voidptr){
    unsafe {
        mut button:=app.get_object_by_id(event_details.target_id)[0]
        mut main_frame:=app.get_object_by_id(button["tabvw"].str)[0]
        frame0:=app.get_object_by_id(main_frame["acttb"].str)[0]
        frame1:=app.get_object_by_id(event_details.target_id.replace("@mui__tabs__",""))[0]
        frame0["hi"].bol=true
        frame1["hi"].bol=false
        main_frame["acttb"]=frame1["id"]
    }
}

@[unsafe]
pub fn add_tabbed_view(mut app &Window, id string, tabs [][]string, hidden bool, x IntOrString, y IntOrString, w IntOrString, h IntOrString,  frame string, zindex int, active_tab string){
    unsafe {
        app.frame( Widget{ id:id, x:x, y:y, width:w, height:h, hidden:hidden, frame:frame, z_index:zindex })
        for which_tab,tab in tabs {
            mut is_hidden:=true
            if active_tab==tab[1]{
                is_hidden=false
                app.get_object_by_id(id)[0]["acttb"]=WindowData{str:tab[1]}
            }
            app.button( Widget{ id:"@mui__tabs__"+tab[1], text:tab[0] ,x:(100/tabs.len*which_tab).str()+"%x +2", y:2, width:(100/tabs.len).str()+"%x -4", height:26, onclick:tabbed_view_button_onclick, frame:id } )
            app.get_object_by_id("@mui__tabs__"+tab[1])[0]["tabvw"]=WindowData{str:id}

            app.frame( Widget{ id:tab[1], x:0, y:30, height:"100%y -30", width:"100%x", hidden:is_hidden, frame:id } )
        }
    }
}
