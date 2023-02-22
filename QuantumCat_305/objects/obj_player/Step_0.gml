/// @description Insert description here
// You can write your code in this editor

// basic movement variables (will upd later)

var move_left = keyboard_check(ord("A"));
var move_right = keyboard_check(ord("D"));
var move_jump = -1 * (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_space));	
var x_move_dir = move_right - move_left;
var y_move_dir = move_jump;
var change_room =  keyboard_check(vk_alt);


// room switch but maybe shouldn't be here
if (room_exists(room_next(room)) && keyboard_check_pressed(vk_alt)) {
    room_goto_next();
	x = 0;
	y = 0;
	camera_set_view_size(view_camera[0], global.c_width, global.c_height);
}
if (room_exists(room_previous(room)) && keyboard_check_pressed(vk_alt)) {
    room_goto_previous();
	x = 0;
	y = 0;
	camera_set_view_size(view_camera[0], global.c_width, global.c_height);
}
apply_movement(x_move_dir, y_move_dir)








