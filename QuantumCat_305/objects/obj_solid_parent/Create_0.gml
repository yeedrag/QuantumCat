/// @description Insert description here
// You can write your code in this editor

is_seen = false; // check whether seen by player

vertices_pos = [];

v_transform = function(vertices_pos) {
	num_vertices  = array_length(vertices_pos);
	for (var i = 0; i < num_vertices; i++) {
		var pt = cord_rotate((vertices_pos[i][0] + 1) * image_xscale, (vertices_pos[i][1] + 1)  * image_yscale, degtorad(-image_angle));
		pt[0] -= 1;
		pt[1] -= 1;
		vertices_pos[i][0] = pt[0]; 
		vertices_pos[i][1] = pt[1]; 
	}
	
	return vertices_pos;
}