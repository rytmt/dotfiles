#!/bin/sh

if [ $# -ne 1 ]; then
    echo 'Requires one arguments.'
    return 1
fi
if [ ! -f "$1" ]; then
    echo "cannot open $1. No such file."
    return 1
fi

maildrop -V 9 "$1" </dev/null 2>/dev/null
if [ "$?" -ne "0" ]; then
    echo "format error in $1"
    echo "details: maildrop -V 1 $1 </dev/null"
fi

maildir="$(grep ^MAILDIR $1 | head -n 1 | cut -d '=' -f 2 | cut -d '"' -f 2)"
maildir="$(echo ${maildir} | sed "s|\$HOME|$HOME|g")"

[ -d "${maildir}" ] || mkdir -p "${maildir}"
[ -d "${maildir}/__sent" ] || maildirmake "${maildir}/__sent"
[ -d "${maildir}/__postponed" ] || maildirmake "${maildir}/__postponed"

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
        echo "[created]    ${line}"
    fi
done
