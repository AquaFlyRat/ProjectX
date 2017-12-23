#define create_server
var server = network_create_server(network_socket_tcp, std_port, max_clients);

var server_controller = instance_create(0, 0, obj_server);
server_controller.socket_id = server;

create_client("127.0.0.1", std_port);

return server_controller;

#define on_client_connect
// Called from obj_server

var sock = ds_map_find_value(async_load, "socket");  
var client = instance_create(0, 0, obj_serverClient);
client.socket_id = sock;
client.client_id = connected_count++;

ds_list_add(clients_list, client);    


#define on_client_disconnect
var sock = ds_map_find_value(async_load, "socket");

for(var i = 0; i < ds_list_size(clients_list); i++) {
    var client = ds_list_find_value(clients_list, i);
    if(not is_undefined(client)) {
        if(client.socket_id == sock) {
            ds_list_delete(clients_list, i);
            break;
        }
    }
}

