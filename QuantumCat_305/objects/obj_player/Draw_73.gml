// @description Insert description here
// You can write your code in this editor
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true); // bbox
function shoot(start_x, start_y, line_end_x, line_end_y){
	ret = collision_line_point(start_x, start_y, line_end_x, line_end_y, obj_unmovable_parent, true, true);
	draw_line(start_x, start_y, ret[1], ret[2]);
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
		var rx = start_x + upper_x;
		var up_ry = start_y - upper_y;
		var down_ry = start_y + upper_y;
		shoot(start_x, start_y, rx, up_ry);
		shoot(start_x, start_y, rx, down_ry);
    }
}

// temp code, depracate soon!  
eye_x = x;
eye_y = y - 18;

view_distance = 200;
if(image_xscale == -1){
	view_distance *= -1;
}

draw_sight_v2(id, view_distance,view_angle,eye_x,eye_y,x_look,y_look); 