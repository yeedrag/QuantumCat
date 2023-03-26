/// @description Insert description here
// You can write your code in this editor
if(visible == true) {
	if(!surface_exists(transition_surface)){
		transition_surface = surface_create(window_get_width(), window_get_height());
	} 
	surface_set_target(transition_surface);
	gpu_set_blendmode(bm_normal);
	//instance_create_layer(obj_camera.cx,obj_camera.cy,transition_surface,obj_transition);
	draw_self();
	surface_reset_target();
	draw_surface(transition_surface, obj_camera.cx, obj_camera.cy);
}