#!/bin/bash
chmod -R 777 /usr/src/app/QmsgNtClient-NapCatQQ/
Xvfb :1 -screen 0 1080x760x16 +extension GLX +render &
export FFMPEG_PATH=/usr/bin/ffmpeg
export DISPLAY=:1
qq --no-sandbox -q $ACCOUNT
