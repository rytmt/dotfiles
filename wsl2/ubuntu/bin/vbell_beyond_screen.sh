#! /bin/sh

ps j | awk '{if($10 ~ /^screen/){print $5}}' | while read pts; do

    echo -e '\a' > "/dev/${pts}"

done
