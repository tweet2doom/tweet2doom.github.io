#!/bin/bash

cd "$(dirname "$0")"

js="js/graph.js"

echo "" > $js
echo "function graph_create() {" >> $js

for id in `ls data/nodes` ; do
    if [ "$id" = "root" ] ; then continue ; fi
    depth=$(cat data/nodes/$id/depth)
    depth=$((2*$depth + 0))
    echo "nodes.push({ id: $id, label: \"\", level: $depth, group: \"node\", image: \"images/logo.png\" });" >> $js
done

for id in `ls data/processed` ; do
    depth=$(cat data/processed/$id/depth)
    depth=$((2*$depth - 1))
    username=$(cat data/processed/$id/username)
    #cmd=$(cat data/processed/$id/cmd.txt | tr -d '\n')
    #echo "nodes.push({ id: $id, label: \"$username\", title: \"$cmd\", level: $depth, group: \"command\", font: { face: \"Liberation Mono\", size: 12 }});" >> $js
    echo "nodes.push({ id: $id, label: \"$username\", level: $depth, group: \"command\", font: { face: \"Liberation Mono\", size: 12 }});" >> $js
done

echo "" >> $js

for id in `ls data/processed` ; do
    parent_id=$(cat data/processed/$id/parent_id)
    child_id=$(cat data/processed/$id/child_id)
    echo "edges.push({ from: $id, to: $parent_id });" >> $js
    echo "edges.push({ from: $child_id, to: $id });" >> $js
done

echo "}" >> $js
