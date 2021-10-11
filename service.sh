#!/bin/bash

wd=$(dirname $0)
cd $wd/
wd=$(pwd)

while true ; do
    sleep 15

    echo "Doing update `date` ..."

    git pull --rebase

    ./sync.sh

    num_new=$(git ls-files --others --exclude-standard data/nodes | wc -l)
    if [ "$num_new" -eq 0 ] ; then
        echo "Nothing to update"
        continue;
    fi

    ./generate-graph.sh

    git add data/*
    git add js/graph.js
    git commit -m "New states added [`date`]"
    git push
done
