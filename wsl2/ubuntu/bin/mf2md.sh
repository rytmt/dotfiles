#!/bin/sh

MDVAR='MAILDIR'
SENTDIR='__sent'
PPDIR='__postponed'

if [ $# -ne 1 ]; then
    echo 'Requires one arguments.'
    exit 1
fi
if [ ! -f "$1" ]; then
    echo "cannot open $1. No such file."
    exit 1
fi

maildrop -V 9 "$1" </dev/null 2>/dev/null
if [ "$?" -ne "0" ]; then
    echo "format error in $1"
    echo "details: maildrop -V 1 $1 </dev/null"
    exit 1
fi

mdmake (){
    if [ -d "$1" ]; then
        echo "[skipped] $1"
    else
        maildirmake "$1"
        echo "[created] $1"
    fi
}

maildir="$(grep ^${MDVAR} $1 | head -n 1 | cut -d '=' -f 2 | cut -d '"' -f 2)"
maildir="$(echo ${maildir} | sed "s|\$HOME|$HOME|g")"

[ -d "${maildir}" ] || mkdir -p "${maildir}"

mdmake "${maildir}/${SENTDIR}"
mdmake "${maildir}/${PPDIR}"

grep -F '=' "$1" | \
grep -F "${MDVAR}" | \
grep -v -e "^${MDVAR}" -e '^#' | \
cut -d '"' -f 2 | \
sed "s|\$${MDVAR}|$maildir|g" | \
sed "s|\$HOME|$HOME|g" | \
while read line; do
    mdmake "${line}"
done
