#define create_client
var ip = argument0;
var port = argument1;

var client = instance_create(0, 0, obj_client);

var client_socket = network_create_socket(network_socket_tcp);
var server = network_connect_raw(client_socket, ip, port);

if(server < 0) 
    show_error("Could not connect to server!", true);

client.socket_id = client_socket;


#define client_recieve_data
var buffer = ds_map_find_value(async_load, "buffer");

while(true) {
    var msg_id = buffer_read(buffer, buffer_u8);
    switch(msg_id) {
    case netc_move:
        var client_id_ = buffer_read(buffer, buffer_u16);
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        
        if(ds_map_exists(client_map, string(client_id_))) {
            var found_client = client_map[? string(client_id_)];
            /*found_client.x = xx;
            found_client.y = yy;*/
            found_client.next_x = xx;
            found_client.next_y = yy;
            found_client.prev_x = found_client.x;
            found_client.prev_y = found_client.y;
            found_client.time = 0;
        } else {
            var c = instance_create(xx, yy, obj_netplayer);
            client_map[? string(client_id_)] = c;
        }
        
        break;
    }
    
    if(buffer_tell(buffer) == buffer_get_size(buffer)) {
        break;
    }
}

#define client_send_move_data
buffer_seek(send_buffer, buffer_seek_start, 0);
buffer_write(send_buffer, buffer_u8, netc_move);
buffer_write(send_buffer, buffer_u16, round(obj_player.x));
buffer_write(send_buffer, buffer_u16, round(obj_player.y));

network_send_raw(socket_id, send_buffer, buffer_tell(send_buffer));