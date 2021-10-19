#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

dir_doomreplay="$wd/doomreplay"
dir_tweet2doom="$wd/tweet2doom"

cd data/nodes

nodes_all="$(ls)"
nodes=""
num_nodes=0
for i in $nodes_all ; do
    read -r depth < ${i}/depth
    read -r frames < ${i}/frames
    if [ $depth -lt 3 ] ; then
        continue
    fi
    if [ $frames -lt 1050 ] ; then
        continue
    fi
    nodes="$nodes $i"
    num_nodes=$(($num_nodes + 1))
done

echo "Total nodes: $num_nodes"

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
        -nfreeze 10 \
        -render_frame \
        -render_input \
        -render_username || result=$?

    $dir_tweet2doom/parse-history data/nodes/$i/history.txt 350 35 tmp/command_$i > /dev/null
done

j=0
cd tmp
for i in `ls *.mp4 | sort -R` ; do
   echo "file '$i'" >> list

   j=$(($j + 1))
   id=$(echo ${i%.*})

   for k in `seq 0 9` ; do
       idx=$(( ($j - 1)*10 + k ))

       ts_m=$(( 600*($idx    ) ))
       te_m=$(( 600*($idx + 1) ))

       ts_s=$(printf "%02d" $(( $ts_m/1000 )) )
       ts_m=$(printf "%03d" $(( $ts_m - ($ts_m/1000)*1000 )) )
       te_s=$(printf "%02d" $(( $te_m/1000 )) )
       te_m=$(printf "%03d" $(( $te_m - ($te_m/1000)*1000 )) )

       cmd=$(cat command_$id | head -n $(($k + 1)) | tail -n 1)

       echo "$(( $idx + 1 ))" >> subs.srt
       echo "00:00:$ts_s,$ts_m --> 00:00:$te_s,$te_m" >> subs.srt
       echo "$cmd" >> subs.srt
       echo "" >> subs.srt
   done

   #ts=$(printf "%02d" $((($j - 1)*6)))
   #te=$(printf "%02d" $((($j    )*6)))
   #read -r cmd < command_$id
   #echo "$j" >> subs.srt
   #echo "00:00:$ts,000 --> 00:00:$te,000" >> subs.srt
   #echo "Play $j: $cmd" >> subs.srt
   #echo "" >> subs.srt
done

ffmpeg -f concat -safe 0 -i list -c copy highlights.mp4
