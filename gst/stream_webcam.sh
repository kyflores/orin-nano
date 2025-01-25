# !/bin/bash

CLIENT=${1}
gst-launch-1.0 \
    v4l2src device=/dev/video0 ! \
    videoconvert ! \
    x264enc tune=zerolatency ! \
    h264parse ! \
    rtph264pay config-interval=1 ! \
    udpsink clients=${CLIENT}

