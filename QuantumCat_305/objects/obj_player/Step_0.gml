 /// @description Insert description here
// You can write your code in this editor

// basic movement variables (will upd later)

var move_left = keyboard_check(ord("A"));
var move_right = keyboard_check(ord("D"));
var move_jump = -1 * (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_space));	

x_move_dir = move_right - move_left;
y_move_dir = move_jump;

var look_left = keyboard_check(vk_left);
var look_right = keyboard_check(vk_right);
var look_up = keyboard_check(vk_up);
var look_down = keyboard_check(vk_down);

x_look = 1 * image_xscale;
y_look = 0;

if(look_left or look_right){
	x_look = look_right - look_left;
} else if(look_down or look_up){
	x_look = 0;
}
if(x_look == 0 and !(look_down or look_up)){
	x_look = 1 * image_xscale;	
}
if(look_down or look_up) y_look = look_down - look_up;
if(x_look == 0 and !(look_down or look_up) or (look_down and look_up)){
	x_look = 1 * image_xscale;	
}
eye_x = obj_player.x;
eye_y = obj_player.y - 18;

view_distance = 200;
if(image_xscale == -1){
	view_distance *= -1;
}
view_angle = pi/3;

sight_polygons = get_sight_polygon(id, view_distance,view_angle,eye_x,eye_y,x_look,y_look); 
get_shadow_polygon(view_angle,eye_x,eye_y,x_look,y_look);
apply_movement(x_move_dir, y_move_dir, x_look, y_look);










