#!/bin/bash

NUM_FRAMES=1000
PATTERN=21
CPUS=6

printf "\n\n"
printf "=====> Test x264enc <====="
time gst-launch-1.0 videotestsrc num-buffers=${NUM_FRAMES} pattern=${PATTERN} horizontal-speed=5 ! \
    x264enc ! \
    h264parse ! \
    matroskamux ! \
    filesink location=x264enc.mkv

printf "\n\n"
printf "=====> Test x265enc <====="
time gst-launch-1.0 videotestsrc num-buffers=${NUM_FRAMES} pattern=${PATTERN} horizontal-speed=5 ! \
    x265enc ! \
    h265parse ! \
    matroskamux ! \
    filesink location=x265enc.mkv

printf "\n\n"
printf "=====> Test vp8enc <====="
time gst-launch-1.0 videotestsrc num-buffers=${NUM_FRAMES} pattern=${PATTERN} horizontal-speed=5 ! \
    vp8enc deadline=1 auto-alt-ref=true cpu-used=${CPUS} threads=${CPUS} ! \
    matroskamux ! \
    filesink location=vp8enc.mkv

printf "\n\n"
printf "=====> Test vp9enc <====="
time gst-launch-1.0 videotestsrc num-buffers=${NUM_FRAMES} pattern=${PATTERN} horizontal-speed=5 ! \
    vp9enc deadline=1 row-mt=true auto-alt-ref=true cpu-used=${CPUS} ! \
    vp9parse ! \
    matroskamux ! \
    filesink location=vp9enc.mkv

printf "\n\n"
printf "=====> Test av1enc <====="
time gst-launch-1.0 videotestsrc num-buffers=${NUM_FRAMES} pattern=${PATTERN} horizontal-speed=5 ! \
    av1enc cpu-used=5 ! \
    av1parse ! \
    matroskamux ! \
    filesink location=av1enc.mkv
