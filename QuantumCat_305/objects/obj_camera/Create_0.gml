c_width = 480;
c_height = 270;

// create camera obj
var myCam = camera_create_view(0, 0, 0, 0);
view_visible[0] = 1;
view_enabled[0] = true;
view_set_camera(0, myCam);

// camera setting
camera_set_view_size(myCam, c_width, c_height);
//camera_set_view_target(myCam, obj_view);
//camera_set_view_speed(myCam, 5, 5);
//camera_set_view_border(myCam, c_width/2, c_height/2);


view_xport[0] = 0;
view_yport[0] = 0;
//view_wport[0] = 480;
//view_hport[0] = 270;
min_view_x = 0;
min_view_y = 735;
max_view_x = 639-c_width;
max_view_y = 1087-c_height;