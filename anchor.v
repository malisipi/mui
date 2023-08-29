module mui

fn calc_get_percent(window_info []int, percent string) int {
	mut x:=0
	match percent.split("%")[1]{
		"x"{
			x=window_info[0]
		} "y"{
			x=window_info[1]
		} else {}
	}
	return percent.split("%")[0].int()*x/100
}

fn calc_size(window_info []int, w IntOrString, h IntOrString) (int, int){
	mut data:=[]int{}
	for x in [w,h]{
		match x{
			int{
				data << x
			} string {
				mut params:=x.split(" ")
				mut window_size:=window_info.clone()
				if x.starts_with("!") {
					params=x.replace("! ","").replace("!","").split(" ")
					window_size=[window_info[2],window_info[3]]
				}
				match params.len{
					1 {
						if params[0].split("%").len==1{
							data << params[0].int()
						} else {
							data << calc_get_percent(window_size, params[0])
						}
					} 2 {
						data << calc_get_percent(window_size, params[0]) + params[1].int()
					} else {
						error("Unable to calculate position. Parameters should be like `50%x`, `90`, `25%x +50` ")
					}
				}
			}
		}
	}
	return data[0], data[1]
}

fn calc_x_y(window_info []int, x IntOrString, y IntOrString, size []int, rtl_layout bool) (int, int){
	mut data:=[]int{}
	for w, r in [x,y].clone(){
		mut x_y_scroll:=window_info#[-2..].clone()
		match r{
			int{
				if rtl_layout && data.len == 0 { //rtl
					data << window_info[0] - (r-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}) - size[0]
				} else {
					data << r-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}
				}
			} string {

				mut q:=r
				mut window_size:=window_info.clone()
				if q.starts_with("!") {
					q=q.replace("! ","").replace("!","")
					window_size=[window_info[2],window_info[3],window_info[4],window_info[5]]
				}
				if q.starts_with("&") {
					x_y_scroll=[0,0]
					q=q.replace("& ","").replace("&","")
				}

					if q.starts_with("#"){
						params:=q.replace("# ","").replace("#","").split(" ")
						offset:=if w==0{window_size[0]} else {window_size[1]}-size[w]
						match params.len{
							1 {
								if params[0].split("%").len==1{
									if rtl_layout && data.len == 0 { //rtl
										data << window_info[0] - (offset-params[0].int() -if w==0{x_y_scroll[0]} else {x_y_scroll[1]}) - size[0]
									} else {
										data << offset-params[0].int() -if w==0{x_y_scroll[0]} else {x_y_scroll[1]}
									}
								} else {
									if rtl_layout && data.len == 0 { //rtl
										data << window_info[0] - (offset-calc_get_percent(window_size, params[0])-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}) - size[0]
									} else {
										data << offset-calc_get_percent(window_size, params[0])-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}
									}
								}
							} 2 {
								if rtl_layout && data.len == 0 { //rtl
									data << window_size[0] - (offset-calc_get_percent(window_size, params[0]) + params[1].int()-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}) - size[0]
								} else {
									data << offset-calc_get_percent(window_size, params[0]) + params[1].int()-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}
								}
							} else {
								error("Unable to calculate position. Parameters should be like `50%x`, `90`, `# 25%x +50` ")
							}
						}
					} else {
						params:=q.split(" ")
						match params.len{
							1 {
								if params[0].split("%").len==1{
									if rtl_layout && data.len == 0 { //rtl
										data << window_info[0] - (params[0].int()-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}) - size[0]
									} else {
										data << params[0].int()-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}
									}
								} else {
									if rtl_layout && data.len == 0 { //rtl
										data << window_info[0] - (calc_get_percent(window_size, params[0])-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}) - size[0]
									} else {
										data << calc_get_percent(window_size, params[0])-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}
									}
								}
							} 2 {
								if rtl_layout && data.len == 0 { //rtl
									data << window_info[0] - (calc_get_percent(window_size, params[0]) + params[1].int()-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}) - size[0]
								} else {
									data << calc_get_percent(window_size, params[0]) + params[1].int()-if w==0{x_y_scroll[0]} else {x_y_scroll[1]}
								}
							} else {
								error("Unable to calculate position. Parameters should be like `50%x`, `90`, `# 25%x +50` ")
							}
						}
					}


			}
		}
	}
	return data[0], data[1]
}

fn calc_points(window_info []int, x IntOrString, y IntOrString, w IntOrString, h IntOrString, rtl_layout bool) []int{
	calc_width,calc_height:=calc_size(window_info, w, h)
	x_,y_:=calc_x_y(window_info, x, y, [calc_width, calc_height], rtl_layout)
	return [x_,y_,calc_width, calc_height]
}
