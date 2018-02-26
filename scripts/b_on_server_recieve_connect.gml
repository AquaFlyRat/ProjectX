/// b_on_server_recieve_connect(server_obj, connecting_sock_id)

var server_obj         = argument0;
var connecting_sock_id = argument1;

var our_id = server_obj._impl_id_counter;

ds_map_add(clients_map, connecting_sock_id, our_id);

server_obj._impl_id_counter += 1;
