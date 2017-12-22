#define client_connect
///client_connect(ip, port)
var ip = argument[0];
var port = argument[1];
//socket
socket = network_create_socket(network_socket_tcp);
var connect = network_connect_raw(socket,ip,port);
//map of clients
send_buffer = buffer_create(256,buffer_fixed,1);
clientmap = ds_map_create();
//abort if error
if connect<0{
    show_error("could not connect",true);
}

#define client_disconnect
///client_disconnect()
ds_map_destroy(clientmap);
network_destroy(socket);

#define client_handle_message
///client_handle_message(buffer)
var buffer = argument[0];
//handle message
while (true){
    var message_id = buffer_read(buffer,buffer_u8);
    //handle types (constants; see Macros:all configurations)
    switch(message_id){
        //move
        case msg_move:
            var client = buffer_read(buffer,buffer_u16);
            var xx = buffer_read(buffer,buffer_u16);
            var yy = buffer_read(buffer,buffer_u16);
            //check existing or create
            if(ds_map_exists(clientmap,string(client))){
                var cobj = clientmap[? string(client)];
                cobj.x = xx;
                cobj.y = yy;
            }else{
                //create visible client
                var l = instance_create(xx,yy,obj_client_ext);
                clientmap[? string(client)] = l;
            }
            with(obj_server_client){
                if (client_id != client_id_current){
                    network_send_raw(self.socket_id, other.send_buffer, buffer_tell(other.send_buffer));
                }
            }
        break;
    }
    //265B failsafe
    if (buffer_tell(buffer) ==buffer_get_size(buffer)){
        break;
    }
}

#define client_send_move
///client_send_move()
//start buffer
buffer_seek(send_buffer,buffer_seek_start, 0);
//write to buffer
buffer_write(send_buffer, buffer_u8, msg_move);
buffer_write(send_buffer, buffer_u16, round(obj_testplayer.x));
buffer_write(send_buffer, buffer_u16, round(obj_testplayer.y));
//send buffer
network_send_raw(socket,send_buffer,buffer_tell(send_buffer));