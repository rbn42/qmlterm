#!/bin/bash

TEMP_FILE="/tmp/visual selection mode -- qmlterm"

rm "$TEMP_FILE"

CMD1='normal!pG"add'
#configuration
CMD1='set nocompatible'
CMD2='set clipboard=unnamedplus'
#navigation
CMDN1='normal!ggGHkL'
#save selection to temp file and quit
CMDQ='map q "aygggg"bdG"ap:wq<CR>'

#load clipboard
xsel -o -b > "$TEMP_FILE"

#TODO
#clean up
python -c """
import sys
lines=[line.strip()+'\\n' for line in open(sys.argv[1]) if len(line.strip())>0]
with open(sys.argv[1],'w') as f:
    f.writelines(lines)
""" "$TEMP_FILE"

#replace `bash ~/bin/term_tiny` with your terminal. 
bash ~/bin/term_tiny -e """
vim \"$TEMP_FILE\"  \
    -u NONE \
    -c '$CMD1' \
    -c '$CMD2' \
    -c '$CMD3' \
    -c '$CMD4' \
    -c '$CMD5' \
    -c '$CMD6' \
    -c '$CMDN1' \
    -c '$CMDQ'  
"""

#load temp file to clipboard
cat "$TEMP_FILE" | xsel -i
cat "$TEMP_FILE" | xsel -i -b
rm "$TEMP_FILE"
