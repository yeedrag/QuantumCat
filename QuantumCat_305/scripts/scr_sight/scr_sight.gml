function draw_all_vertices(){
	for(var i = 0; i < instance_number(obj_vertex); i++){
		obj = instance_find(obj_vertex,i);
		obj.image_alpha = 1;
	}
}

function vec_coord(ppt_x, ppt_y, instance = noone, origin_pt_x = NaN, origin_pt_y = NaN) constructor{
    _x = ppt_x;
    _y = ppt_y;
	_id = instance; // to keep track of object because of sorting 
	_org_x = origin_pt_x; // for lines/rays
	_org_y = origin_pt_y;
}
/*
	about facing_x and facing_y:
	x: right is 1, left is -1;
	y: down is 1, up is -1;
	makes making vector easier!
*/

function get_sight_polygon(instance, view_distance, view_angle, start_x, start_y, facing_vector_x, facing_vector_y){
	
	var face_vec = new vec_coord(facing_vector_x, facing_vector_y, noone, start_x, start_y); // 也許可以改成輸入時就是vec_coord 
	
	var bound_vec_a_x = coord_rotate(face_vec._x, face_vec._y, view_angle / 2)[0];
	var bound_vec_a_y = coord_rotate(face_vec._x, face_vec._y, view_angle / 2)[1];
	vec_a = new vec_coord(bound_vec_a_x, bound_vec_a_y); // 下面那條
	
	var bound_vec_b_x = coord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[0];
	var bound_vec_b_y = coord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[1]; // is vector!
	vec_b = new vec_coord(bound_vec_b_x, bound_vec_b_y); // 上面那條
	pt_vec_candidates = []; // array to put in point candidates to sort later, is vector though!
	
	lines_to_check = [];

	for(var i = 0; i < instance_number(obj_solid_parent); i++){ // finding candidates
	
		obj = instance_find(obj_solid_parent, i);
		
		obj.is_seen = false;
		
		var num_vertices = obj.num_vertices;
		// ------------------------------------------------------------------------------------------ putting every line in lines_to_check
		for(var j = 1; j < num_vertices; j++){
			var line = new vec_coord(obj.vertices_pos[j-1][0] - obj.vertices_pos[j][0], obj.vertices_pos[j-1][1] - obj.vertices_pos[j][1], obj, obj.vertices_pos[j][0] + obj.x, obj.vertices_pos[j][1] + obj.y); 
			array_push(lines_to_check,line);
			delete line;
		}
		if(num_vertices > 2){
			var line = new vec_coord(obj.vertices_pos[obj.num_vertices - 1][0] - obj.vertices_pos[0][0], obj.vertices_pos[obj.num_vertices - 1][1] - obj.vertices_pos[0][1], obj, obj.vertices_pos[0][0] + obj.x, obj.vertices_pos[0][1] + obj.y) 
			array_push(lines_to_check, line);
			delete line;	
		}
		
		// -------------------------------------------------------------------------------------------
		
		//-------------------------------------------------------------------------------------------- find ray candidates	
		for(var j = 0; j < num_vertices; j++){
			var line_angle = line_angle_diff(obj.vertices_pos[j][0] + obj.x - start_x, obj.vertices_pos[j][1] + obj.y - start_y, facing_vector_x, facing_vector_y);
			if(line_angle < view_angle / 2){
				// in sight;	
				var pt = new vec_coord(obj.vertices_pos[j][0] + obj.x - start_x, obj.vertices_pos[j][1] + obj.y - start_y);
				array_push(pt_vec_candidates, pt);
				var pt_r1 = new vec_coord(coord_rotate(pt._x, pt._y, 0.0001)[0], coord_rotate(pt._x, pt._y, 0.0001)[1]);
				var pt_r2 = new vec_coord(coord_rotate(pt._x, pt._y, -0.0001)[0], coord_rotate(pt._x, pt._y, -0.0001)[1]);
				array_push(pt_vec_candidates, pt_r1);
				array_push(pt_vec_candidates, pt_r2);
				delete pt;
				delete pt_r1;
				delete pt_r2;		
			}
		}
	}
	array_push(pt_vec_candidates, vec_a); 
	// ------------------------------------------------------------------------------------------------- sort angle;
	array_sort(pt_vec_candidates, function(elm_1, elm_2){
		// sort angle from line b;
		return sign(line_angle_diff(vec_b._x, vec_b._y, elm_2._x, elm_2._y) - line_angle_diff(vec_b._x , vec_b._y, elm_1._x, elm_1._y));
	});
	
	array_push(pt_vec_candidates, vec_b); // two sides
	
	var cand_length = array_length(pt_vec_candidates);

	var ret = [];
	
	
	for(var i = 0; i < cand_length; i++){
		var inter_ret = get_closest_intersection(start_x, start_y, pt_vec_candidates[i], lines_to_check);
        if(inter_ret[1] >= 1000000) {
            continue;
        }
        if(inter_ret[0] != noone){
            inter_ret[0].is_seen = true;
        }
		array_push(ret, inter_ret);
	}
	
	
	// deal with quantum tp candidates
	
	for(var i = 0; i < instance_number(obj_quantum_parent); i++){ 
		obj = instance_find(obj_quantum_parent, i);	
		for(var sp = 0; sp < array_length(obj.spawns); sp++){
			var flag0 = false;
			var flag1 = false;
			var num_vertices = obj.num_vertices;
			for(var j = 0; j < num_vertices; j++){
				var abs_pos_x = obj.vertices_pos[j][0] + obj.spawns[sp][0];
				var abs_pos_y = obj.vertices_pos[j][1] + obj.spawns[sp][1]
				var line_angle = line_angle_diff(abs_pos_x - start_x, abs_pos_y - start_y, facing_vector_x, facing_vector_y);
				if(line_angle < view_angle / 2){
					// in sight;	
					var pt = new vec_coord(abs_pos_x - start_x, abs_pos_y - start_y);
					var inter_ret = get_closest_intersection(start_x, start_y, pt, lines_to_check, abs_pos_x, abs_pos_y, obj);
					if(inter_ret[0] == obj){ // the rays closest is itself
						// this spawn is not valid;
						flag0 = 1;
					} 
				}	
			}
			var qbounds = obj.bounds;
			for(var j = 0; j < cand_length; j++){ 
				var inter_ret = get_closest_intersection(start_x, start_y, pt_vec_candidates[j], qbounds[sp]);
		        if(inter_ret[1] >= 1000000) {
		            continue;
		        }
				if(point_distance(start_x, start_y, ret[j][1], ret[j][2]) > point_distance(start_x, start_y, inter_ret[1], inter_ret[2])){
					// this spawn is not valid;	
					flag1 = 1;
				}
			}	
			if(flag0 == 0 and flag1 == 0){
				// valid spawn;	
				obj.viable_spawns[sp] = 1;
			} else {
				// invalid spawn;	
				obj.viable_spawns[sp] = 0;
			}
		}
	}
	
	delete pt_vec_candidates;
	delete vec_a;
	delete obj;
	delete lines_to_check;
	return ret;
}

