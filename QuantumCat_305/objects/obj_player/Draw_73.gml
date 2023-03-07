/// @description Insert description here
// You can write your code in this editor
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true); // bbox
// temp code, depracate soon!  

eye_x = x;
eye_y = y - 18;

view_distance = 200;
if(image_xscale == -1){
	view_distance *= -1;
}
view_angle = pi/3;

draw_sight_v2(id, view_distance,view_angle,eye_x,eye_y,x_look,y_look); 


