/// @description Insert description here
// You can write your code in this editor
if(surface_exists(fovsurface)) {
	draw_surface(fovsurface,37,767);
}
surface_set_target(fovsurface);
draw_set_color(c_gray)
draw_set_alpha(0.8);
draw_rectangle(0,0,576,288,false);
//gpu_set_blendmode(bm_subtract);
surface_reset_target();
