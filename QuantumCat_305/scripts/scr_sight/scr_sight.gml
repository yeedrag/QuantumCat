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
function draw_sight_v2(view_distance, view_angle, start_x, start_y, facing_vector_x, facing_vector_y){
	
	var bound_vec_a_x = cord_rotate(facing_vector_x, facing_vector_y, view_angle / 2)[0];
	var bound_vec_a_y = cord_rotate(facing_vector_x, facing_vector_y, view_angle / 2)[1];
	var bound_vec_b_x = cord_rotate(facing_vector_x, facing_vector_y, -view_angle / 2)[0];
	var bound_vec_b_y = cord_rotate(facing_vector_x, facing_vector_y, -view_angle / 2)[1]; // is vector!
	
	draw_set_color(c_red);
	draw_line(start_x, start_y, start_x + 30 * (bound_vec_a_x), start_y + 30 * (bound_vec_a_y));
	draw_line(start_x, start_y, start_x + 30 * (bound_vec_b_x), start_y + 30 * (bound_vec_b_y));
	draw_line(start_x, start_y, start_x + (30 * facing_vector_x), start_y + (30 * facing_vector_y));
	draw_set_color(c_white);
	
	for(var i = 0; i < instance_number(obj_solid_parent); i++){
		obj = instance_find(obj_solid_parent, i);
		obj.is_seen = false;
		all_bbox_pair[0][0] = obj.bbox_left; all_bbox_pair[0][1] = obj.bbox_right;
		all_bbox_pair[1][0] = obj.bbox_bottom; all_bbox_pair[1][1] = obj.bbox_top;
		for(var j = 0; j <= 1; j++){
			for(var k = 0; k <= 1; k++){
				var line_angle = line_angle_diff(all_bbox_pair[0][j] - start_x, all_bbox_pair[1][k] - start_y, facing_vector_x, facing_vector_y);
				if(line_angle < view_angle / 2){
					// in sight;	
					draw_line(start_x, start_y, all_bbox_pair[0][j], all_bbox_pair[1][k]);
					
				}
			}
		}
	}
	
}