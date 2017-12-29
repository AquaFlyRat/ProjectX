#define client_fired_bullet_dispatch
///client_fired_bullet_dispatch(x, y, dir, spd, id)
var xx = argument0;
var yy = argument1;
var dir = argument2;
var spd = argument3;
var _id = argument4;

buffer_seek(send_buffer, buffer_seek_start, 0);
buffer_write(send_buffer, buffer_u8, netc_bullet_fired);
buffer_write(send_buffer, buffer_u16, round(xx));
buffer_write(send_buffer, buffer_u16, round(yy));
buffer_write(send_buffer, buffer_u16, round(dir));
buffer_write(send_buffer, buffer_u16, round(spd));
buffer_write(send_buffer, buffer_u32, _id);

network_send_raw(socket_id, send_buffer, buffer_tell(send_buffer));

#define client_add_puddle
///client_add_puddle(x, y, object)
var xx = argument[0];
var yy = argument[1];
var obj = argument[2];
buffer_seek(send_buffer, buffer_seek_start, 0);
buffer_write(send_buffer, buffer_u8, netc_puddle);
buffer_write(send_buffer, buffer_u16, round(xx));
buffer_write(send_buffer, buffer_u16, round(yy));
buffer_write(send_buffer, buffer_u32, obj);
network_send_raw(socket_id, send_buffer, buffer_tell(send_buffer));

#define client_create_ammo
///client_create_ammo(x, y)
var xx = argument[0];
var yy = argument[1];
buffer_seek(send_buffer, buffer_seek_start, 0);
buffer_write(send_buffer, buffer_u8, netc_ammocreate);
buffer_write(send_buffer, buffer_u16, round(xx));
buffer_write(send_buffer, buffer_u16, round(yy));
network_send_raw(socket_id, send_buffer, buffer_tell(send_buffer));