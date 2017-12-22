#define server_create
///server_create(port,client num)
var port = argument[0];
var cnum = argument[1];
var serv = 0;
//raw allows for c# or c++ integration more easily
serv = network_create_server_raw(network_socket_tcp,port,cnum);
//prep client maps
clientmap = ds_map_create();
//prep buffers
send_buffer = buffer_create(256,buffer_fixed,1);
//show error if connection failed (<0)
if (serv<0){
    show_error("Failed to Connect to Server",true);
}
//return
return(serv)

#define server_handle_connect
///server_handle_connect(socket id)
var socker_id = argument[0];
//client object
l = instance_create(0,0,obj_server_client);     
l.socket_id = socket_id;    //socket number id
l.client_id = client_id_counter++;  //client number id
//integer failsafe
if(client_id_counter>=65000){
    client_id_counter = 0;
}
//client map
clientmap[? string(socket_id)] = l;

#define server_handle_message
//server_handle_message(socket_id, buffer)
var socket_id = argument[0];
var buffer = argument[1];
var client_id_current = clientmap[? string(socket_id)].client_id;
//handle message
while (true){
    var message_id = buffer_read(buffer,buffer_u8);
    //handle types (constants; see Macros:all configurations)
    switch(message_id){
        //move
        case msg_move:
            //read new coordinates
            var xx = buffer_read(buffer,buffer_u16);
            var yy = buffer_read(buffer,buffer_u16);
            //restart buffer
            buffer_seek(send_buffer,buffer_seek_start,0);
            //relay information
            buffer_write(send_buffer,buffer_u8,msg_move);               //1B
            buffer_write(send_buffer,buffer_u16,client_id_current);     //2B
            buffer_write(send_buffer,buffer_u16,xx);                    //2B
            buffer_write(send_buffer,buffer_u16,yy);                    //2B
            //TOTAL_______________________________________________________7B
            //access all clients
            with(obj_server_client){
                //send to all excluding self
                if (client_id != client_id_current){
                    //total size above^^ (or buffer_tell)
                    network_send_raw(self.socket_id,other.send_buffer,buffer_tell(other.send_buffer));
                }
            }
        break;
    }
    //265B failsafe
    if (buffer_tell(buffer) ==buffer_get_size(buffer)){
        break;
    }
}

#define server_handle_disconnect
//server_handle_disconnect(socket_id)
var socket_id = argument[0];
//delete object
with(clientmap[? (string(socket_id))]){
    instance_destroy();
}
//remove from map
ds_map_delete(clientmap, string(socket_id));