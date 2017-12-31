#define create_server
var server = network_create_server_raw(network_socket_tcp, std_port, max_clients);

var server_controller = instance_create(0, 0, obj_server);
server_controller.socket_id = server;

//create_client("127.0.0.1", 6510, "server");

return server_controller;

#define server_recieve_data
var sock_id = ds_map_find_value(async_load, "id");

if(sock_id != obj_server.socket_id) {
var buffer = ds_map_find_value(async_load, "buffer");

var curr_client_id = client_map[? string(sock_id)].client_id;

if(curr_client_id < 0) {
    show_error("Error recieving message!", true);
}

while(true) {
    var msg_id = buffer_read(buffer, buffer_u8);
    switch(msg_id) {
    case netc_client_joined:
        var nickname_ = buffer_read(buffer, buffer_string);
        client_map[? string(sock_id)].nickname = nickname_;
        
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_client_joined);
        buffer_write(send_buffer, buffer_u16, curr_client_id);
        buffer_write(send_buffer, buffer_string, nickname_);
        buffer_write(send_buffer, buffer_u16, xx);
        buffer_write(send_buffer, buffer_u16, yy);
        
        // Send nickname of the recently connected client to all clients currently
        // connected.
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, buffer_tell(other.send_buffer));
            }
        }
        
        // Send nicknames of already connected clients to the client just connected.
        with(obj_serverClient) {
            buffer_seek(other.send_buffer, buffer_seek_start, 0);
            buffer_write(other.send_buffer, buffer_u8, netc_client_joined);
            buffer_write(other.send_buffer, buffer_u16, client_id);
            buffer_write(other.send_buffer, buffer_string, nickname);
            buffer_write(other.send_buffer, buffer_u16, xx);
            buffer_write(other.send_buffer, buffer_u16, yy);
        
            if(client_id != curr_client_id) {
                network_send_raw(sock_id, other.send_buffer, buffer_tell(other.send_buffer));    
            }
        }
        
        break;
    case netc_bullet_fired:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var dir = buffer_read(buffer, buffer_u16);
        var spd = buffer_read(buffer, buffer_u16);
        var _id = buffer_read(buffer, buffer_u32);
        
        //create_server_bullet(dir, spd, curr_client_id, xx, yy);
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_bullet_fired);
        buffer_write(send_buffer, buffer_u16, xx);
        buffer_write(send_buffer, buffer_u16, yy);
        buffer_write(send_buffer, buffer_u16, dir);
        buffer_write(send_buffer, buffer_u16, spd);
        buffer_write(send_buffer, buffer_u32, curr_client_id);
        
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, 13);
            }
        }
        
        break;
    case netc_puddle:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var obj = buffer_read(buffer, buffer_u32);
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_puddle);
        buffer_write(send_buffer, buffer_u16, xx);
        buffer_write(send_buffer, buffer_u16, yy);
        buffer_write(send_buffer, buffer_u32, obj);
        
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, 9);
            }
        }
        
        break;
    case netc_ammocreate:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_ammocreate);
        buffer_write(send_buffer, buffer_u16, xx);
        buffer_write(send_buffer, buffer_u16, yy);
        
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, 5);
            }
        }
        
        break;
    case netc_move:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var xscale = buffer_read(buffer, buffer_s8);
        var hps = buffer_read(buffer, buffer_s16);
        
        with(client_map[? string(sock_id)]) {
            x = xx;
            y = yy;
            image_xscale = xscale;
        }
        
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_move);
        buffer_write(send_buffer, buffer_u16, curr_client_id);
        buffer_write(send_buffer, buffer_u16, xx);
        buffer_write(send_buffer, buffer_u16, yy);
        buffer_write(send_buffer, buffer_s8, xscale);
        buffer_write(send_buffer, buffer_s16, hps);
        
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, 10);
            }
        }
        
        break;
    
    case netc_ammodestroy:
        var ammoid = buffer_read(buffer, buffer_u16); 
               
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_ammodestroy);
        buffer_write(send_buffer, buffer_u16, ammoid);
        
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, 3);
            }
        }
        
        break;
    case netc_barreldestroy:
        var barrelid = buffer_read(buffer, buffer_u16); 
               
        buffer_seek(send_buffer, buffer_seek_start, 0);
        buffer_write(send_buffer, buffer_u8, netc_barreldestroy);
        buffer_write(send_buffer, buffer_u16, barrelid);
        
        with(obj_serverClient) {
            if(client_id != curr_client_id) {
                network_send_raw(self.socket_id, other.send_buffer, 3);
            }
        }
        
        break;
        
    }
    if(buffer_tell(buffer) == buffer_get_size(buffer)) {
        break;
    }
}
}

#define server_recieve_client_connect
// Called from obj_server

var sock = ds_map_find_value(async_load, "socket");  
var client = instance_create(0, 0, obj_serverClient);
client.socket_id = sock;
client.client_id = connected_count++;
client_map[? string(sock)] = client;


#define server_recieve_client_disconnect
var sock = ds_map_find_value(async_load, "socket");

var client_id_ = client_map[? string(sock)].client_id;

with(client_map[? string(sock)]) {
    instance_destroy();
}

ds_map_delete(client_map, string(sock));

buffer_seek(send_buffer, buffer_seek_start, 0);
buffer_write(send_buffer, buffer_u8, netc_player_leave);
buffer_write(send_buffer, buffer_u16, client_id_);
with(obj_serverClient) {
    network_send_raw(self.socket_id, other.send_buffer, 3);
}