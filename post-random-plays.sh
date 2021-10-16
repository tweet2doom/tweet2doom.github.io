#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

dir_tweet2doom="$wd/tweet2doom"

git pull --rebase

./random-plays.sh

node $dir_tweet2doom/post/post.js "🎥 Random plays

Auto-generated highlights of 10 random @tweet2doom nodes" ./tmp/highlights.mp4
