#!/bin/bash

cd "$(dirname "$0")"

js="js/graph.js"

echo "" > $js
echo "function graph_create() {" >> $js

for id in `ls data/nodes` ; do
    if [ "$id" = "root" ] ; then continue ; fi
    read -r depth < data/nodes/$id/depth
    depth=$((2*$depth + 0))

    if [ "$id" = "1444355917160534024" ] ; then
        # root node
        echo "nodes.push({ id: '$id', label: \"ROOT\", level: $depth, group: \"node\", image: \"images/logo.png\" });" >> $js
    else
        echo "nodes.push({ id: '$id', label: \"\", level: $depth, group: \"node\", image: \"images/logo.png\" });" >> $js
    fi
done

for id in `ls data/processed` ; do
    read -r depth < data/processed/$id/depth
    depth=$((2*$depth - 1))
    read -r username < data/processed/$id/username
    #cmd=$(cat data/processed/$id/cmd.txt | tr -d '\n')
    #echo "nodes.push({ id: $id, label: \"$username\", title: \"$cmd\", level: $depth, group: \"command\", font: { face: \"Liberation Mono\", size: 12 }});" >> $js
    echo "nodes.push({ id: '$id', label: \"$username\", level: $depth, group: \"command\", font: { face: \"Liberation Mono\", size: 12 }, chosen: false });" >> $js
done

echo "" >> $js

for id in `ls data/processed` ; do
    read -r parent_id < data/processed/$id/parent_id
    read -r child_id < data/processed/$id/child_id
    echo "edges.push({ from: '$id', to: '$parent_id' });" >> $js
    echo "edges.push({ from: '$child_id', to: '$id' });" >> $js
done

echo "}" >> $js
