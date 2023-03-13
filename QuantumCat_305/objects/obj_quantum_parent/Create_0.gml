/// @description Insert description here
// You can write your code in this editor

/* TODO:
	Write general code for quantum objects, and simply inherit
	this object when making a quantum object!
*/
event_inherited()

alarm[0] = 100;

spawns = [];

viable_spawns = [];

bounds = [];

load_quantum_bounds = function(spawns){
	var quantum_bounds = []
	var num_vertices = self.num_vertices;
	for(var sp = 0; sp < array_length(self.spawns); sp++){
		var sp_bound = [];
		sp_x = spawns[sp][0];
		sp_y = spawns[sp][1];
		for(var j = 1; j < num_vertices; j++){
			var line = new vec_coord(self.vertices_pos[j-1][0] - self.vertices_pos[j][0], self.vertices_pos[j-1][1] - self.vertices_pos[j][1], self, self.vertices_pos[j][0] + sp_x, self.vertices_pos[j][1] + sp_y); 
			array_push(sp_bound,line);
			delete line;
		}
		if(num_vertices > 2){
			var line = new vec_coord(self.vertices_pos[self.num_vertices - 1][0] - self.vertices_pos[0][0], self.vertices_pos[self.num_vertices - 1][1] - self.vertices_pos[0][1], self, self.vertices_pos[0][0] + sp_x, self.vertices_pos[0][1] + sp_y);
			array_push(sp_bound, line);
			delete line;	
		}	
		array_push(quantum_bounds, sp_bound);
	}
	delete sp_bound;
	return quantum_bounds; 
}
warp_pos = function(){
	var perm = [];
	for(var i = 0; i < array_length(spawns); i++){
		array_push(perm,i);	
	}
	perm = array_shuffle(perm);
	if(is_seen == false){
		if(!place_meeting(self.x - sign(obj_player.x_move_dir), self.y, obj_player) and !place_meeting(self.x, self.y - sign(obj_player.y_move_dir) - 1, obj_player)){ // check if player is touching object
			for(var i = 0; i < array_length(spawns); i++){ 
				var spawn_x = spawns[perm[i]][0];
				var spawn_y = spawns[perm[i]][1];
				var player_collide = collision_rectangle(spawn_x, spawn_y, spawn_x + self.sprite_width, spawn_y + self.sprite_height, obj_player, false, false);
				var solid_collide = collision_rectangle(spawn_x, spawn_y, spawn_x + self.sprite_width, spawn_y + self.sprite_height, obj_solid_parent, false, false);
				if(player_collide == noone and solid_collide == noone and viable_spawns[perm[i]] == 1){
					self.x = spawn_x;
					self.y = spawn_y;
					break;
				}
			}				
		}
		// check if collide

	}
}