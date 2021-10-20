#!/bin/bash

src="../tweet2doom"

rsync -rtvum --include='*parent_id'     --include='*/' --exclude='*' $src/processed/ data/processed/
rsync -rtvum --include='*depth'         --include='*/' --exclude='*' $src/processed/ data/processed/
rsync -rtvum --include='*username'      --include='*/' --exclude='*' $src/processed/ data/processed/
rsync -rtvum --include='*input-cur.txt' --include='*/' --exclude='*' $src/processed/ data/processed/
rsync -rtvum --include='*frames_cur'    --include='*/' --exclude='*' $src/processed/ data/processed/
rsync -rtvum --include='*cmd.txt'       --include='*/' --exclude='*' $src/processed/ data/processed/

rsync -rtvum --include='*depth'         --include='*/' --exclude='*' $src/nodes/ data/nodes/
rsync -rtvum --include='*frames'        --include='*/' --exclude='*' $src/nodes/ data/nodes/
rsync -rtvum --include='*history.txt'   --include='*/' --exclude='*' $src/nodes/ data/nodes/

for id in `ls $src/processed` ; do
    #cat $src/processed/$id/result.json | jq -r .id_str > data/processed/$id/child_id
    ./get-id $src/processed/$id/result.json > data/processed/$id/child_id
done
