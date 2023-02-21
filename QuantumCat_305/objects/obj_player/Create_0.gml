/// @description Insert description here
// You can write your code in this editor
// x vars
x_move_spd = 3;

// y vars
y_move_spd = 0;
jump_height = 5; 
grav = 0.3;
depth = -1000
/* TODO:
	implement a check_collision function?
	gravity might be replaced with environmental gravity when the system is done
	maybe merge apply_movement with kb_check?
	only implemented x movement for update sprite
*/
function update_sprite(x_move_dir, y_move_dir){
	/* 
		Updates player sprite.
		Params:
		x_move_dir : the horizontal unit direction which the player is going to.
		y_move_dir : the vertical unit direction which the player is going to.
	*/	
	show_debug_message(x_move_dir);
	if(x_move_dir == 0 ){
		sprite_index = spr_player_idle;
	} else {
		sprite_index = spr_player_move;
	}
	
	if(x_move_dir != 0) image_xscale = sign(x_move_dir) // flip sprite
		
}
function apply_movement(x_move_dir, y_move_dir){
	/* 
		Applys movement to player.
		Params:
		x_move_dir : the horizontal unit direction which the player is going to.
		y_move_dir : the vertical unit direction which the player is going to.
	*/
	// x movement
	var x_move = x_move_dir * x_move_spd;
	
	if(place_meeting((x + x_move), y, obj_unmovable_parent)){
		while(!place_meeting((x + sign(x_move_dir)), y, obj_unmovable_parent)){
			x += sign(x_move_dir);
		}
		x_move = 0;
	}
	
	x += x_move;	

	// y movement
	
	y_move_spd += grav;

	if(place_meeting(x, (y + y_move_spd), obj_unmovable_parent)){
		while(!place_meeting(x, y + sign(y_move_spd), obj_unmovable_parent)){
			y += sign(y_move_spd);
		}
		y_move_spd = 0;
	}
	
	var is_grounded = place_meeting(x,y+1,obj_unmovable_parent);	
	
	if(is_grounded and y_move_dir == -1){
		y_move_spd -= jump_height;
	}
	
	y += y_move_spd;

	//update sprite
	update_sprite(x_move_dir, y_move_dir);
}