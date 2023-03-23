#!/bin/sh

sum=0
while read line; do

    if echo -n "${line}" | grep -Fq '.'; then
        # float
        tmp="${line}"
    else
        # int
        tmp="$(echo -n $line | sed 's/^0\+//g')"
    fi

    sum=$(echo "${sum} + ${tmp}" | bc)

done
echo "${sum}"
