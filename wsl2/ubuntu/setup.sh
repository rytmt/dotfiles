#!/bin/sh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# wsl2上のubuntuセットアップ用スクリプト
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - 引数
#   - 第一引数(必須)：セットアップ対象のユーザアカウント
#   - 第二引数(任意)：プロキシサーバのURL
# - スクリプト構成
#   - Global Variables : スクリプトのグローバル変数定義
#   - Static Functions : スクリプトの静的関数定義
#   - Environment Check: セットアップ環境の事前チェック
#   - Script Initialize: 事前チェックを受けたスクリプトの初期化
#   - Dynamic Functions: 事前チェックを受けた関数定義
#   - System Tasks     : rootユーザとしてタスクを実行してセットアップを行う
#   - User Tasks       : セットアップ対象のユーザとしてタスクを実行してセットアップを行う
# - セットアップ内容
#   - apt 設定
#   - パッケージインストール
#   - 時刻同期設定
#   - git clone
#   - git 設定
#   - zsh 設定
#   - vim 設定
#   - screen 設定
# - 備考
#   - 本スクリプトは root ユーザで実行すること
#   - 本スクリプト修正時には冪等性を持たせること
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# ==================================================
# Global Variables
# ==================================================
# Static
ENVCHECK_URL='https://github.com/'
GIT_REPO_DOT='https://github.com/rytmt/dotfiles.git' #dotfiles url
GIT_REPO_DIRCOLOR='https://github.com/seebi/dircolors-solarized.git'
GIT_REPO_ZSH_HIGHLIGHT='https://github.com/zsh-users/zsh-syntax-highlighting.git'
GIT_REPO_VIM_SOLARIZED='https://github.com/altercation/vim-colors-solarized.git'
GIT_REPO_VIM_LOGHIGHLIGHT='https://github.com/mtdl9/vim-log-highlighting'
GIT_UNAME='rytmt' # gitユーザ名
GIT_PUBKEY='id_rsa_github.pub'
GIT_SECKEY='id_rsa_github'
SCRIPT_NAME="$(basename $0)"
DATETIME="$(date '+%Y%m%d-%H%M%S')"
APTCONF='/etc/apt/apt.conf'
CHRONYCONF='/etc/chrony/chrony.conf'
NTPSV='ntp.nict.jp'

# Dynamic
prx_url='' # proxy url
hdir='' # セットアップ対象アカウントのホームディレクトリ
skip_flg=1 # タスクスキップ用フラグ
cnt_ok=0 # 成功タスクカウント用
cnt_ng=0 # 失敗タスクカウント用
cnt_na=0 # 省略タスクカウント用
env_chk=0 # 環境チェック失敗カウント用
env_err='' # 環境チェックエラー文言表示用
curl_ops='' # 疎通確認用curlのオプション
fdl_ops='' # ファイルダウンロード用wgetのオプション
task_sudo='' # タスク実行ユーザ切替用


# ==================================================
# Static Functions
# ==================================================
# 親タスク画面表示関数
# 第一引数(必須)：親タスク名
echo_ptask (){
    echo '=================================================='
    echo " $1"
    echo '=================================================='
}


# ==================================================
# Environment Check
# ==================================================
# 環境チェックに失敗する度にenv_chkをインクリメントし、env_errにエラーメッセージを追加する

