var client_socket    = network_create_socket(network_socket_tcp);

var client_obj       = instance_create(obj_b_client, 0, 0);

client_obj.socket_id = client_socket;

return client_obj;

