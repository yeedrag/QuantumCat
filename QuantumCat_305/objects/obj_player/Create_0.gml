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
	Implement a check_collision function?
	Gravity might be replaced with environmental gravity when the system is done
	Maybe merge apply_movement with kb_check?
*/

//create fov surface
fovsurface = surface_create(window_get_width(),window_get_height());


// For jumping animation 
frame_cntr_1 = 0; // Frame counter for jumping up
frame_cntr_2 = 0;// Frame counter for falling down

function update_sprite(x_move_dir, y_move_dir, is_grounded, y_move_spd, pressed_jump, x_look, y_look){
	/* 
		Updates player sprite.
		Params:
		x_move_dir : the horizontal unit direction which the player is going to.
		y_move_dir : the vertical unit direction which the player is going to.
		is_grounded : check if the player is grounded.
		y_move_spd : gives the current speed of the player.
		pressed_jump : Check if jump button is pressed. Only triggers when jumped from ground.
		x_look : X direction that the player is looking at. L[-1,1]R
		y_look : Y direction that the player is looking at. U[-1,1]D
	*/	
	var x_look_str = "";
	var y_look_str = "";

	// Get sprite name via x,y_look and turn into asset
	if(x_look != 0){
		if(sign(x_look) == sign(image_xscale)){
			x_look_str = "r";
		} else {
			x_look_str = "l";
		}
	} else if (y_look == 0){
		x_look_str = (image_xscale == 1) ? "r" : "l";
	}
	
	if(y_look != 0) y_look_str = (y_look == -1) ? "u" : "d";
	
	var idle_sprite = asset_get_index("spr_player_idle_" + y_look_str + x_look_str);
	var move_sprite = asset_get_index("spr_player_move_" + y_look_str + x_look_str);
	var jump_sprite = asset_get_index("spr_player_jump_" + y_look_str + x_look_str);
	
	
	var in_y_jumping = false; // Checks if is currently in "jumping", a.k.a pressed_jump or jumping up or falling down or in animation
	
	if(pressed_jump == false and is_grounded == true and (sprite_index != jump_sprite or (sprite_index == jump_sprite and image_index = 6))){
		in_y_jumping = false;	
	} else {
		in_y_jumping = true;
	}
	
	// Reset frame counters for jumping animation
	if(pressed_jump == true){
		frame_cntr_1 = 0; 
		frame_cntr_2 = 0;	
		image_index = 0;
	}
	
	if(in_y_jumping == false){
		image_speed = 1;
		if(x_move_dir == 0){ // X animations will only preform when no y animations needed to be preformed
			sprite_index = idle_sprite;
		} else {
			sprite_index = move_sprite;
		}	
	} else {
		image_speed = 0; // To control which animation frame to preform manually
		sprite_index = jump_sprite;	
	}

	if(is_grounded == false){
		if(frame_cntr_1 == 5){			
			if(image_index != 2) image_index += 1; // jumping up
			if(y_move_spd >= 0){ // falling;
				image_index = 3; // falling animation
			}
			frame_cntr_1 = 0;
		}
		frame_cntr_1 += 1;
	} else if(sprite_index == jump_sprite){
		// grounded animations;	
		if(frame_cntr_2 == 3){			
			if(image_index != 6) image_index += 1;
			frame_cntr_2 = 0;
		}
		frame_cntr_2 += 1;		
	}

	if(x_move_dir != 0){
		image_xscale = sign(x_move_dir) // Flip sprite
	}
}

cayote_time = 7; // Frames for cayote time
cayote_cntr = cayote_time; 

function apply_movement(x_move_dir, y_move_dir, x_look, y_look){
	/* 
		Applys movement to the player.
		Params:
		x_move_dir : X unit direction which the player is going to.
		y_move_dir : Y unit direction which the player is going to.
		x_look : X direction that the player is looking at. L[-1,1]R
		y_look : Y direction that the player is looking at. U[-1,1]D
	*/
	
	// X movement
	var x_move = x_move_dir * x_move_spd;
	var pressed_jump = 0;
	
	if(place_meeting((x + x_move), y, obj_solid_parent)){
		while(!place_meeting((x + sign(x_move_dir)), y, obj_solid_parent)){
			x += sign(x_move_dir);
		}
		x_move = 0;
	}
	
	x += x_move;	

	// Y movement
	
	y_move_spd += grav;

	if(place_meeting(x, (y + y_move_spd), obj_solid_parent)){
		while(!place_meeting(x, y + sign(y_move_spd), obj_solid_parent)){
			y += sign(y_move_spd);
		}
		y_move_spd = 0;
	}
	
	var is_grounded = place_meeting(x,y+1,obj_solid_parent);	
	if(y_move_dir == -1){ // Dealing with jump w cayote time
		if(is_grounded == true){
			y_move_spd -= jump_height;
			pressed_jump = true;
			cayote_cntr = 0;	
		} else if(cayote_cntr > 0){ // Cayote time
			y_move_spd = -jump_height;
			pressed_jump = true;
			cayote_cntr = 0;				
		} else {
			cayote_cntr -= 1;	
		}	
	} else if(is_grounded == true){
		cayote_cntr = cayote_time;	
	} else {
		cayote_cntr -= 1;
	}
	
	y += y_move_spd;

	//update sprite
	update_sprite(x_move_dir, y_move_dir, is_grounded, y_move_spd, pressed_jump, x_look, y_look);
}