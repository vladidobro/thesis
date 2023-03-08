#!/bin/sh
echo "file_path,file_template,sample,experiment,set,wavelength,flags,beta"

find stokes/stokes  -type f \
    | awk -F'\/' '/[0-9].dat$/{
    split($3,wv,"_"); split($4,fn,"\."); gsub("_",".",fn[1]); 
    print $0 ",femtik_standard," $1 "," $2 "," $3 "," wv[1] "," wv[2] "," fn[1]
    }' \
    > filelist_stokes
