/// @description camera moving system
// You can write your code in this editor
half_width = camera_get_view_width(view_camera[0]) / 2;
half_height = camera_get_view_width(view_camera[0]) / 2;
cx = x - half_width
cy = y - half_height

// You have to dicide the boundary of the camera by the following parameters
min_view_x = 0
min_view_y = 0
max_view_x = room_width - camera_get_view_width(view_camera[0])
max_view_y = room_height - camera_get_view_height(view_camera[0])


cx = clamp(cx, min_view_x , max_view_x)
cy = clamp(cy, min_view_y , max_view_y)

camera_set_view_pos(view_camera[0], cx, cy)
