#!/bin/bash
# Docker container for my experiments.
# Since most interesting things for the nanoneed pytorch and/or tensorrt,
# this pytorch container is a good start.
docker run \
    -it \
    --runtime nvidia \
    --ipc=host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    -v $(pwd):/host \
    -p8888:8888 \
    nvcr.io/nvidia/pytorch:24.12-py3-igpu

