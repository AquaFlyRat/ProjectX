///init_text()
var layout = " 0123456789abcdefghijklmnopqrstuvwxyz,.!?:+-/*()[]<>`_"
for (i = 0;i<=255;i++){
    global.char[i] = -1;
}
for (i = 1;i<=string_length(layout);i++){
    global.char[ord(string_char_at(layout,i))] = i;
}
