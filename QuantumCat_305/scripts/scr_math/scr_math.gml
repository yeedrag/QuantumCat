// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cord_rotate(pt_x, pt_y, theta){
	// rotate clockwise!
	var ret;
	ret[0] = pt_x * cos(theta) - pt_y * sin(theta);
	ret[1] = pt_x * sin(theta) + pt_y * cos(theta);
	return ret;
}

function line_angle_diff(x1, y1, x2, y2){ // input must be vectors!
	var dr_prt = dot_product(x1, y1, x2, y2);
	var len1 = sqrt(sqr(x1) + sqr(y1));
	var len2 = sqrt(sqr(x2) + sqr(y2));
	if(len1*len2==0){
		show_debug_message("divide by zero TAT");
	}
	return arccos(dr_prt / ((len1 * len2) + 0.0001));
}