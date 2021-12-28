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
echo "escape start: ${mbox} to ${tmpd}"
find "${mbox}" -type f | while read line; do
    mv "${line}" "${tmpd}/"
done

# 再フィルタリング実行
echo "filtering start: $(ls -1 ${tmpd} | wc -l) files detected"
find "${tmpd}" -type f | while read line; do
    cat "${line}" | maildrop "$1"
done
echo "filtering finished: $(ls -1 ${mbox} | wc -l) files remained"

# 一時退避先の削除
echo "delete ${tmpd} start"
rm -rf "${tmpd}"
echo "delete finished"
