/// Creates a server and returns a obj_b_server object with a handle to the socket (the sockets id).
var port            = argument0;
var maximum_clients = argument1;

var server_socket   = network_create_server_raw(network_socket_tcp, port, maximum_clients);

var server          = instance_create(0, 0, obj_b_server);
server.socket_id    = server_socket;

return server;

