#!/bin/bash

# 引数チェック
date_left="$1"
date_right="$2"

date_fmtcheck(){
    if echo -n "$1" | grep -Eq -e '[0-9]{4}/[0-9]{1,2}/[0-9]{1,2}' -e '[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}'; then
        return 0
    else
        return 1
    fi
}

date_fmtcheck "${date_left}"; check_left=$?
date_fmtcheck "${date_right}"; check_right=$?

if [ ! "${check_left}" = "0" ] || [ ! "${check_right}" = "0" ]; then
    echo "引数の形式が不正です。"
    echo "第一/第二引数：YYYY-MM-DD or YYYY/MM/DD"
    exit 1
fi

# unixtime に変換
utime_left="$(date -d "${date_left}" +%s)"
utime_right="$(date -d "${date_right}" +%s)"

# 引き算して日数に変換
echo "$(( (utime_left - utime_right) / 86400 ))日"
