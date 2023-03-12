/// @description Insert description here
// You can write your code in this editor

/* TODO:
	Write general code for quantum objects, and simply inherit
	this object when making a quantum object!
*/
event_inherited()

alarm[0] = 100;

spawns = [];

warp_pos = function(){
	if(is_seen == false){
		for(var i = 0; i < array_length(spawns); i++){ 
			var spawn_x = spawns[i][0];
			var spawn_y = spawns[i][1];
			var player_collide = collision_rectangle(spawn_x, spawn_y, spawn_x + self.sprite_width, spawn_y + self.sprite_height, obj_player, false, false);
			var solid_collide = collision_rectangle(spawn_x, spawn_y, spawn_x + self.sprite_width, spawn_y + self.sprite_height, obj_solid_parent, false, false);
			if(player_collide == noone and solid_collide == noone){
				//can warp to	
				self.x = spawn_x;
				self.y = spawn_y;
				break;
			}
		}
	}
}