# スクリプト引数の個数チェック
if [ $# -ne 2 ] && [ $# -ne 1 ]; then
    env_err="${env_err}引数の個数が正しくありません\n"
    env_chk=$((env_chk+1))
fi

# スクリプト引数の形式確認
# 第一引数が空ではない場合
if [ -n "$1" ]; then
    # 長さは 0 より大きいこと
    if [ ${#1} -le 0 ]; then
        env_err="${env_err}第一引数の形式が正しくありません\n"
        env_chk=$((env_chk+1))
    fi
fi
# 第二引数が空ではない場合
if [ -n "$2" ]; then
    # 第二引数がURLの正規表現と一致しない場合
    if echo "$2" | grep -Eovq '^http://.+:[0-9]{1,5}$'; then
        env_err="${env_err}第二引数の形式が正しくありません\n"
        env_chk=$((env_chk+1))
    else # 一致する場合は prx_url にセット
        prx_url="$2"
    fi
fi

# ユーザアカウントの存在確認
# ユーザ名が指定されている場合のみ実行 (ユーザ名が空だとカレントユーザが取得できてしまう)
if [ -n "$1" ]; then
    id "$1" >/dev/null 2>&1
    if [ "$?" -ne "0" ]; then
        env_err="${env_err}$1 というユーザアカウントは存在しません\n"
        env_chk=$((env_chk+1))
    fi
fi

# ホームディレクトリの存在確認
# ユーザ名が指定されている場合のみ実行 (ユーザ名が空だと全行が出力されてしまう)
if [ -n "$1" ]; then
    hdir="$(grep ^$1 /etc/passwd | cut -d ':' -f 6)"
    if [ ! -d "${hdir}" ]; then
        env_err="${env_err}ユーザ $1 のホームディレクトリ $hdir は存在しません\n"
        env_chk=$((env_chk+1))
    fi
fi

# root ユーザかどうかの確認
if [ "$(id -u)" -ne "0" ]; then
    env_err="${env_err}スクリプトが root アカウントで実行されていません\n"
    env_chk=$((env_chk+1))
fi

# インターネットへの疎通性確認
# プロキシ指定がある場合
if [ -n "${prx_url}" ]; then
    curl_ops="-k --connect-timeout 10 -x $prx_url"
else # プロキシ指定がない場合
    curl_ops='-k --connect-timeout 10'
fi
# 疎通確認実行
curl $curl_ops "${ENVCHECK_URL}" >/dev/null 2>&1
# 疎通確認に失敗した場合
if [ "$?" -ne "0" ]; then
    env_err="${env_err}インターネットへの疎通性がありません\n"
    env_chk=$((env_chk+1))
fi

# 環境チェック結果
# 失敗した場合
if [ $env_chk -ne 0 ]; then
    echo "${env_err}"
    exit 1
else # 成功した場合
    echo "環境チェックに成功しました。セットアップを開始します。"
fi

# ==================================================
# Script Initialize
# ==================================================
usrname="$1" # セットアップ対象のユーザ名
dotfiles="${hdir}/dotfiles/wsl2/ubuntu" # 設定ファイル配置場所
cdir='' # git clone 先のディレクトリ
zdir="${hdir}/.zsh" # zsh設定ファイル配置先ディレクトリ
mdir="${hdir}/.mutt" # neomutt設定ファイル配置先ディレクトリ
vdir="${hdir}/.vim" # vim設定ファイル配置先ディレクトリ
lfile="${hdir}/log/${SCRIPT_NAME}_${DATETIME}.log" # ログファイルフルパス

# セットアップ対象ユーザとしてログファイルを作成しておく
[ -d ${hdir}/log ] || sudo -u "${usrname}" mkdir "${hdir}/log"
sudo -u "${usrname}" touch "${lfile}"


# ==================================================
# Dynamic Functions
# ==================================================
# タスク実行関数
# 第一引数(必須)：タスク名称
# 第二引数(必須)：コマンド文字列 (タスク内容)
# 第三引数(任意)：タスクスキップフラグ (0ならタスクをスキップする)
try_task (){
    # 第三引数の skip_flg が存在し true の場合、タスクは実行せず 0 を返す
    if [ -n "$3" ] && [ "$3" -eq "0" ]; then
        echo "skipped: $2" >> "${lfile}" 2>&1
        echo "[ NA ] $1"
        cnt_na=$((cnt_na+1))
        skip_flg=1 # タスクをスキップしたらフラグは false に戻す
        return 0
    fi

    # タスク名称に <user> が含まれている場合は、$usrname ユーザとしてタスクを実行する
    if echo "$1" | grep -qF '<user>'; then
        task_sudo="sudo -u ${usrname} -i "
    else
        task_sudo=''
    fi

    # skip_flg が false の場合、タスクを実行する
    echo "execute: $task_sudo$2" >> "${lfile}" 2>&1
    eval "$task_sudo$2" >> "${lfile}" 2>&1
    ecode=$?
    # タスクとして実行したコマンドの終了コードが 0 の場合は result に OK をセットして、成功カウント数(cnt_ok)をインクリメント
    if [ "$ecode" -eq "0" ]; then
        result='\e[38;5;40mOK\e[m'
        cnt_ok=$((cnt_ok+1))
    else
        result='\e[1;31mNG\e[m'
        cnt_ng=$((cnt_ng+1))
    fi

    printf "[ ${result} ] $1\n"
    return $ecode
}

# パッケージインストール関数
# 第一引数(必須)：パッケージ名
# 第二引数(任意)：コマンド名
install_pkg (){
    # コマンド名の指定がある場合はコマンドが存在することを確認する
    if [ -n "$2" ]; then
        try_task "$2コマンドが存在することの確認" "type $2"
    else # ない場合はパッケージ名でインストールチェック
        try_task "$1パッケージが存在することの確認" "dpkg -l | grep $1"
    fi
    # 既にパッケージがインストールされている場合はskip_flgをセットしてインストールを省略する
    [ "$?" -eq "0" ] && skip_flg=0
    try_task "$1パッケージのインストール" "apt-get -y install $1" $skip_flg
}

# git clone関数
# 第一引数(必須)：clone対象のURL
# 第二引数(任意)：clone先のディレクトリ
git_clone (){
    # URLからプロジェクト名を取得
    prj_name="$(echo $1 | awk -F '/' '{print $NF}' | cut -d '.' -f 1)"

    # 第二引数がある場合は第二引数のディレクトリ上でプロジェクト名のディレクトリを作成する
    if [ -n "$2" ]; then
        cdir="$2/${prj_name}"
    else # ない場合はホームディレクトリ上でプロジェクト名のディレクトリを作成する
        cdir="${hdir}/${prj_name}"
    fi

    try_task "${prj_name} ディレクトリが存在することを確認 <user>" "test -d ${cdir}"

    # ディレクトリが存在する場合はクローンしない
    [ "$?" -eq "0" ] && skip_flg=0
    try_task "${prj_name} プロジェクトのクローン実行 <user>" "git clone $1 ${cdir}" $skip_flg
}

# シンボリックリンク作成関数
# 第一引数(必須)：リンク元
# 第二引数(必須)：リンク先
ln_s (){
    try_task "シンボリックリンク $2 が存在することの確認 <user>" "test -h $2"

    # シンボリックリンクが既に存在する場合はリンクを作成しない
    [ "$?" -eq "0" ] && skip_flg=0
    try_task "シンボリックリンク $2 の作成 <user>" "ln -s $1 $2" $skip_flg
}

# ファイルダウンロード関数
# 第一引数(必須)：ダウンロード先URL
fdl (){
    # プロキシ指定がある場合はオプションを追加
    if [ -n "${prx_url}" ]; then
        fdl_ops="-e HTTP_PROXY=$(echo ${prx_url} | cut -d '/' -f 3)"
    fi
    # ファイルダウンロード実行
    try_task "ファイルダウンロード ($1) <user>" "wget ${fdl_ops} $1"
}

# ディレクトリ作成関数
# 第一引数(必須)：ディレクトリ用途
# 第二引数(必須)：ディレクトリパス
mkd (){
    try_task "$1 用フォルダが存在することの確認 <user>" "test -d $2"

    # 既にフォルダがある場合は何もしない
    [ "$?" -eq "0" ] && skip_flg=0
    try_task "$1 用フォルダ作成 <user>" "mkdir $2" $skip_flg
}


# ==================================================
# System Tasks
# ==================================================
# ----------
# apt
# ----------
echo_ptask 'aptセットアップ'

try_task "${APTCONF} ファイルが存在することの確認" "test -f ${APTCONF}"

# 既に apt 設定ファイルが存在する場合はskip_flgをセットして設定ファイル作成を省略する
[ "$?" -eq "0" ] && skip_flg=0
try_task "${APTCONF} ファイルの作成" "touch ${APTCONF}" $skip_flg

# プロキシ指定がある場合はプロキシの設定をする
if [ -n "${prx_url}" ]; then
    # HTTPプロキシ設定
    http_proxy_line="Acquire::http::Proxy \"${prx_url}\";"
    # 既にプロキシ設定がある場合はスキップ
    if grep -q "${http_proxy_line}" ${APTCONF}; then
        skip_flg=0
    fi
    try_task 'aptプロキシ設定 (http)' "echo '${http_proxy_line}' >> ${APTCONF}" $skip_flg

    # HTTPSプロキシ設定
    https_proxy_line="Acquire::https::Proxy \"${prx_url}\";"
    # 既にプロキシ設定がある場合はスキップ
    if grep -q "${https_proxy_line}" ${APTCONF}; then
        skip_flg=0
    fi
    try_task 'aptプロキシ設定 (https)' "echo '${https_proxy_line}' >> ${APTCONF}" $skip_flg
fi


# ----------
# packages
# ----------
echo_ptask 'パッケージインストール'

# パッケージインストールタスクは install_pkg 関数で行う
# 引数にはパッケージ名、コマンド名の順番で指定する (コマンド名は任意)
install_pkg 'git' 'git'
install_pkg 'zsh' 'zsh'
install_pkg 'screen' 'screen'
install_pkg 'peco' 'peco'
install_pkg 'chrony' 'chronyc'
install_pkg 'neomutt' 'neomutt'
install_pkg 'fetchmail' 'fetchmail'
install_pkg 'maildrop' 'maildrop'
install_pkg 'source-highlight'


# ----------
# Chrony
# ----------
echo_ptask '時刻同期設定'

try_task '不要設定の削除' "sed -i -e '/^pool/d' ${CHRONYCONF}"
try_task '時刻同期設定の追加' "echo 'pool ${NTPSV} iburst' >> ${CHRONYCONF}"
try_task 'chronydの起動' 'service chrony restart'
# try_task 'chronydの自動起動設定'

# ==================================================
# User Tasks
# ==================================================
# セットアップ対象のユーザとしてタスクを実行する場合は <user> をタスク名称に含める
# <user> が含まれない場合、root ユーザとしてタスクが実行される

# ----------
# git
# ----------
echo_ptask 'gitセットアップ'

try_task 'Gitユーザ設定 <user>' "git config --global user.name ${GIT_UNAME}"
try_task 'Gitエディタ設定 <user>' "git config --global core.editor vim"
try_task 'Git色設定(diff) <user>' 'git config --global color.diff auto'
try_task 'Git色設定(status) <user>' 'git config --global color.status auto'
try_task 'Git色設定(branch) <user>' 'git config --global color.branch auto'
try_task 'Gitグラフ設定 <user>' 'git config --global alias.graph "log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit --date=relative"'

try_task 'Git公開鍵確認 (要手動配置) <user>' "test -f ${hdir}/.ssh/${GIT_PUBKEY}"
try_task 'Git秘密鍵確認 (要手動配置) <user>' "test -f ${hdir}/.ssh/${GIT_SECKEY}"

# プロキシ指定がある場合はプロキシの設定をする
if [ -n "${prx_url}" ]; then
    try_task 'Gitプロキシ設定 <user>' "git config --global http.proxy ${prx_url}"
fi


# ----------
# Git Clone
# ----------
echo_ptask 'Git Clone'

# git clone タスクは git_clone 関数で行う
git_clone "${GIT_REPO_DOT}" # dotfiles
git_clone "${GIT_REPO_DIRCOLOR}" # ls dircolor


# ----------
# screen
# ----------
echo_ptask 'screenセットアップ'

# シンボリックリンク作成
ln_s "${dotfiles}/.screenrc" "${hdir}/.screenrc"

# /run/screen を 777 にしないと screen が起動しないことがある
try_task '/run/screen の権限変更' 'chmod 777 /run/screen'


# ----------
# zsh
# ----------
echo_ptask 'zshセットアップ'

mkd 'zsh' "${zdir}" # ディレクトリ作成

# シンボリックリンク作成
ln_s "${dotfiles}/.zshrc" "${hdir}/.zshrc"
ln_s "${dotfiles}/.zsh/peco.zsh" "${zdir}/peco.zsh"

# ハイライト設定のダウンロード
git_clone "${GIT_REPO_ZSH_HIGHLIGHT}" "${zdir}"

try_task 'デフォルトのシェルをzshに変更' "chsh -s /bin/zsh ${usrname}"


# ----------
# vim
# ----------
echo_ptask 'vimセットアップ'

# ディレクトリ作成
mkd 'vim' "${vdir}"
mkd 'vim colorscheme' "${vdir}/colors"
mkd 'vim backup' "${vdir}/backup"
mkd 'vim undo' "${vdir}/undo"
mkd 'vim swp' "${vdir}/swp"

# カラースキーマのダウンロード・コピー
git_clone "${GIT_REPO_VIM_SOLARIZED}" "${vdir}"
try_task 'カラースキーマファイルのコピー <user>' "cp -p ${vdir}/vim-colors-solarized/colors/solarized.vim ${vdir}/colors/"

# シンボリックリンク作成
ln_s "${dotfiles}/.vimrc" "${hdir}/.vimrc"

# ログファイルのハイライト
git_clone "${GIT_REPO_VIM_LOGHIGHLIGHT}" "${vdir}"
try_task 'vim-log-highlighting設定ファイルコピー(ftdetect) <user>' "cp -rp ${vdir}/vim-log-highlighting/ftdetect ${vdir}/"
try_task 'vim-log-highlighting設定ファイルコピー(syntax) <user>' "cp -rp ${vdir}/vim-log-highlighting/syntax ${vdir}/"


# ----------
# neomutt
# ----------
echo_ptask 'neomuttセットアップ'

# ディレクトリ作成
mkd 'neomutt' "${mdir}"
mkd 'mail受信' "${hdir}/mail"


# ----------
# setup result
# ----------
echo_ptask 'セットアップ結果'
echo "OK: ${cnt_ok} 件"
echo "NG: ${cnt_ng} 件"
echo "NA: ${cnt_na} 件"
echo "セットアップログファイル: ${lfile}"
echo '=================================================='