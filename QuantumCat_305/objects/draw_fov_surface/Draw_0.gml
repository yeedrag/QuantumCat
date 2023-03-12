/// @description Insert description here
// You can write your code in this editor
/*
fovsurface = -1;
start_point_x = obj_camera.cx;
start_point_y = obj_camera.cy;
if( !surface_exists(fovsurface) ){
    fovsurface = surface_create(window_get_width(),window_get_height());
}
draw_surface(fovsurface, start_point_x, start_point_y)
surface_set_target(fovsurface);
draw_set_alpha(0.85);
draw_set_color(c_black);
gpu_set_blendmode(bm_normal);
draw_rectangle(start_point_x,start_point_y,start_point_x+obj_camera.c_width,start_point_y+obj_camera.c_height,false);

