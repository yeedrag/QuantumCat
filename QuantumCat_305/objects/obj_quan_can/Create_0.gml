/// @description Insert description here
// You can write your code in this editor
event_inherited()
vertices_pos = [[-1, -1],[63, -1],[63, 63],[-1, 63]];
vertices_pos = v_transform(vertices_pos);
spawns = [[256, 576],[128, 480],[288, 480],[320, 384],[128, 384],[512, 512],[512, 672]];
viable_spawns = [1,1,1,1,1,1,1];
bounds = load_quantum_bounds(spawns);