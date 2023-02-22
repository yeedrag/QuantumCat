/// @description Insert description here
// You can write your code in this editor
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true); // bbox

function draw_sight(view_distance, view_angle, start_x, start_y){
	
	var line_length = abs(view_distance * (1/cos(view_angle/2)));
	
	var unit_upper_x = (view_distance * cos(view_angle/2));
	var unit_upper_y = (view_distance * sin(view_angle/2));
	var unit_lower_x = unit_upper_x;
	var unit_lower_y = -unit_upper_y;
	
	var unit_stretch = line_length / sqrt(sqr(unit_upper_x)+sqr(unit_upper_y)); // same for both
	
	var upper_x = unit_upper_x * unit_stretch;
	var upper_y = unit_upper_y * unit_stretch;
	var lower_x = unit_lower_x * unit_stretch;
	var lower_y = unit_lower_y * unit_stretch;
	
	draw_line(start_x, start_y, start_x + view_distance , start_y); // for testing
	draw_line(start_x, start_y, start_x + upper_x, start_y - upper_y);
	draw_line(start_x, start_y, start_x + lower_x , start_y - lower_y);
	
}

// temp code, depracate soon! 
eye_x = x;
eye_y = y - 18;

view_distance = 200;
if(image_xscale==-1){
	view_distance *= -1;
}
draw_sight(view_distance,pi/4,eye_x,eye_y)