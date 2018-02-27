/// b_send_player_move_data_to_server(player_x, player_y, client_obj)

var player_x = argument0;
var player_y = argument1;
var client_obj = argument2;

buffer_seek(client_obj.send_buffer, buffer_seek_start, 0);

buffer_write(client_obj.send_buffer, buffer_u8, netc_move);
buffer_write(client_obj.send_buffer, buffer_u16, round(player_x));
buffer_write(client_obj.send_buffer, buffer_u16, round(player_y));

var size = buffer_tell(client_obj.send_buffer);

network_send_raw(client_obj.socket_id, client_obj.send_buffer, size);
