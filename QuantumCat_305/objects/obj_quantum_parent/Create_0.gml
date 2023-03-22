/// @description Insert description here
// You can write your code in this editor

/* TODO:
	Write general code for quantum objects, and simply inherit
	this object when making a quantum object!
*/
event_inherited()

warp_time = 5; // How many ticks until warp event happens
alarm[0] = warp_time; 

spawns = []; // Possible spawns for the object to warp to. Each spawn should be [x,y].

viable_spawns = []; // Show whether a spawn is seen or not this frame. a[i] = 1 means that spawn i is viable, and 0 means that is is not viable.

bounds = []; // The bounds of the object made from all the vertices and spawns, should be loaded with load_quantum_bounds.

load_quantum_bounds = function(spawns){
	/*
		Loads all the bounding boxes from every possible spawn.
		Params : 
			spawns : the spawns array the belongs to the object.
		Returns :
			An array consisting of all the bounding lines.
			Type is vec_coord: [x_length relative to origin_point_x, y_length relative to origin_point_y, object_id, origin_point_x, origin_point_y].
	
	*/
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
	/*
		Warps object to one of the viable spawns if object is not being seen and is ready to warp.
		
		Chooses a spawn that the object will not be seen when teleported to, won't collide with player and other objects when warp to, 
		and is currently not in contact with the player.	
	*/
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
				if(player_collide == noone and viable_spawns[perm[i]] == 1){
					self.x = spawn_x;
					self.y = spawn_y;
					break;
				}
			}				
		}
	}
}