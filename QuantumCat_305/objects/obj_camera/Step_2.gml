/// @description Insert description here
// You can write your code in this editor
half_width = camera_get_view_width(view_camera[0]) / 2;
half_height = camera_get_view_height(view_camera[0]) / 2;
cx = obj_player.x - half_width;
cy = obj_player.y - half_height;

// You have to dicide the boundary of the camera by the following parameters

cx = clamp(cx, min_view_x , max_view_x);
cy = clamp(cy, min_view_y , max_view_y);
//show_debug_message([cx,cy]);

left_bound = cx
right_bound = cx + half_width*2
top_bound = cy 
bottom_bound = cy + half_height*2
//show_debug_message([left_bound,right_bound,top_bound,bottom_bound]);


camera_set_view_pos(view_camera[0], cx, cy);