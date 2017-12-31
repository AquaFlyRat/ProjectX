///sfx_emit(x,y,sound)
var xx = argument[0];
var yy = argument[1];
var sid = argument[2];
if instance_exists(obj_player){
    var d = distance(xx,yy,obj_player.x,obj_player.y);
}else{
    d = 100;
}
d = clamp(d,1,100)
var snd = audio_play_sound(sid,1,false);
audio_sound_pitch(snd,random_range(.5,1.75));
audio_sound_gain(snd,10/d,0);
