/// @description Insert description here
// You can write your code in this editor
x=obj_camera.cx;
y=obj_camera.cy;
//show_debug_message(image_index);
if(global.play_next == 1){
	visible = 1;
	image_speed = 1;
}
if(image_index == 9&&visible ==1) {
	image_index = 0;
	visible = 0;
	image_speed = 0;
	global.play_next = 0;
}
