///text_length(string,font,scale);
var str = argument[0];
var fnt = argument[1];
var scl = argument[2];
return((string_length(str)-1)*sprite_get_width(fnt)*scl*.75);
