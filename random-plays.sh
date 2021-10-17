#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

dir_doomreplay="$wd/doomreplay"

cd data/nodes

nodes_all="$(ls)"
nodes=""
for i in $nodes_all ; do
    depth=$(cat ${i}/depth)
    if [ $depth -lt 3 ] ; then
        continue
    fi
    nodes="$nodes $i"
done

nodes_render=$(echo "$nodes" | tr " " "\n" | sort -R | tail -n 10)

cd ../../

rm -rf tmp
mkdir -p tmp

rm -rf .savegame
ln -sf $dir_doomreplay/.savegame .savegame

for i in $nodes_render ; do
    $dir_doomreplay/doomgeneric \
        -iwad $dir_doomreplay/doom1.wad \
        -input data/nodes/$i/history.txt \
        -output tmp/$i.mp4 \
        -nrecord 350 \
        -framerate 60 \
        -nfreeze 5 \
        -render_frame \
        -render_input \
        -render_username || result=$?
done

cd tmp
for i in `ls | sort -R` ; do
   echo "file '$i'" >> list
done

ffmpeg -f concat -safe 0 -i list -c copy highlights.mp4
