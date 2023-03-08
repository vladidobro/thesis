#!/bin/sh
echo "file_path,file_template,sample,experiment,set,wavelength,flags,beta"

find cofe/low_t cofe/room_t cofe/room_t_mirrors cofe/bridge_tests \
    ferh/fm_vlad ferh/fm_zeynab ferh/fm_mirror -type f \
    | awk -F'\/' '/[0-9].dat$/{
    split($3,wv,"_"); split($4,fn,"\."); gsub("_",".",fn[1]); 
    print $0 ",femtik_standard," $1 "," $2 "," $3 "," wv[1] "," wv[2] "," fn[1]
    }' \
    | awk '/cofe\/room_t_mirrors/{sub("femtik_standard","femtik_switch",$0); print}!/cofe\/room_t_mirrors/{print}' \
    > filelist
