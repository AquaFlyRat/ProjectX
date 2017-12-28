var dir = argument0;
var spd = argument1;
var client_id = argument2;
var xx = argument3;
var yy = argument4;

var inst = instance_create(xx, yy, obj_serverBullet);

inst.spd = spd;
inst.dir = dir;
inst.parent_client_id = client_id;
inst.alarm[0] = update_spd;

return inst;
