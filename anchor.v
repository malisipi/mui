module mui

fn calc_get_percent(window_size []int, percent string) int {
	mut x:=0
	match percent.split("%")[1]{
		"x"{
			x=window_size[0]
		} "y"{
			x=window_size[1]
		} else {}
	}
	return percent.split("%")[0].int()*x/100
}

fn calc_size(window_size []int, w int|string, h int|string) (int, int){
	mut data:=[]int{}
	for x in [w,h]{
		match x{
			int{
				data << x
			} string {
				params:=x.split(" ")
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

fn calc_x_y(window_size []int, x int|string, y int|string, size []int) (int, int){
	mut data:=[]int{}
	for w, q in [x,y].clone(){
		match q{
			int{
				data << q
			} string {
				if q.starts_with("#"){
					params:=q.replace("# ","").split(" ")
					offset:=if w==0{window_size[0]} else {window_size[1]}-size[w]
					match params.len{
						1 {
							if params[0].split("%").len==1{
								data << offset-params[0].int()
							} else {
								data << offset-calc_get_percent(window_size, params[0])
							}
						} 2 {
							data << offset-calc_get_percent(window_size, params[0]) + params[1].int()
						} else {
							error("Unable to calculate position. Parameters should be like `50%x`, `90`, `# 25%x +50` ")
						}
					}
				} else {
					params:=q.split(" ")
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
							error("Unable to calculate position. Parameters should be like `50%x`, `90`, `# 25%x +50` ")
						}
					}
				}
			}
		}
	}
	return data[0], data[1]
}

fn calc_points(window_size []int, x int|string, y int|string, w int|string, h int|string) []int{
	calc_width,calc_height:=calc_size(window_size, w, h)
	x_,y_:=calc_x_y(window_size, x, y, [calc_width, calc_height])
	return [x_,y_,calc_width, calc_height]
}
