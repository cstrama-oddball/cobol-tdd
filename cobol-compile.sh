#!/bin/sh

val=`python3 gen-rand.py`
python3 PreCompile.py $1 $val $3
cobc $val -o $2 $3
#cat $val
rm $val