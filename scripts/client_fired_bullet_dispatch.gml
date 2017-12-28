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
