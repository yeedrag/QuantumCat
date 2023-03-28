/// @description Insert description here
// You can write your code in this editor
event_inherited()
vertices_pos = [[-1, -1],[31, -1],[31, 31],[-1, 31]];
vertices_pos = v_transform(vertices_pos);
spawns = [[384,736],[352,512]];
viable_spawns = [1,1];
bounds = load_quantum_bounds(spawns);