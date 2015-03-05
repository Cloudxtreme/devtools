#!/bin/sh
#xfer-files.sh
#2ß15ß3ß3rh dev
#
set -x
set -u 

srcDir=~/BR15-MAIN/files/*
#ls -al $srcDir

destDir=~/barrier_breaker/env/files/
#ls -al $srcDir

#copy without hidden files wih rsysnc
rsync -v -r --exclude=".*" $srcDir $destDir


