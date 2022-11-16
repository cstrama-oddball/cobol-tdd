#!/bin/sh
val=`python3 gen-rand.py`


# $1 == source file
# $2 == output binary
# $3 == -m library, -x executable
python3 PreCompile.py $1 $val $3 $2
cobc $val -o $2 $3
#cat $val
rm $val