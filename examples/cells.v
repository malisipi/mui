import malisipi.mui as m

const (
    cols=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    rows=100
    cell_size=[80,25]
    view_area=[(cols.len+1)*cell_size[0],(rows+1)*cell_size[1]]
)
fn is_this_number(value string) bool { return value.int() != 0 || (value.int()==0 && value.replace("0","").len==0) }

fn calculate_cell(mut app &m.Window, value string) int {
    if is_this_number(value) { return value.int() }
    else {
        operation:=if value.starts_with("-"){ "0 "+value } else { value }.replace("+"," + ").replace("-"," - ").replace("   "," ").replace("  "," ").split(" ")
        mut res:=0
        mut current_operation:="+"
        for w,item in operation{
            if w%2==0 {
                if is_this_number(item){ res = res + if current_operation=="+" {item.int()} else {-1*item.int()} }
                else {
                    unsafe {
                        cell_data:=app.get_object_by_id("cell_"+item#[0..1]+"_"+item#[1..])[0]["ph"].str.int()
                        res = res + if current_operation=="+" {cell_data} else {-1*cell_data}
                    }
                }
            } else {
                current_operation=item
            }
        }
        return res
    }
    return 0
}

fn update_cell(event_details m.EventDetails, mut app &m.Window, app_data voidptr){
    unsafe{ app.get_object_by_id(event_details.target_id)[0]["ph"].str=calculate_cell(mut app, event_details.value.replace("\0","")).str() }
}

mut app:=m.create(m.WindowConfig{ title:"Cells - MUI Example", height:600, width:800, scrollbar:true, view_area:view_area })

for w0,c0 in cols{
    for w1 in 0..rows{
        app.textbox(m.Widget{ id:"cell_"+c0+"_"+w1.str(), x:(w0+1)*cell_size[0], y:(w1+1)*25, width:cell_size[0], height:cell_size[1], placeholder:"0", ph_as_text:true, onchange:update_cell })
    }
}

app.rect(m.Widget{ id:"rect1", x:0, y:"& 0", width:view_area[0], height:cell_size[1], placeholder:"0", ph_as_text:true })
app.rect(m.Widget{ id:"rect2", x:"& 0", y:0, width:cell_size[0], height:view_area[1], placeholder:"0", ph_as_text:true })

for w,c in cols {
    app.label(m.Widget{ id:"col_"+c, x:(w+1)*cell_size[0], y:"& 0", width:cell_size[0], height:cell_size[1], text:c })
}
for r in 0..rows {
    app.label(m.Widget{ id:"row_"+r.str(), x:"& 0", y:(r+1)*cell_size[1], width:cell_size[0], height:cell_size[1], text:r.str() })
}

app.rect(m.Widget{ id:"rect3", x:"& 0", y:"& 0", width:cell_size[0], height:cell_size[1], placeholder:"0", ph_as_text:true })

m.run(mut app)
