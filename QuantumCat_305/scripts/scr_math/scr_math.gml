// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cord_rotate(pt_x, pt_y, theta){
	// rotate clockwise!
	var ret;
	ret[0] = pt_x * cos(theta) - pt_y * sin(theta);
	ret[1] = pt_x * sin(theta) + pt_y * cos(theta);
	return ret;
}