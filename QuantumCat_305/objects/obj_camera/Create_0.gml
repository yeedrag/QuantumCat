c_width = 480;
c_height = 270;

cx = -1;
cy = -1;

// create camera obj
var myCam = camera_create_view(0, 0, 0, 0);
view_visible[0] = 1;
view_enabled[0] = true;
view_set_camera(0, myCam);

// camera setting
camera_set_view_size(myCam, c_width, c_height);
//camera_set_view_target(myCam, obj_view);
//camera_set_view_speed(myCam, 5, 5);
//camera_set_view_border(myCam, c_width/2, c_height/2);


view_xport[0] = 0;
view_yport[0] = 0;
//view_wport[0] = 480;
//view_hport[0] = 270;

min_view_x = 99999
min_view_y = 99999
max_view_x = -99999
max_view_y = -99999

update_room_bound = function(){
	
		//Changes room view bound according to the min, max x and y from the outer vertices.
	
	for(var i = 0; i < instance_number(obj_vertex); i++){	
		var vertex = instance_find(obj_vertex, i);
		// this will show eleven vertexes but the twelfth go wrong
		show_debug_message([vertex.vertices_pos[0][0]+ vertex.x,vertex.vertices_pos[0][1]+ vertex.y,vertex.vertices_pos[1][0]+ vertex.x, vertex.vertices_pos[1][1]+ vertex.y])
		min_view_x = min(min_view_x, min(vertex.vertices_pos[0][0] + vertex.x, vertex.vertices_pos[1][0] + vertex.x) - 31);
		min_view_y = min(min_view_y, min(vertex.vertices_pos[0][1] + vertex.y, vertex.vertices_pos[1][1] + vertex.y) - 31);
		max_view_x = max(max_view_x, max(vertex.vertices_pos[0][0] + vertex.x, vertex.vertices_pos[1][0] + vertex.x) + 31);
		max_view_y = max(max_view_y, max(vertex.vertices_pos[0][1] + vertex.y, vertex.vertices_pos[1][1] + vertex.y) + 31);
	}
	max_view_x -= c_width;
	max_view_y -= c_height; 
}
update_room_bound(); 

draw_all_vertices();