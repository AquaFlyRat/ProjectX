///text_draw(x,y,string,font sprite,col,scale,alpha,textwrap)
var xx = argument[0];
var yy = argument[1];
var str= string_lower(argument[2]);
var font= argument[3];
var col= argument[4];
var scale = argument[5];
var alpha = argument[6];
var wrap = argument[7];
var ofx = 0;
var ofy = 0;
for (i = 1;i<=string_length(str);i++){
    var c = ord(string_char_at(str,i));
    if c !=-1{
        if string_char_at(str,i) !="$"{
            draw_sprite_ext(font,global.char[c]-1,xx+ofx,yy+ofy,scale,scale,0,col,alpha)
        }else{
            draw_sprite_ext(font,global.char[c]-1,xx+ofx,yy+ofy,scale,scale,0,c_white,alpha)
        }
        if string_char_at(str,i) != " "{
            ofx +=sprite_get_width(font)*scale*.8;
        }else{
            ofx +=sprite_get_width(font)*scale*.4;
            if (wrap && xx+ofx>(view_wview*2)-72){  //text wrap!!!!
                ofx = 0;
                ofy += (sprite_get_height(font))*scale;
            }
        }
    }
    if string_char_at(str,i) == "#" {
        ofx = 0;
        ofy += (sprite_get_height(font))*scale;
    }
}
