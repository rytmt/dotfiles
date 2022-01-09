#!/bin/sh

# 第一引数: .mailfilter ファイルのパス
# 第二引数: 再フィルタリングメールボックスのパス

arg_err=''
arg_chk=0

# スクリプト引数の個数チェック
if [ $# -ne 2 ]; then
    arg_err="${arg_err}引数の個数が正しくありません\n"
    arg_chk=$((arg_chk+1))
else # 引数の個数チェックに成功した場合は形式チェックする
    if [ ! -f "$1" ]; then
        arg_err="${arg_err}$1 という名前のファイルは存在しません\n"
        arg_chk=$((arg_chk+1))
    else # ファイルが存在する場合は内容のチェックをする
        maildrop -V 9 "$1" </dev/null 2>/dev/null
        if [ "$?" -ne "0" ]; then
            arg_err="${arg_err}$1 のファイル内容に誤りがあります\n"
            arg_chk=$((arg_chk+1))
        fi
    fi
    if [ ! -d "$2" ]; then
        arg_err="${arg_err}$2 という名前のディレクトリは存在しません\n"
        arg_chk=$((arg_chk+1))
    fi
fi

# 引数チェック結果
if [ $arg_chk -ne 0 ]; then
    echo "${arg_err}"
    exit 1
fi

# 再フィルタリング対象のメールボックス内のメールを一時避難させる
# 退避先ディレクトリの作成
mbox="$(echo $2 | sed 's|/$||g')" # 末尾にスラッシュがあったら削除する
tmpd="/tmp/$(basename $0)_$(basename ${mbox})_$(date '+%Y%m%d-%H%M%S')"
[ -d "${tmpd}" ] || mkdir "${tmpd}"

# 退避実行
echo "1. mail escape start: ${mbox} to ${tmpd}"
echo "        ${mbox} : $(find ${mbox} -type f | wc -l) files"
echo "        ${tmpd} : $(ls -1 ${tmpd} | wc -l) files"
find "${mbox}" -type f | while read line; do
    mv "${line}" "${tmpd}/"
done
echo "2. mail escape finished"
echo "        ${mbox} : $(find ${mbox} -type f | wc -l) files"
echo "        ${tmpd} : $(ls -1 ${tmpd} | wc -l) files"

# 再フィルタリング実行
echo "3. filtering start"
find "${tmpd}" -type f | while read line; do
    cat "${line}" | maildrop "$1"
done
echo "4. filtering finished: $(find ${mbox} -type f | wc -l) files remained"

# 一時退避先の削除
echo "5. delete ${tmpd} start"
rm -rf "${tmpd}"
echo "6. delete finished"
