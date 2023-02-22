/// @description Insert description here
// You can write your code in this editor
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true); // bbox
function shoot(lx, ly, rx, ry, start_x, start_y){
	var midx = int64((lx+rx+1)/2), midy = int64((ly+ry+1)/2);
	while(abs(rx-lx) > 1 || abs(ry-ly) > 1){
		midx = int64((lx+rx+1)/2);
		midy = int64((ly+ry+1)/2);
		if(collision_line(start_x, start_y, midx, midy, obj_unmovable_parent, 0, 0)){
			rx = midx - 1;
			ry = midy - 1;
		} else {
			lx = midx;
			ly = midy;
		}
	}
	show_debug_message(lx)
	show_debug_message(rx)
	draw_line(start_x, start_y, rx, ry);
}

function draw_sight(view_distance, view_angle, start_x, start_y, line_count){
	
	var line_length = abs(view_distance * (1/cos(view_angle/2)));
	line_count /= 2;
	for(var i=0; i<view_angle; i += view_angle/line_count){
		var unit_upper_x = (view_distance * cos(i));
		var unit_upper_y = (view_distance * sin(i));
	
		var unit_stretch = line_length / abs(view_distance);
		var upper_x = unit_upper_x * unit_stretch;
		var upper_y = unit_upper_y * unit_stretch;
		var lx = start_x, ly = start_y, rx = start_x + upper_x, ry = start_y - upper_y;
		shoot(lx, ly, rx, ry, start_x, start_y);
		rx = start_x + upper_x;
		ry = start_y + upper_y;
		shoot(lx, ly, rx, ry, start_x, start_y);
    	}
}

// temp code, depracate soon! 
eye_x = x;
eye_y = y - 18;

view_distance = 200;
if(image_xscale == -1){
	view_distance *= -1;
}
view_angle = pi/6;
line_count = 1;
draw_sight(view_distance,view_angle,eye_x,eye_y,line_count); 