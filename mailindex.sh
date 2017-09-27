#!/bin/sh

PATH='/bin:/usr/bin:/sbin:/usr/sbin'
IFS=$(printf ' \t\n_'); IFS=${IFS%_}
LANG=C; LC_ALL=C
export PATH IFS LANG LC_ALL

umask 0022

SCRIPTDIR="$(dirname $0)"
HOMEDIR=''
INDEXDIR=''
TSFILE="${SCRIPTDIR}/.timestamp_mailindex"
TSOLD=0
TSNEW="$(date +%s)"

if [ -f "${TSFILE}" ]; then
    TSOLD="$(cat ${TSFILE})"
fi

printf "${TSNEW}" >"${TSFILE}"

MDAY="$((((${TSNEW}-${TSOLD})/3600)+1))"

find "${HOMEDIR}" -type f -mtime "-${MDAY}" | while read line ; do
    ln -sf "${line}" "${INDEXDIR}/"
done

