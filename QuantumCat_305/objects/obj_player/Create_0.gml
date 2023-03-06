/// @description Insert description here
// You can write your code in this editor
// x vars
x_move_spd = 3;

// y vars
y_move_spd = 0;
jump_height = 5; 
grav = 0.3;
depth = -1000
// draw
/* TODO:
	implement a check_collision function?
	gravity might be replaced with environmental gravity when the system is done
	maybe merge apply_movement with kb_check?
	only implemented x movement for update sprite
*/

//create fov surface
fovsurface = surface_create(window_get_width(),window_get_height());


// for jumping animation 
frame_cntr_1 = 0;
frame_cntr_2 = 0;

function update_sprite(x_move_dir, y_move_dir, is_grounded, y_move_spd, is_jump = 0){
	/* 
		Updates player sprite.
		Params:
		x_move_dir : the horizontal unit direction which the player is going to.
		y_move_dir : the vertical unit direction which the player is going to.
		is_grounded : check if the player is grounded.
		y_move_spd : gives the current speed of the player.
	*/	
	
	in_y_jumping = false;
	if(is_jump == false and is_grounded == true and (sprite_index != spr_player_jump or (sprite_index == spr_player_jump and image_index = 6))){
		in_y_jumping = false;	
	} else {
		in_y_jumping = true;
	}
	
	// Y
	if(is_jump == true){
		image_speed = 0; 
		sprite_index = spr_player_jump;	
		image_index = 0;
		frame_cntr_1 = 0;
		frame_cntr_2 = 0;
	} else if(in_y_jumping == false){
		image_speed = 1;	
	}
	if(is_grounded == false){
		if(frame_cntr_1 == 5){			
			switch(image_index){
				case 0:
					image_index = 1;
				break;
				case 1:
					image_index = 2; //jumping up 
				break;	
				default:
				break;
			}
			if(y_move_spd >= 0){ // falling;
				image_index = 3; // falling animation
			}
			frame_cntr_1 = 0;
		}
		frame_cntr_1 += 1;
	} else if(sprite_index == spr_player_jump){
		// grounded animations;	
		if(frame_cntr_2 == 3){			
			switch(image_index){
				case 3:
					image_index = 4;
				break;
				case 4:
					image_index = 5; //jumping up 
				break;	
				case 5:
					image_index = 6; // final!
				break;
			}
			frame_cntr_2 = 0;
		}
		frame_cntr_2 += 1;		
	}
	
	// x
	if(in_y_jumping == false){
		if(x_move_dir == 0){ // x animations only preform when no y animations
			sprite_index = spr_player_idle;
		} else {
			sprite_index = spr_player_move;
		}	
	}
	
	if(x_move_dir != 0){
		image_xscale = sign(x_move_dir) // flip sprite
	}
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
	var is_jump = 0;
	
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
		is_jump = true;
	}
	
	y += y_move_spd;

	//update sprite
	update_sprite(x_move_dir, y_move_dir, is_grounded, y_move_spd, is_jump);
}