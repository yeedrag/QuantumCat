// v2.3.0的脚本资产已更改，请参见\ n // https://help.yoyogames.com/hc/en-us/articles/360005277377
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