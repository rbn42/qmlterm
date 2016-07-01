#!/bin/bash

export TEMP_FILE="/tmp/edit_clip_temp_file"

rm $TEMP_FILE

#load clipboard
export CMD1="normal!p"
#save selection to temp file and quit
export CMD2='map q "aygggg"bdG"ap:wq<CR>'

#replace your terminal with `bash ~/bin/term_tiny`
bash ~/bin/term_tiny -e """
vim $TEMP_FILE  \
    -c '$CMD1' \
    -c '$CMD2'  
"""

#load temp file to clipboard
cat $TEMP_FILE | xsel -i
cat $TEMP_FILE | xsel -i -b
rm $TEMP_FILE
