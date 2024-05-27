#!/bin/bash

if [ ! -f "/usr/src/app/QmsgNtClient-NapCatQQ/package.json" ]; then
    unzip /tmp/QmsgNtClient-NapCatQQ.zip -d /usr/src/app/QmsgNtClient-NapCatQQ
fi

chmod -R 777 /usr/src/app/QmsgNtClient-NapCatQQ/

export FFMPEG_PATH=/usr/bin/ffmpeg

cd ./QmsgNtClient-NapCatQQ
./napcat.sh -q $ACCOUNT
