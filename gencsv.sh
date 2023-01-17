#!/bin/bash
> inputdata
x=1
if [[ -z "$1" ]]
then 
   y=10
else 
   y=$1
fi
for i in $(seq $x $y)
do
    echo "$i, $RANDOM" >> inputdata
done
