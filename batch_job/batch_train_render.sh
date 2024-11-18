#!/bin/bash

# grep all paths that matches "kitti/*/*""
SCENES=$(ls -d data/kitti/*/*/dust3r_2_views)
# SCENES=$(ls -d data/kubric/*/*/dust3r_2_views)

# print the number of scenes
echo "Number of scenes: $(echo "$SCENES" | wc -l)"

# get the dataset name by taking the second part of the path
DATASET=$(echo "$SCENES" | head -n 1 | cut -d'/' -f2)

for SCENE in $SCENES
do
    # take the second and third to the last parts of the path and replace "/" with "_"
    # EXP_NAME=${DATASET}/$(echo $SCENE | rev | cut -d'/' -f2,3 | rev | sed 's/\//_/g')
    EXP_NAME=${DATASET}_cube128T2_noReg_sh0/$(echo $SCENE | rev | cut -d'/' -f2,3 | rev | sed 's/\//_/g')

    # replace "/" with "_"
    JOB_NAME=$(echo $EXP_NAME | sed 's/\//_/g')

    while true; do
        PORT=$(( ( RANDOM % 64511 ) + 1024 ))
        if ! lsof -i:$PORT &>/dev/null; then
            # echo "Available port: $PORT"
            break
        fi
    done

    CMD_TRAIN="python train.py -s $SCENE --port $PORT --expname $EXP_NAME --configs arguments/$DATASET/default.py --sh_degree 0"
    # echo $CMD_TRAIN
    # $CMD_TRAIN

    # python render.py --model_path "output/kitti/2011_09_26_drive_0015_sync-pair_1"  --skip_train --configs arguments/kitti/default.py     
    CMD_RENDER="python render.py --model_path output/$EXP_NAME --skip_train --skip_video --configs arguments/$DATASET/default.py"
    # echo $CMD_RENDER
    # $CMD_RENDER

    CMD="/home/wiss/qis/local/usr/bin/isbatch.sh 4dgs_${JOB_NAME} $CMD_TRAIN && $CMD_RENDER"
    # echo $CMD
    $CMD
done
