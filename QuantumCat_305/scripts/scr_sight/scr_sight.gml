function collision_line_point(start_x, start_y, end_x, end_y, object, prec, notme){
	/*
		Calculates the point that the line collides with the object.
		Params:
			start_x : starting x of the line.
			start_y : staring y of the line.
			end_x   : ending x of the line.
			end_y   : ending y of the line.
			object  : the object that the line wants to check collision.
			prec    : whether to use precise collision or not.
			notme  : whether the calling instance should be excluded or not.
		Returns:
			An array with length 3, the instance ID, the x cord for 
			the collide point and the y cord for the collide point. Note 
			that if there are no collision, x and y would be set as end_x, 
			end_y, and the object ID would be noone.
	*/
	var collide_object = collision_line(start_x, start_y, end_x, end_y, object, prec, notme);
	var line_length = point_distance(start_x, start_y, end_x, end_y);
	
	var collide_x = end_x;
	var collide_y = end_y;
	
	if(collide_object != noone){
		var p0 = 0;
		var p1 = 1;
		repeat(ceil(log2(line_length)) + 1){
			var mag = p0 + (p1 - p0) * 0.5;
			var fx = start_x + (end_x - start_x) * mag; // far x
			var fy = start_y + (end_y - start_y) * mag; // far y
			var cx = start_x + (end_x - start_x) * p0; // close x
			var cy = start_y + (end_y - start_y) * p0; // close y 
			var check_collide = collision_line(cx, cy, fx, fy, object, prec, notme)
			if(check_collide != noone){
				collide_object = check_collide;
				collide_x = fx;
				collide_y = fy;
				p1 = mag;
			} else {
				p0 = mag;	
			}
		}
	}
	
	var ret;
	ret[0] = collide_object;
	ret[1] = collide_x;
	ret[2] = collide_y;
	
	return ret;
}

/*
	about facing_x and facing_y:
	x: right is 1, left is -1;
	y: down is 1, up is -1;
	makes making vector easier!
*/

function vec_coord(ppt_x, ppt_y, instance = NaN) constructor{
    _x = ppt_x;
    _y = ppt_y;
	_id = instance; // to keep track of object because of sorting 
}

function get_vertices(obj) {
	sprite = obj.sprite_index
	vertices = []
	
}

function draw_sight_v2(instance, view_distance, view_angle, start_x, start_y, facing_vector_x, facing_vector_y){
	
	var face_vec = new vec_coord(facing_vector_x, facing_vector_y); // 也許可以改成輸入時就是vec_coord 
	
	var bound_vec_a_x = cord_rotate(face_vec._x, face_vec._y, view_angle / 2)[0];
	var bound_vec_a_y = cord_rotate(face_vec._x, face_vec._y, view_angle / 2)[1];
	vec_a = new vec_coord(bound_vec_a_x, bound_vec_a_y);
	
	var bound_vec_b_x = cord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[0];
	var bound_vec_b_y = cord_rotate(face_vec._x, face_vec._y, -view_angle / 2)[1]; // is vector!
	vec_b = new vec_coord(bound_vec_b_x, bound_vec_b_y);
	
	
	draw_set_color(c_red);
	draw_line(start_x, start_y, start_x + 30 * vec_a._x, start_y + 30 * vec_a._y);
	draw_line(start_x, start_y, start_x + 30 *  vec_b._x, start_y + 30 * vec_b._x);
	draw_line(start_x, start_y, start_x + (30 * facing_vector_x), start_y + (30 * facing_vector_y));
	draw_set_color(c_white);
	
	
	pt_vec_candidates = []; // array to put in point candidates to sort later, is vector though!
	
	lines_to_check = [];
	
	for(var i = 0; i < instance_number(obj_solid_parent); i++){ // finding candidates
		
		obj = instance_find(obj_solid_parent, i);
		if(obj.sprite_index == Sprite11) {
			//show_debug_message(obj.image_angle);
			for(var j = 0; j < array_length(obj.vertices_pos); j++) {
				draw_line(start_x,start_y, obj.x+obj.vertices_pos[j][0], obj.y+obj.vertices_pos[j][1])
			}
		}
		
			
		all_bbox_pair[0][0] = obj.bbox_left; all_bbox_pair[0][1] = obj.bbox_right;
		all_bbox_pair[1][0] = obj.bbox_bottom; all_bbox_pair[1][1] = obj.bbox_top;
		
		for(var j = 0; j <= 1; j++){
			for(var k = 0; k <= 1; k++){
				var line_angle = line_angle_diff(all_bbox_pair[0][j] - start_x, all_bbox_pair[1][k] - start_y, facing_vector_x, facing_vector_y);
				if(line_angle < view_angle / 2){
					// in sight;	
					//draw_line(start_x, start_y, all_bbox_pair[0][j], all_bbox_pair[1][k]);
					var pt = new vec_coord(all_bbox_pair[0][j] - start_x, all_bbox_pair[1][k] - start_y, obj);
					array_push(pt_vec_candidates, pt);
					var pt_r1 = new vec_coord(cord_rotate(pt._x, pt._y, 0.00001)[0], cord_rotate(pt._x, pt._y, 0.00001)[1]);
					var pt_r2 = new vec_coord(cord_rotate(pt._x, pt._y, -0.00001)[0], cord_rotate(pt._x, pt._y, -0.00001)[1]);
					array_push(pt_vec_candidates, pt_r1);
					array_push(pt_vec_candidates, pt_r2);
					delete pt;
					delete pt_r1;
					delete pt_r2;
				}
			}
		}	
	}
	
	array_push(pt_vec_candidates, vec_a);
	array_push(pt_vec_candidates, vec_b); // two sides
	// sort by angle
	array_sort(pt_vec_candidates, function(elm_1, elm_2){
		// sort angle from line a;
		return sign(line_angle_diff(vec_a._x, vec_a._y, elm_2._x, elm_2._y) - line_angle_diff(vec_a._x , vec_a._y, elm_1._x, elm_1._y));
	});
	
	//for(var i = 0; i < array_length(pt_vec_candidates); i++) draw_line(start_x, start_y, start_x + pt_vec_candidates[i]._x, start_y + pt_vec_candidates[i]._y);
	//for(var i = 0; i < array_length(pt_vec_candidates); i++) draw_text(start_x + pt_vec_candidates[i]._x, start_y + pt_vec_candidates[i]._y, i);
	//show_debug_message(array_length(pt_vec_candidates))
	
	delete pt_vec_candidates;
	delete vec_a;
	delete vec_b;
	
	
	
}