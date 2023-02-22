global.c_width = 480;
global.c_height = 270;

// create camera obj
view_camera[0] = camera_create_view(0, 0, 0, 0);
view_visible[0] = 1;
view_enabled[0] = true;
view_set_camera(0, view_camera[0]);

// camera setting
camera_set_view_size(view_camera[0], global.c_width, global.c_height);
//camera_set_view_target(view_camera[0], obj_player);
//camera_set_view_speed(view_camera[0], -1, -1);
//camera_set_view_border(view_camera[0], c_width/2, c_height/2);


view_xport[0] = 0;
view_yport[0] = 0;
//view_wport[0] = 480;
//view_hport[0] = 270;
