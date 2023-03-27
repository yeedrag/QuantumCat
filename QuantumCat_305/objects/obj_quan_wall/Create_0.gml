/// @description Insert description here
// You can write your code in this editor
event_inherited()
vertices_pos = [[-1, -1],[31, -1],[31, 31],[31, 191],[31, 223],[-1, 223],[-1, 191],[-1, 31]];
vertices_pos = v_transform(vertices_pos);
spawns = [[128, 544],[160,544],[192,544],[224, 544],[256, 544],[288,544],[320, 544]];
viable_spawns = [1,1,1,1,1,1,1];
bounds = load_quantum_bounds(spawns);