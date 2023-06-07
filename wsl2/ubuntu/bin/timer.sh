#!/bin/bash

if ! echo "$1" | grep -Eq '^[1-9]+[0-9]*$'; then
    echo 'argument error'
    exit 1
fi

progress_bar() {
    current=$1
    total=$2

    progress=$(($current * 100 / ${total}))

    bar="$(yes '#' | head -n ${progress} | tr -d '\n')"
    if [ -z "$bar" ]; then
        bar='_'
    fi

    printf "\r[%-100s] (%d/%d)" ${bar} ${current} ${total}
}

timelimit=$1
for i in $(seq 1 ${timelimit}); do
    progress_bar ${i} ${timelimit}
    sleep 1s
done

echo ""
