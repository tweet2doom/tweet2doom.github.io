#!/bin/bash

wd=$(dirname $0)
cd $wd
wd=$(pwd)

cd $wd

ln -sfnv ../tweet2doom ./tweet2doom
ln -sfnv ../doomreplay/doomgeneric ./doomreplay

g++ -std=c++11 -O3 get-id.cpp -o get-id
