#define create_server
var server = network_create_server_raw(network_socket_tcp, std_port, max_clients);

var server_controller = instance_create(0, 0, obj_server);
server_controller.socket_id = server;

create_client("127.0.0.1", std_port);

return server_controller;

#define server_recieve_data
var sock_id = ds_map_find_value(async_load, "id");
var buffer = ds_map_find_value(async_load, "buffer");

var curr_client_id = client_map[? string(sock_id)].client_id;

if(curr_client_id < 0) {
    show_error("Error recieving message!", true);
}

while(true) {
    var msg_id = buffer_read(buffer, buffer_u8);
    switch(msg_id) {
    case netc_move:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_move);
        buffer_write(send_buffer, buffer_u16, curr_client_id);
        buffer_write(send_buffer, buffer_u16, xx);
        buffer_write(send_buffer, buffer_u16, yy);
        
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, 7);
            }
        }
        
        break;
    }
    
    if(buffer_tell(buffer) == buffer_get_size(buffer)) {
        break;
    }
}

#define server_recieve_client_connect
// Called from obj_server

var sock = ds_map_find_value(async_load, "socket");  
var client = instance_create(0, 0, obj_serverClient);
client.socket_id = sock;
client.client_id = connected_count++;
client_map[? string(sock)] = client;


#define server_recieve_client_disconnect
var sock = ds_map_find_value(async_load, "socket");

with(client_map[? string(sock)]) {
    instance_destroy();
}

ds_map_delete(client_map, string(sock));

