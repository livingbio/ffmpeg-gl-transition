#!/bin/bash
# basic reference for writing script for travis

set -ev

ffmpeg -h
xvfb-run -s '+iglx -screen 0 1920x1080x24' bash concat.sh