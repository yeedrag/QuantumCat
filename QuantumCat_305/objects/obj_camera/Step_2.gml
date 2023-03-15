/// @description Insert description here
// You can write your code in this editor
half_width = camera_get_view_width(view_camera[0]) / 2;
half_height = camera_get_view_width(view_camera[0]) / 2;
if(room_get_name(room)=="title_screen") {
	cx=0;cy=0;
}else {
	cx = obj_player.x - half_width;
	cy = obj_player.y - half_height;
}
// You have to decide the boundary of the camera by the following parameters


cx = clamp(cx, min_view_x , max_view_x);
cy = clamp(cy, min_view_y , max_view_y);

camera_set_view_pos(view_camera[0], cx, cy);