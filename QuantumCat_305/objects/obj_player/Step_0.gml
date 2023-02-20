/// @description Insert description here
// You can write your code in this editor

// basic movement variables (will upd later)

var move_left = keyboard_check(ord("A"));
var move_right = keyboard_check(ord("D"));
var move_jump = -1 * (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_space));	
var x_move_dir = move_right - move_left;
var y_move_dir = move_jump;

apply_movement(x_move_dir, y_move_dir)







