var connect_to_ip = "127.0.0.1";

var client_socket = network_create_socket(network_socket_tcp);
var server = network_connect(client_socket , "127.0.0.1", std_port);

out[0] = client_socket;
out[1] = server;

return out;
