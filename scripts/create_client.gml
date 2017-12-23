var ip = argument0;
var port = argument1;

var connect_to_ip = "127.0.0.1";

var client_socket = network_create_socket(network_socket_tcp);
var server = network_connect(client_socket, ip, port);

