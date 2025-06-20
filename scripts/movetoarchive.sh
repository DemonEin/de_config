#!/bin/bash

MOVE='rclone move --immutable --delete-empty-src-dirs --progress'

$MOVE google-drive:/phone/Memes ~/archive/pictures/memes \
    && $MOVE google-drive:/phone/Personal ~/archive/pictures/personal \
    && $MOVE google-drive:/phone/Camera ~/archive/pictures/camera
