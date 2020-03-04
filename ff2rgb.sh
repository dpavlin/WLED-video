#!/bin/sh -xe

f=$1

test ! -d $f.rgb && mkdir $f.rgb || rm -v $f.rgb/*.png
ffmpeg -i $f -vf scale=10x10 $f.rgb/%03d.png
ls $f.rgb/*.png | xargs -i convert {} -rotate 180 -gamma 0.3 -depth 8 {}.rgb


