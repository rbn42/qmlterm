#!/bin/bash

TEMP_FILE="/tmp/visual selection mode -- qmlterm"

rm "$TEMP_FILE"

CMD1='normal!pG"add'
#configuration
CMD1='set nocompatible'
CMD2='set clipboard=unnamedplus'
#navigation
CMDN1='normal!ggGHkkL'
#save selection to temp file and quit
CMDQ='map q "aygggg"bdG"ap:wq<CR>'

#load clipboard
xsel -o -b > "$TEMP_FILE"

vim \
    -u NONE\
    -N\
    -n\
    "$TEMP_FILE"  \
    -c "$CMD1" \
    -c "$CMD2" \
    -c "$CMD3" \
    -c "$CMD4" \
    -c "$CMD5" \
    -c "$CMD6" \
    -c "$CMDN1" \
    -c "$CMDQ"  

#load temp file to clipboard
cat "$TEMP_FILE" | xsel -i
cat "$TEMP_FILE" | xsel -i -b
rm "$TEMP_FILE"
