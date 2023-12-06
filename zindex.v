module mui

fn raw_map_string_into_map(raw_list string) map[string]int {
    mut list:=map[string]int{}
    list_split:=raw_list.split("#")
    for w in 0..raw_list.len {
        item_split:=list_split[w].split("|")
        list[item_split[0]]=item_split[1].int()
    }
    return list
}

@[unsafe]
fn sort_widgets_with_zindex_fn(a &map[string]WindowData, b &map[string]WindowData) int {
    unsafe {
        mut static frame_list_raw := "" // maps not supported by static, but string supports "frame|14#frame2|25" => {"frame":14, "frame2":25}
        mut frame_list := raw_map_string_into_map(frame_list_raw)
        if a["type"].str=="frame" {
            frame_list[a["id"].str]=a["z_ind"].num
        }
        a_zindex:=if a["in"].str=="" {
            a["z_ind"].num
        } else {
            frame_list[a["in"].str]+a["z-index"].num+1
        }

        b_zindex:=if b["in"].str=="" {
            b["z_ind"].num
        } else {
            frame_list[b["in"].str]+b["z-index"].num+1
        }
        if a_zindex > b_zindex {
            return 1
        }
        if a_zindex < b_zindex {
            return -1
        }
        return 0
    }
}

pub fn (mut app Window) sort_widgets_with_zindex(){
    app.objects.sort_with_compare(sort_widgets_with_zindex_fn)
}
