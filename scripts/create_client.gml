var connect_to_ip = "127.0.0.1";

var client_socket = network_create_socket(network_socket_tcp);
var server = network_connect(client_socket , connect_to_ip, std_port);

var client_controller = instance_create(0, 0, obj_client);

client_controller.client_socket_id = client_socket;

return client_controller;
