/// b_on_server_recieve_disconnect(server_obj, disconnecting_sock_id)

var server_obj = argument0;
var disconnecting_sock_id = argument1;

ds_map_delete(server_obj.clients_map, disconnecting_sock_id);
