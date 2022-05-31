#!/bin/sh

rmzero(){
    if echo "$1" | grep -qE '^[0-9]+$'; then
        echo "$1" | grep -Eo '[1-9]+[0-9]*$'
    fi
}

sum=0
while read line; do

    tmp="$(rmzero $line)"
    sum="$((sum + tmp))"

done
echo "${sum}"
