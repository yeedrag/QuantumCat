// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function coord_rotate(pt_x, pt_y, theta){
	/*
		Rotates coordinate by theta radians clockwise.
		Params:
			pt_x : X value of the coordinate.
			pt_y : Y value of the coordinate.
			theta : Radian to rotate the coordinate.
		Returns:
			ret : An array of size 2 as [x',y'].
	*/
	var ret;
	ret[0] = pt_x * cos(theta) - pt_y * sin(theta);
	ret[1] = pt_x * sin(theta) + pt_y * cos(theta);
	return ret;
}

function line_angle_diff(x1, y1, x2, y2){ // input must be vectors!
	/*
		Computes the angle difference between two vectors.
		Params:
			x1 : X vector of vector 1.
			y1 : Y vector of vector 1.
			x2 : X vector of vector 2.
			y2 : Y vector of vector 2.
		Returns:
			The angle difference between the two vectors [x1,y1],[x2,y2],
			is in radian!
			*/
	var dr_prt = dot_product(x1, y1, x2, y2);
	var len1 = sqrt(sqr(x1) + sqr(y1));
	var len2 = sqrt(sqr(x2) + sqr(y2));
	if(len1*len2==0){
		show_debug_message("divide by zero TAT");
	}
	return arccos(dr_prt / ((len1 * len2) + 0.0001));
}

/*
function vec_coord(ppt_x, ppt_y, instance = NaN, origin_pt_x, origin_pt_y) constructor{
    _x = ppt_x;
    _y = ppt_y;
	_org_x = origin_pt_x; // for lines/rays
	_org_y = origin_pt_y;
	_id = instance; // to keep track of object because of sorting 
}
*/
function get_closest_intersection(start_x, start_y, ray, seg_candidates, close_dis_x = 99999999, close_dis_y = 99999999, close_seg = noone){
	var closest_seg = close_seg;
	var closest_dis_x = close_dis_x;
	var closest_dis_y = close_dis_y;
	for(var i = 0; i < array_length(seg_candidates); i++){
		var seg = seg_candidates[i];	
		if(ray._y * seg._x - ray._x * seg._y == 0) continue; // parallel
		var r = (ray._x * (seg._org_y - start_y) + ray._y * (start_x - seg._org_x)) / (ray._y * seg._x - ray._x * seg._y); // I fucking hate math 
		if(r < 0 or r > 1) continue; // intersect must be 0 <= r <= 1 !!!
		var t = (seg._x * (start_y - seg._org_y) + seg._y * (seg._org_x - start_x)) / (seg._y * ray._x - seg._x * ray._y);
		if(t < 0) continue;
		var pt_x = start_x + ray._x * t;
		var pt_y = start_y + ray._y * t; // intersection point;
		var dis = point_distance(start_x, start_y, pt_x, pt_y);
		if(dis <= point_distance(start_x, start_y, closest_dis_x, closest_dis_y)){
			closest_seg = seg._id; // to check if is seen
			closest_dis_x = pt_x;
			closest_dis_y = pt_y;
		}
	}
	var ret;
	ret[0] = closest_seg;
	ret[1] = closest_dis_x;
	ret[2] = closest_dis_y;
	return ret;
	
}

function array_shuffle(_array) {
	/*
		Random shuffles an array.
		Params:
			_array : the array to be shuffled with.
		Returns:
			_array : the shuffled array.
	*/
	var _len = array_length(_array), _last = 0, _i = 0;
	while(_len) {
		_i = irandom(--_len);
		_last = _array[_len];
		_array[_len] = _array[_i];
		_array[_i] = _last;
	}
	return _array;
}