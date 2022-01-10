#!/bin/sh

if [ $# -ne 1 ]; then
    echo 'Requires one arguments.'
    return 1
fi
if [ ! -f "$1" ]; then
    echo "cannot open $2. No such file."
    return 1
fi

maildir="$(grep ^MAILDIR $1 | head -n 1 | cut -d '=' -f 2 | cut -d '"' -f 2)"

sent="$(echo ${maildir}/__sent | sed "s|\$HOME|$HOME|g")"
[ -d "${sent}" ] || maildirmake "${sent}"

grep -F '=' "$1" | \
grep -F 'MAILDIR' | \
grep -v -e '^MAILDIR' -e '^#' | \
cut -d '"' -f 2 | \
sed "s|\$MAILDIR|$maildir|g" | \
sed "s|\$HOME|$HOME|g" | \
while read line; do
    if [ -d "${line}" ]; then
        echo "[skipped] ${line}"
    else
        maildirmake "${line}"
        echo "[made]    ${line}"
    fi
done
