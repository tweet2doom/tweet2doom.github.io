#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

dir_tweet2doom="$wd/tweet2doom"

git pull --rebase

./random-plays.sh

/usr/bin/node $dir_tweet2doom/post/post.js 0 "🎥 Random plays

Auto-generated highlights from @tweet2doom nodes.
The commands are tweeted by people and executed by a bot.

🤖 Generated daily at 14:00 UTC" ./tmp/highlights.mp4 ./tmp/subs.srt

echo $? > ./tmp/post.code
