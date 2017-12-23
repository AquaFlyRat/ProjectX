///digit_check()
var d = "";
//standard
if keyboard_check_pressed(ord("1")){d+="1"}
if keyboard_check_pressed(ord("2")){d+="2"}
if keyboard_check_pressed(ord("3")){d+="3"}
if keyboard_check_pressed(ord("4")){d+="4"}
if keyboard_check_pressed(ord("5")){d+="5"}
if keyboard_check_pressed(ord("6")){d+="6"}
if keyboard_check_pressed(ord("7")){d+="7"}
if keyboard_check_pressed(ord("8")){d+="8"}
if keyboard_check_pressed(ord("9")){d+="9"}
if keyboard_check_pressed(ord("0")){d+="0"}
//numpad
if keyboard_check_pressed(vk_numpad1){d+="1"}
if keyboard_check_pressed(vk_numpad2){d+="2"}
if keyboard_check_pressed(vk_numpad3){d+="3"}
if keyboard_check_pressed(vk_numpad4){d+="4"}
if keyboard_check_pressed(vk_numpad5){d+="5"}
if keyboard_check_pressed(vk_numpad6){d+="6"}
if keyboard_check_pressed(vk_numpad7){d+="7"}
if keyboard_check_pressed(vk_numpad8){d+="8"}
if keyboard_check_pressed(vk_numpad9){d+="9"}
if keyboard_check_pressed(vk_numpad0){d+="0"}
//return
return(d);
