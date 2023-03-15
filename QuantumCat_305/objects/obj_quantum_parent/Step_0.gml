/// @description Insert description here
// You can write your code in this editor
if(self.is_seen == false){
	self.image_alpha = 0;	
} else {
	self.image_alpha = 1;	
}
if(alarm[0] == -1){
	alarm[0] = warp_time;	
}