#define create_client
var ip = argument0;
var port = argument1;
var nickname = argument2;

var client = instance_create(0, 0, obj_client);

var client_socket = network_create_socket(network_socket_tcp);
var server = network_connect_raw(client_socket, ip, port);

if(server < 0) 
    show_error("Could not connect to server!", true);

client.socket_id = client_socket;

with(client) {
    buffer_seek(send_buffer, buffer_seek_start, 0);
    buffer_write(send_buffer, buffer_u8, netc_client_joined);
    buffer_write(send_buffer, buffer_string, nickname);
    buffer_write(send_buffer, buffer_u16, round(obj_player.x));
    buffer_write(send_buffer, buffer_u16, round(obj_player.y));
    
    network_send_raw(socket_id, send_buffer, buffer_tell(send_buffer));
}


#define client_recieve_data
var buffer = ds_map_find_value(async_load, "buffer");

while(true) {
    var msg_id = buffer_read(buffer, buffer_u8);
    switch(msg_id) {
    case netc_client_joined:
        var cid = buffer_read(buffer, buffer_u16);
        var nickname_ = buffer_read(buffer, buffer_string);
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        
        if(ds_map_exists(client_map, string(cid))) {
            client_map[? string(cid)].nickname = nickname_;
        } else {
            var c = instance_create(xx, yy, obj_netplayer);
            client_map[? string(cid)] = c;
            c.client_id = cid;
            c.nickname = nickname_;
        }
        
        break;
    case netc_player_leave:
        var cid = buffer_read(buffer, buffer_u16);
        with(client_map[? string(cid)]) {
            instance_destroy();
        }
        ds_map_delete(client_map, string(cid));
        break;
        
    case netc_bullet_fired:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var dir = buffer_read(buffer, buffer_u16);
        var spd = buffer_read(buffer, buffer_u16);
        var _id = buffer_read(buffer, buffer_u32);
        
        var bullet = instance_create(xx, yy, obj_bullet);
        bullet.dir = dir;
        bullet.spd = spd;
        bullet.par = _id;
        
        break;
    case netc_puddle:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var obj = buffer_read(buffer, buffer_u32);
        
        var puddle = instance_create(xx, yy, obj);
        
        break;   
    case netc_move:
        var client_id_ = buffer_read(buffer, buffer_u16);
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var xscale = buffer_read(buffer, buffer_s8);
        var hps = buffer_read(buffer, buffer_s16);
        
        if(ds_map_exists(client_map, string(client_id_))) {
            var found_client = client_map[? string(client_id_)];
            
            found_client.next_x = xx;
            found_client.next_y = yy;
            found_client.prev_x = found_client.x;
            found_client.prev_y = found_client.y;
            found_client.time = 0;
            found_client.image_xscale = xscale;
            found_client.hp = hps;
            
        } else {
            var c = instance_create(xx, yy, obj_netplayer);
            client_map[? string(client_id_)] = c;
            c.client_id = client_id_;
        }
        
        break;
    case netc_ammocreate:
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        
        var obj = instance_create(xx, yy, obj_ammo);
        
        break; 
    case netc_ammodestroy:
        var ammoid = buffer_read(buffer, buffer_u16);
         
        for (i=0; i<=instance_number(obj_ammo); i++) {
            var ammo = instance_find(obj_ammo, i);
            if(instance_exists(ammo)) {
                var amid = ammo.ammo_id;
                if(amid == ammoid) {
                    with (ammo) {
                        instance_destroy();
                    }
                }
            }
        }
        
        break;
    case netc_barreldestroy:
        var barrelid = buffer_read(buffer, buffer_u16);
        var d = 0;
        for (i=0; i<=instance_number(obj_toxicbarrel); i++) {
            var barrel = instance_find(obj_toxicbarrel, i);
            if(instance_exists(barrel)) {
                var brid = barrel.barrel_id;
                if(brid == barrelid) {
                    with (barrel) {
                        tell = 0;
                        instance_destroy();
                    }
                    d = 1;
                }
            }
        }
        if d == 0{
            for (i=0; i<=instance_number(obj_explosivebarrel); i++) {
                var barrel = instance_find(obj_explosivebarrel, i);
                if(instance_exists(barrel)) {
                    var brid = barrel.barrel_id;
                    if(brid == barrelid) {
                        with (barrel) {
                            tell = 0;
                            instance_destroy();
                        }
                    }
                }
            }
        }
        break;
    }
    
    if(buffer_tell(buffer) == buffer_get_size(buffer)) {
        break;
    }
    
    
}

#define client_send_move_data
buffer_seek(send_buffer, buffer_seek_start, 0);
buffer_write(send_buffer, buffer_u8, netc_move);
buffer_write(send_buffer, buffer_u16, round(obj_player.x));
buffer_write(send_buffer, buffer_u16, round(obj_player.y));
buffer_write(send_buffer, buffer_s8, round(obj_player.image_xscale));
buffer_write(send_buffer, buffer_s16, round(obj_player.hp));

network_send_raw(socket_id, send_buffer, buffer_tell(send_buffer));