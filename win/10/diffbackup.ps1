# 差分バックアップ用スクリプト

# タスクスケジューラに登録する場合のパラメータ
#    プログラム/スクリプト: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
#    引数の追加           : -Command "<スクリプトのパス>\diffbackup.ps1"
#    開始                 : 指定なし

# バックアップ元とバックアップ先のドライブの定義
$SRCDRIVE = "E"
$DSTDRIVE = "D"

# バックアップログの保存先
$bkfile = "${SRCDRIVE}:\backuplog\$(Split-Path -Leaf $PSCommandPath)_$(Get-Date -Format yyyyMMdd).log"

# バックアップ元のディレクトリ内のフォルダ一覧を取得
$bkdirs = Get-ChildItem "${SRCDRIVE}:\"

# バックアップ元の各フォルダをコピーしていく
foreach ( $dir in $bkdirs ){

    $srcdir = "${SRCDRIVE}:\${dir}"
    $dstdir = "${DSTDRIVE}:\${dir}"

    robocopy $srcdir $dstdir /COPY:DATO /R:1 "/LOG+:${bkfile}" /NP /NFL /NDL

}
