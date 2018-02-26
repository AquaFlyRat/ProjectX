/// b_connect_client_to_server(ip, port, client_obj)
var ip         = argument0;
var port       = argument1;
var client_obj = argument2;

var client_sock = client_obj.socket_id;
var server_sock = network_connect_raw(client_sock, ip, port);

client_obj.server_socket_id = server_sock;
