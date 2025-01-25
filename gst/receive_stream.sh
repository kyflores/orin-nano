#!/bin/bash

gst-launch-1.0 \
    udpsrc port="${1}" ! \
    application/x-rtp,encoding-name=H264,payload=96 ! \
    rtph264depay ! \
    h264parse ! \
    queue ! \
    decodebin ! \
    videoconvert ! \
    fpsdisplaysink sync=false -e
