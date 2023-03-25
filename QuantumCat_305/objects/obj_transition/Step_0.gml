/// @description Insert description here
// You can write your code in this editor
x=obj_camera.cx;
y=obj_camera.cy;
show_debug_message(image_index);
if(image_index == 8&&visible ==1) {
	room_goto_next();
}
if(image_index == 18 && visible ==1) {
	visible = false
	image_speed=0
	image_index = 0;
}
