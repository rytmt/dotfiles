#!/bin/sh

env_err=''
env_chk=0

if [ $# -ne 2 ]; then
    env_err="${env_err}Requires two arguments.\n"
    env_chk=$((env_chk+1))
else
    if [ ! -f "$1" ]; then
        env_err="${env_err}cannot open $1. No such file.\n"
        env_chk=$((env_chk+1))
    fi
    if [ ! -d "$2" ]; then
        env_err="${env_err}cannot open $2. No such directory.\n"
        env_chk=$((env_chk+1))
    fi
fi

if [ $env_chk -ne 0 ]; then
    echo "${env_err}"
    exit 1
fi

srcfile="$1"
dstdir="$(echo $2 | sed 's|/$||')"

cat "${srcfile}" | while read line
do
    [ -f "${line}" ] && rsync -ptu "${line}" "${dstdir}/"
    if [ -d "${line}" ]; then
        srcdir="$(echo ${line} | sed 's|/$||')"
        rsync -ptur "${srcdir}" "${dstdir}/"
    fi
done