function draw_sight(start_x, start_y, sight_polygons){
	pre_inter_x = -99999999;
	pre_inter_y = -99999999;
	surf_x = obj_camera.cx;
	surf_y = obj_camera.cy;
	if(!surface_exists(global.fovsurface)){
		global.fovsurface = surface_create(window_get_width(), window_get_height());
	} 
	surface_set_target(global.fovsurface);
	draw_set_alpha(0.65);
	draw_set_color(c_black);
	draw_rectangle(0,0,obj_camera.c_width,obj_camera.c_height,false);

	for(var i = 0; i < array_length(sight_polygons); i++){
        if(i >= 1 and pre_inter_x != -9999999) {
			gpu_set_blendmode(bm_subtract);
			//gpu_set_blendmode_ext()
			draw_set_alpha(1);
			//draw_set_color(make_color_rgb(255,255,255));
			draw_circle(obj_player.x - surf_x, obj_player.y - surf_y-16,15,false);
			draw_triangle(start_x-surf_x, start_y-surf_y, pre_inter_x-surf_x, pre_inter_y-surf_y, sight_polygons[i][1]-surf_x, sight_polygons[i][2]-surf_y, false);	
			draw_set_alpha(0.75);
			draw_circle(obj_player.x - surf_x, obj_player.y - surf_y-16,20,false);	
			draw_set_alpha(1);
        }			
        pre_inter_x = sight_polygons[i][1];
        pre_inter_y = sight_polygons[i][2];    		
	}
	gpu_set_blendmode(bm_normal);
	draw_self();
	surface_reset_target();
	draw_surface(global.fovsurface,surf_x,surf_y);
}

function get_shadow_polygon(view_angle, start_x, start_y, facing_vector_x, facing_vector_y){
	var face_vec = new vec_coord(facing_vector_x, facing_vector_y, noone, start_x, start_y);
	var bound_vec_a_x = coord_rotate(face_vec._x, face_vec._y, view_angle / 2)[0];
	var bound_vec_a_y = coord_rotate(face_vec._x, face_vec._y, view_angle / 2)[1];
	vec_a = new vec_coord(bound_vec_a_x, bound_vec_a_y);
	
	var bound_vec_b_x = coord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[0];
	var bound_vec_b_y = coord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[1];
	vec_b = new vec_coord(bound_vec_b_x, bound_vec_b_y);
	
	// 1. shadow out area out of sight cone

	camera_vertex = [[vec_a._x + start_x, vec_a._y + start_y], [vec_b._x + start_x, vec_b._y + start_y], [obj_camera.cx, obj_camera.cy], [obj_camera.cx + obj_camera.c_width, obj_camera.cy], [obj_camera.cx, obj_camera.cy + obj_camera.c_height], [obj_camera.cx + obj_camera.c_width, obj_camera.cy + obj_camera.c_height]];
	
	//show_debug_message(start_x)

	array_sort(camera_vertex, function(e1, e2){
		// sort angle from line b;
		elm_1 = [e1[0],e1[1]];
		elm_2 = [e2[0],e2[1]];
		var start_x = obj_player.eye_x, start_y = obj_player.eye_y;
		return point_direction(start_x, start_y, elm_1[0], elm_1[1]) > point_direction(start_x, start_y, elm_2[0], elm_2[1]);
	});
	camera_shadow_vertex = [];
	camera_idx = [];

	for(var i = 0; i < 6; i++){
		if(camera_vertex[i][0] == vec_b._x + start_x and camera_vertex[i][1] == vec_b._y + start_y){ // find vertex b;
			//show_debug_message([vec_b._x + start_x, vec_b._y + start_y]);
			//show_debug_message([vec_a._x + start_x, vec_a._y + start_y]);
			var idx = i;
			array_push(camera_shadow_vertex, camera_vertex[idx]);
			array_push(camera_idx,idx);
			idx = (idx+1) == 6 ? 0 : (idx+1);
			while(camera_vertex[idx][0] != vec_b._x + start_x or camera_vertex[idx][1] != vec_b._y + start_y){
				//show_debug_message(idx)
				array_push(camera_shadow_vertex, camera_vertex[idx]);
				array_push(camera_idx,idx);
				if(camera_vertex[idx][0] == vec_a._x + start_x and camera_vertex[idx][1] == vec_a._y + start_y){
					break;
				}
				idx = (idx+1) == 6 ? 0 : (idx+1);
			}
			break;
		}
	}
}

