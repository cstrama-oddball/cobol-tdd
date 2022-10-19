#!/bin/sh

val=`python3 gen-rand.py`
python3 PreCompile.py $1 $val
cobc $3 -o $2 $val
rm $val