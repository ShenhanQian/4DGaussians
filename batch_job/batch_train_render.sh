#!/bin/bash

# grep all paths that matches "kitti/*/*""
# SCENES=$(ls -d data/kitti/*/*/dust3r_2_views)
# SCENES=$(ls -d data/kubric/*/*/dust3r_2_views)

SCENES="\
"
# data/kitti/2011_09_30_drive_0018_sync/pair_17/dust3r_2_views
# data/kitti/2011_09_30_drive_0027_sync/demo_1/ust3r_2_views
# data/kitti/2011_09_30_drive_0028_sync/pair_7/dust3r_2_views

# data/kubric/seq_0002/pair_2/dust3r_2_views
# data/kubric/seq_0019/pair_1/dust3r_2_views
# data/kubric/seq_0032/pair_2/dust3r_2_views


# print the number of scenes
echo "Number of scenes: $(echo "$SCENES" | wc -w)"

# get the dataset name by taking the second part of the path
DATASET=$(echo "$SCENES" | head -n 1 | cut -d'/' -f2)
# echo "Dataset: $DATASET"

for SCENE in $SCENES
do
    # take the second and third to the last parts of the path and replace "/" with "_"
    # EXP_NAME=${DATASET}/$(echo $SCENE | rev | cut -d'/' -f2,3 | rev | sed 's/\//_/g')
    EXP_NAME=${DATASET}_cube128T2_noReg_sh0/$(echo $SCENE | rev | cut -d'/' -f2,3 | rev | sed 's/\//_/g')
    # EXP_NAME=${DATASET}_cube128T2_noReg_sh0_vis/$(echo $SCENE | rev | cut -d'/' -f2,3 | rev | sed 's/\//_/g')

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

    CMD_RENDER="python render.py --model_path output/$EXP_NAME --skip_train --skip_video --configs arguments/$DATASET/default.py"
    # echo $CMD_RENDER
    # $CMD_RENDER

    CMD_INTERP="python render.py --model_path output/$EXP_NAME --skip_test --configs arguments/$DATASET/default.py"
    # echo $CMD_INTERP
    # $CMD_INTERP

    CMD="/home/wiss/qis/local/usr/bin/isbatch.sh 4dgs_${JOB_NAME} $CMD_TRAIN && $CMD_RENDER"
    # echo $CMD
    # $CMD
done
