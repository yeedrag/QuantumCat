function draw_all_vertices(){
	for(var i = 0; i < instance_number(obj_vertex); i++){
		obj = instance_find(obj_vertex,i);
		obj.image_alpha = 1;
	}
}

function vec_coord(ppt_x, ppt_y, instance = NaN, origin_pt_x = NaN, origin_pt_y = NaN) constructor{
    _x = ppt_x;
    _y = ppt_y;
	_org_x = origin_pt_x; // for lines/rays
	_org_y = origin_pt_y;
	_id = instance; // to keep track of object because of sorting 
}
/*
	about facing_x and facing_y:
	x: right is 1, left is -1;
	y: down is 1, up is -1;
	makes making vector easier!
*/
function draw_sight_v2(instance, view_distance, view_angle, start_x, start_y, facing_vector_x, facing_vector_y){
	
	var face_vec = new vec_coord(facing_vector_x, facing_vector_y); // 也許可以改成輸入時就是vec_coord 
	
	var bound_vec_a_x = cord_rotate(face_vec._x, face_vec._y, view_angle / 2)[0];
	var bound_vec_a_y = cord_rotate(face_vec._x, face_vec._y, view_angle / 2)[1];
	vec_a = new vec_coord(bound_vec_a_x, bound_vec_a_y); // 下面那條
	
	var bound_vec_b_x = cord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[0];
	var bound_vec_b_y = cord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[1]; // is vector!
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
		for(var j = 0; j <num_vertices; j++){
			var line_angle = line_angle_diff(obj.vertices_pos[j][0] + obj.x - start_x, obj.vertices_pos[j][1] + obj.y - start_y, facing_vector_x, facing_vector_y);
			if(line_angle < view_angle / 2){
				// in sight;	
				//draw_line(start_x, start_y, all_bbox_pair[0][j], all_bbox_pair[1][k]);
				var pt = new vec_coord(obj.vertices_pos[j][0] + obj.x - start_x, obj.vertices_pos[j][1] + obj.y - start_y);
				array_push(pt_vec_candidates, pt);
				var pt_r1 = new vec_coord(cord_rotate(pt._x, pt._y, 0.0001)[0], cord_rotate(pt._x, pt._y, 0.0001)[1]);
				var pt_r2 = new vec_coord(cord_rotate(pt._x, pt._y, -0.0001)[0], cord_rotate(pt._x, pt._y, -0.0001)[1]);
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
	
	pre_inter_x = -9999999;
	pre_inter_y = -9999999;
	
	for(var i = 0; i < cand_length; i++){
		var inter_ret = get_closest_intersection(start_x, start_y, pt_vec_candidates[i], lines_to_check);
		var inter_obj = inter_ret[0];
		if(inter_ret[1] >= 1000000) {
			continue;
		}
		if(inter_obj != NaN){
			inter_obj.is_seen = true;	
		}
		//draw_line(start_x, start_y, inter_ret[1], inter_ret[2]);	
		//draw_text(inter_ret[1], inter_ret[2], i+1);
		//draw_circle(inter_ret[1], inter_ret[2], 1, false);
		if(i >= 1 and pre_inter_x != -9999999) {
			draw_set_color(c_white)
			draw_set_alpha(0.5);
			draw_triangle(start_x, start_y, pre_inter_x, pre_inter_y, inter_ret[1], inter_ret[2], false);
		}
		pre_inter_x = inter_ret[1];
		pre_inter_y = inter_ret[2];	
	}
	draw_set_alpha(1);
	//gpu_set_blendenable(bm_normal);
	//surface_reset_target();

	//for(var i = 0; i < array_length(pt_vec_candidates); i++) draw_line(start_x, start_y, start_x + pt_vec_candidates[i]._x, start_y + pt_vec_candidates[i]._y);
	//for(var i = 0; i < array_length(pt_vec_candidates); i++) draw_text(start_x + pt_vec_candidates[i]._x, start_y + pt_vec_candidates[i]._y, i);
	//show_debug_message(array_length(pt_vec_candidates))
	delete pt_vec_candidates;
	delete vec_a;
	delete vec_b;
	delete lines_to_check;
}