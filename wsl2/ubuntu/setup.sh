#!/bin/sh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# wsl2上のubuntuセットアップ用スクリプト
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - 引数
#   - 第一引数(必須)：セットアップ対象のユーザアカウント
#   - 第二引数(任意)：プロキシサーバのURL (例: http://proxy.local:8080)
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
#GIT_REPO_DIRCOLOR='https://github.com/seebi/dircolors-solarized.git'
GIT_REPO_ZSH_HIGHLIGHT='https://github.com/zsh-users/zsh-syntax-highlighting.git'
GIT_REPO_ZSH_AUTOSUGGEST='https://github.com/zsh-users/zsh-autosuggestions.git'
GIT_REPO_ZSH_P10K='https://github.com/romkatv/powerlevel10k.git'
#GIT_REPO_VIM_SOLARIZED='https://github.com/altercation/vim-colors-solarized.git'
#GIT_REPO_VIM_GRUVBOX='https://github.com/morhetz/gruvbox.git'
GIT_REPO_VIM_GRUVBOX_MATERIAL='https://github.com/sainnhe/gruvbox-material.git'
GIT_REPO_VIM_LOGHIGHLIGHT='https://github.com/mtdl9/vim-log-highlighting.git'
#GIT_REPO_NEOMUTT_SOLARIZED='https://github.com/altercation/mutt-colors-solarized.git'
#GIT_REPO_NEOMUTT_GRUVBOX='https://git.sthu.org/repos/mutt-gruvbox.git'
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
cnt_tsk=0 # タスク数カウント用
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
    export https_proxy=${prx_url}
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
bdir="${hdir}/bin" # バイナリ配置先ディレクトリ
sdir="${hdir}/.ssh/conf.d" # ssh用設定ファイル配置先ディレクトリ
lfile="${hdir}/log/${SCRIPT_NAME}_${DATETIME}.log" # ログファイルフルパス
usrcron="/var/spool/cron/crontabs/${usrname}" #ユーザのcronファイル

# セットアップ対象ユーザとしてログファイルを作成しておく
[ -d ${hdir}/log ] || sudo -u "${usrname}" mkdir "${hdir}/log"
sudo -u "${usrname}" touch "${lfile}"


# ==================================================
# Dynamic Functions
# ==================================================
# タスク実行関数
# オプション    ：-u (セットアップ対象のユーザとしてタスクを実行する)
# 第一引数(必須)：タスク名称
# 第二引数(必須)：コマンド文字列 (タスク内容)
try_task (){
    # タスクのカウントをインクリメント
    cnt_tsk=$((cnt_tsk+1))

    # 第一引数が -u の場合、$usrname ユーザとしてタスクを実行する
    if echo "$1" | grep -qE '^-u$'; then
        task_sudo="sudo -u ${usrname} -i "
        task_usr=" (user: ${usrname})"
        shift
    else
        task_sudo=''
        task_usr=" (user: \e[38;5;207mroot\e[m)" #紫色
    fi

    # skip_flg が true の場合、タスクは実行せず 0 を返す
    if [ "${skip_flg}" -eq "0" ]; then
        echo "skipped: $2" >> "${lfile}" 2>&1
        printf "\e[38;5;242m[ NA ] ${cnt_tsk}. $1${task_usr}\e[m \n" #灰色
        #echo "[ NA ] ${cnt_tsk}. $1${task_usr}"
        cnt_na=$((cnt_na+1))
        skip_flg=1 # タスクをスキップしたらフラグは false に戻す
        return 0
    fi

    # skip_flg が false の場合、タスクを実行する
    echo "execute${task_usr}: $task_sudo$2" >> "${lfile}" 2>&1
    eval "$task_sudo$2" >> "${lfile}" 2>&1
    ecode=$?
    # タスクとして実行したコマンドの終了コードが 0 の場合は result に OK をセットして、成功カウント数(cnt_ok)をインクリメント
    if [ "$ecode" -eq "0" ]; then
        result='\e[38;5;40mOK\e[m' #緑色
        cnt_ok=$((cnt_ok+1))
    else
        result='\e[1;31mNG\e[m' #赤色
        cnt_ng=$((cnt_ng+1))
    fi

    printf "[ ${result} ] ${cnt_tsk}. $1${task_usr}\n"
    return $ecode
}

# try_task 関数のラップ関数
# 引数はすべて try_task に渡す
# try_task が正常終了した場合、skip_flg を true にする
check_task (){
    try_task "$@"
    [ "$?" -eq "0" ] && skip_flg=0
}

# パッケージインストール関数
# 第一引数(必須)：パッケージ名
# 第二引数(任意)：コマンド名
install_pkg (){
    # コマンド名の指定がある場合はコマンドが存在することを確認する
    if [ -n "$2" ]; then
        check_task "$2コマンドが存在することの確認" "type $2"
    else # ない場合はパッケージ名でインストールチェック
        check_task "$1パッケージが存在することの確認" "dpkg -l | grep $1"
    fi
    try_task "$1パッケージのインストール" "apt-get -y install $1"
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

    check_task -u "${prj_name} ディレクトリが存在することを確認" "test -d ${cdir}"
    try_task -u "${prj_name} プロジェクトのクローン実行" "git clone --depth 1 $1 ${cdir}"
}

# シンボリックリンク作成関数
# 第一引数(必須)：リンク元
# 第二引数(必須)：リンク先
ln_s (){
    check_task -u "シンボリックリンク $2 が存在することの確認" "test -h $2"
    try_task -u "シンボリックリンク $2 の作成" "ln -s $1 $2"
}

# ファイルダウンロード関数
# 第一引数(必須)：ダウンロード先URL
fdl (){
    # プロキシ指定がある場合はオプションを追加
    if [ -n "${prx_url}" ]; then
        fdl_ops="-e HTTPS_PROXY=$(echo ${prx_url} | cut -d '/' -f 3)"
    fi
    # 第一引数が -u の場合、$usrname ユーザとしてタスクを実行する
    uflg=''
    if echo "$1" | grep -qE '^-u$'; then
        uflg='-u'
        shift
    fi
    # ファイルダウンロード実行
    try_task ${uflg} "ファイルダウンロード ($1)" "wget ${fdl_ops} $1"
}

# ディレクトリ作成関数
# 第一引数(必須)：ディレクトリ用途
# 第二引数(必須)：ディレクトリパス
mkd (){
    # 第一引数が -u の場合、$usrname ユーザとしてタスクを実行する
    uflg=''
    if echo "$1" | grep -qE '^-u$'; then
        uflg='-u'
        shift
    fi
    check_task ${uflg} "$1 用フォルダが存在することの確認" "test -d $2"
    try_task ${uflg} "$1 用フォルダ作成" "mkdir -p $2"
}

# ファイルコピー関数
# 第一引数(必須)：コピー元
# 第二引数(必須)：コピー先
fcp (){
    check_task "$2 が存在することの確認" "test -f $2"
    try_task "$1 から $2 へのコピー" "cp -pf $1 $2"
}


# ==================================================
# System Tasks
# ==================================================
# ----------
# curl
# ----------
echo_ptask 'curlセットアップ'
if [ -n "${prx_url}" ]; then
    check_task '.curlrc ファイルが存在することの確認' 'test -f /root/.curlrc'
    try_task '.curlrc ファイルの作成' "echo proxy=${prx_url} >>/root/.curlrc"

    check_task -u '.curlrc ファイルが存在することの確認' "test -f ${hdir}/.curlrc"
    try_task -u '.curlrc ファイルの作成' "echo proxy=${prx_url} >>${hdir}/.curlrc"
fi


# ----------
# apt
# ----------
echo_ptask 'aptセットアップ'

check_task "${APTCONF} ファイルが存在することの確認" "test -f ${APTCONF}"
try_task "${APTCONF} ファイルの作成" "touch ${APTCONF}"

# プロキシ指定がある場合はプロキシの設定をする
if [ -n "${prx_url}" ]; then
    # HTTPプロキシ設定
    http_proxy_line="Acquire::http::Proxy \"${prx_url}\";"
    check_task 'aptプロキシ設定(http)が存在することの確認' "grep -qF 'Acquire::http::Proxy' ${APTCONF}"
    try_task 'aptプロキシ設定(http)' "echo '${http_proxy_line}' >> ${APTCONF}"

    # HTTPSプロキシ設定
    https_proxy_line="Acquire::https::Proxy \"${prx_url}\";"
    check_task 'aptプロキシ設定(https)が存在することの確認' "grep -qF 'Acquire::https::Proxy' ${APTCONF}"
    try_task 'aptプロキシ設定 (https)' "echo '${https_proxy_line}' >> ${APTCONF}"
fi

try_task 'apt updateの実行' 'apt update'


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
install_pkg 'notmuch' 'notmuch'
install_pkg 'source-highlight'
#install_pkg 'tree' 'tree'
install_pkg 'nkf' 'nkf'
install_pkg 'lynx' 'lynx'
install_pkg 'golang-go'
install_pkg 'ldap-utils'
install_pkg 'zip' 'zip'
install_pkg 'jq' 'jq'
install_pkg 'libxml2-utils'
install_pkg 'hexyl' 'hexyl'
install_pkg 'fd-find' 'fdfind'
install_pkg 'python3-pip'
install_pkg 'pwgen' 'pwgen'
install_pkg 'ranger' 'ranger'
install_pkg 'highlight' 'highlight'
install_pkg 'traceroute' 'traceroute'
install_pkg 'ipcalc' 'ipcalc'
install_pkg 'dateutils'
install_pkg 'rename' 'rename'
install_pkg 'xlsx2csv' 'xlsx2csv'
install_pkg 'ffmpeg' 'ffmpeg'


# ----------
# Chrony
# ----------
echo_ptask '時刻同期設定'

try_task '不要設定の削除' "sed -i -e '/^pool/d' ${CHRONYCONF}"
try_task '時刻同期設定の追加' "echo 'pool ${NTPSV} iburst' >> ${CHRONYCONF}"
try_task 'chronydの再起動' 'service chrony restart'


# ----------
# Cron
# ----------
echo_ptask 'cron設定'
check_task 'cronが起動していることの確認' 'service cron status'
try_task 'cronの起動' 'service cron start'
check_task 'cron再起動タスクが存在することの確認' "grep -Fq 'service cron restart' /etc/crontab"
try_task 'cron再起動タスク登録' "echo '0 0 * * * root service cron restart' >> /etc/crontab"


# ----------
# Init Script
# ----------
echo_ptask 'initscript設定'
check_task 'fstab設定が存在することの確認' "grep -Fq 'none none rc defaults 0 0' /etc/fstab"
try_task "fstabに設定を追加" "echo 'none none rc defaults 0 0' >>/etc/fstab"

mountrc='#!/bin/sh\n\n'
mountrc="${mountrc}service crony start\n"
mountrc="${mountrc}service cron start\n"
mountrc="${mountrc}service docker start\n"
mountrc="${mountrc}[ -d /run/screen ] || mkdir /run/screen\n"
mountrc="${mountrc}chmod 777 /run/screen\n"
check_task '/sbin/mount.rc が存在することの確認' 'test -f /sbin/mount.rc'
try_task '/sbin/mount.rc の作成' "echo -e \"${mountrc}\" >/sbin/mount.rc && chmod +x /sbin/mount.rc"


# ----------
# sudoers
# ----------
echo_ptask 'sudoers設定'
check_task 'sudoers設定が存在することの確認' "test -f /etc/sudoers.d/${usrname}"
try_task 'sudoers設定の追加' "echo '${usrname} ALL=NOPASSWD: ALL' > /etc/sudoers.d/${usrname}"


# ----------
# exa
# ----------
# ubuntu 20.10 以降は apt get exa でインストールできるらしい
echo_ptask 'exa設定'
manual_install_exa (){
    # ダウンロード
    fdl 'https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip'
    # 解凍
    try_task 'exaの解凍' 'unzip exa-linux-x86_64-v0.10.1.zip'
    # ファイル移動
    try_task 'ファイル移動(bin)' 'mv ./bin/exa /usr/local/bin/'
    try_task 'ファイル移動(man.1)' 'mv ./man/exa.1 /usr/share/man/man1/'
    try_task 'ファイル移動(man.5)' 'mv ./man/exa_colors.5 /usr/share/man/man5/'

}
check_task 'exaコマンドが存在することの確認' 'type exa'

try_task 'exaの手動インストール' 'manual_install_exa'


# ==================================================
# User Tasks
# ==================================================
# セットアップ対象のユーザアカウントとしてタスクを実行するには、try_task に -u オプションを付ける

# ----------
# General
# ----------
echo_ptask '基本設定'

mkd -u 'バイナリ置き場' "${bdir}"

# スクリプトのシンボリックリンク作成
ln_s "${dotfiles}/bin/rsbk.sh" "${bdir}/rsbk.sh"
ln_s "${dotfiles}/bin/sum.sh" "${bdir}/sum.sh"
ln_s "${dotfiles}/bin/timer.sh" "${bdir}/timer.sh"

# -----
# go get が正常動作しないのでコメントアウト
# -----
#check_task -u 'powerline-goバイナリファイルがあることの確認' "test -f ${hdir}/go/bin/powerline-go"
## プロキシ指定がある場合
#if [ -n "${prx_url}" ]; then
#    try_task -u 'powerline-goバイナリファイルのダウンロード' "http_proxy=${prx_url} go get -u github.com/justjanne/powerline-go"
#else
#    try_task -u 'powerline-goバイナリファイルのダウンロード' 'go get -u github.com/justjanne/powerline-go'
#fi

#check_task -u 'pupバイナリファイルがあることの確認' "test -f ${hdir}/go/bin/pup"
## プロキシ指定がある場合
#if [ -n "${prx_url}" ]; then
#    try_task -u 'pupバイナリファイルのダウンロード' "http_proxy=${prx_url} go get -u github.com/ericchiang/pup"
#else
#    try_task -u 'pupバイナリファイルのダウンロード' 'go get -u github.com/ericchiang/pup'
#fi

# dircolors のシンボリックリンク作成
ln_s  "${dotfiles}/.dircolors_gruvbox" "${hdir}/.dircolors_gruvbox"


# ----------
# ssh
# ----------
echo_ptask 'sshセットアップ'

mkd -u 'SSH設定ファイル置き場' "${sdir}"

# 設定ファイルのシンボリックリンク作成
ln_s "${dotfiles}/screen_ssh" "${sdir}/screen_ssh"

check_task -u 'Include設定があることの確認' "grep 'Include conf.d' ${hdir}/.ssh/config"
try_task -u 'Include設定の追加' "echo -e 'Host *\n    Include conf.d/*\n' >> ${hdir}/.ssh/config"

# ----------
# wget
# ----------
echo_ptask 'wgetセットアップ'

# プロキシ指定がある場合
if [ -n "${prx_url}" ]; then
    check_task -u 'プロキシ設定があることの確認' "grep '^http_proxy' ${hdir}/.wgetrc"
    try_task -u "プロキシ設定の追加" "echo -e \"http_proxy=${prx_url}\nhttps_proxy=${prx_url}\" >> ${hdir}/.wgetrc"
fi

# ----------
# git
# ----------
echo_ptask 'gitセットアップ'

#try_task -u 'Gitユーザ設定' "git config --global user.name ${GIT_UNAME}"
try_task -u 'Gitエディタ設定' "git config --global core.editor vim"
try_task -u 'Git色設定(diff)' 'git config --global color.diff auto'
try_task -u 'Git色設定(status)' 'git config --global color.status auto'
try_task -u 'Git色設定(branch)' 'git config --global color.branch auto'
try_task -u 'Gitグラフ設定' 'git config --global alias.graph "log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit --date=relative"'
try_task -u 'Git merge設定(ff)' 'git config --global merge.ff false'
try_task -u 'Git pull設定(ff)' 'git config --global pull.ff only'

try_task -u 'Git公開鍵確認 (要手動配置)' "test -f ${hdir}/.ssh/${GIT_PUBKEY}"
try_task -u 'Git秘密鍵確認 (要手動配置)' "test -f ${hdir}/.ssh/${GIT_SECKEY}"

# プロキシ指定がある場合はプロキシの設定をする
if [ -n "${prx_url}" ]; then
    try_task -u 'Gitプロキシ設定' "git config --global http.proxy ${prx_url}"
fi


# ----------
# Git Clone
# ----------
echo_ptask 'Git Clone'

# git clone タスクは git_clone 関数で行う
git_clone "${GIT_REPO_DOT}" # dotfiles
#git_clone "${GIT_REPO_DIRCOLOR}" # ls dircolor

# dotfiles のリポジトリに対してユーザ名とメールアドレスを設定する
check_task 'dotfilesリポジトリ ユーザ設定確認' "grep -F 'name = rytmt' ${hdir}/dotfiles/.git/config"
try_task 'dotfilesリポジトリ ユーザ設定の実行' "echo -e '[user]\n        name = rytmt\n        email = rytmt@nxdomain.local' >>${hdir}/dotfiles/.git/config"


# ----------
# python-pip
# ----------
echo_ptask 'python-pipセットアップ'
# プロキシ指定がある場合
if [ -n "${prx_url}" ]; then
    if [ ! -f ${hdir}/.pip/pip.conf ]; then
        try_task -u '~/.pipフォルダの作成' "mkdir ${hdir}/.pip"
        try_task -u '~/.pip/pip.confファイルの作成' "touch ${hdir}/.pip/pip.conf"
        try_task -u '~/.pip/pip.confファイルへの設定' "echo -e '[global]\nproxy = ${prx_url}' >${hdir}/.pip/pip.conf"
    fi
fi


# ----------
# screen
# ----------
echo_ptask 'screenセットアップ'

# ログ保存用フォルダの作成
[ -d ${hdir}/log/screen ] || sudo -u "${usrname}" mkdir "${hdir}/log/screen"

# シンボリックリンク作成
ln_s "${dotfiles}/.screenrc" "${hdir}/.screenrc"

# /run/screen を 777 にしないと screen が起動しないことがある
try_task '/run/screen の権限変更' 'chmod 777 /run/screen'

# vbell用スクリプトのシンボリックリンク作成
ln_s "${dotfiles}/bin/vbell_beyond_screen.sh" "${bdir}/vbell_beyond_screen.sh"

# ログ削除コマンドのcron登録
check_task "ログ削除コマンドの登録確認" "grep -Fq \"${hdir}/log/screen\" ${usrcron}"
try_task "ログ削除コマンドの登録" "echo \"* 4 * * * find ${hdir}/log/screen -type f -mtime +30 | while read oldfile; do rm -f \"\\\${oldfile}\" >/dev/null 2>&1; done\" >>${usrcron}"


# ----------
# zsh
# ----------
echo_ptask 'zshセットアップ'

mkd -u 'zsh' "${zdir}" # ディレクトリ作成

# シンボリックリンク作成
ln_s "${dotfiles}/.zshrc" "${hdir}/.zshrc"
ln_s "${dotfiles}/.zsh/peco.zsh" "${zdir}/peco.zsh"
ln_s "${dotfiles}/.zsh/.p10k.zsh" "${zdir}/.p10k.zsh"

# ハイライト設定のダウンロード
git_clone "${GIT_REPO_ZSH_HIGHLIGHT}" "${zdir}"

# 入力補助設定のダウンロード
git_clone "${GIT_REPO_ZSH_AUTOSUGGEST}" "${zdir}"

# powerline設定のダウンロード
git_clone "${GIT_REPO_ZSH_P10K}" "${zdir}"

try_task 'デフォルトのシェルをzshに変更' "chsh -s /bin/zsh ${usrname}"


# ----------
# vim
# ----------
echo_ptask 'vimセットアップ'

# ディレクトリ作成
mkd -u 'vim' "${vdir}"
mkd -u 'vim colorscheme' "${vdir}/colors"
mkd -u 'vim autoload' "${vdir}/autoload"
mkd -u 'vim backup' "${vdir}/backup"
mkd -u 'vim undo' "${vdir}/undo"
mkd -u 'vim swp' "${vdir}/swp"

# カラースキーマのダウンロード・コピー
#git_clone "${GIT_REPO_VIM_SOLARIZED}" "${vdir}"
#try_task -u 'カラースキーマファイルのコピー' "cp -p ${vdir}/vim-colors-solarized/colors/solarized.vim ${vdir}/colors/"
#git_clone "${GIT_REPO_VIM_GRUVBOX}" "${vdir}"
#try_task -u 'カラースキーマファイルのコピー' "cp -p ${vdir}/gruvbox/colors/gruvbox.vim ${vdir}/colors/"
git_clone "${GIT_REPO_VIM_GRUVBOX_MATERIAL}" "${vdir}"
try_task -u 'カラースキーマファイルのコピー (colors)' "cp -p ${vdir}/gruvbox-material/colors/gruvbox-material.vim ${vdir}/colors/"
try_task -u 'カラースキーマファイルのコピー (autoload)' "cp -p ${vdir}/gruvbox-material/autoload/gruvbox_material.vim ${vdir}/autoload/"

# プラグインインストール
check_task 'プラグインチェック (vim-polyglot)' "test -d ${vdir}/pack/plugins/start/vim-polyglot"
try_task -u 'プラグインインストール (vim-polyglot)' "git clone --depth 1 https://github.com/sheerun/vim-polyglot ${vdir}/pack/plugins/start/vim-polyglot"
check_task 'プラグインチェック (vim-airline)' "test -d ${vdir}/pack/plugins/start/vim-airline"
try_task -u 'プラグインインストール (vim-airline)' "git clone --depth 1 https://github.com/vim-airline/vim-airline.git ${vdir}/pack/plugins/start/vim-airline"
check_task 'プラグインチェック (indentLine)' "test -d ${vdir}/pack/plugins/start/indentLine"
try_task -u 'プラグインインストール (indentLine)' "git clone --depth 1 https://github.com/Yggdroot/indentLine.git  ${vdir}/pack/plugins/start/indentLine"

# シンボリックリンク作成
ln_s "${dotfiles}/.vimrc" "${hdir}/.vimrc"

# ログファイルのハイライト
git_clone "${GIT_REPO_VIM_LOGHIGHLIGHT}" "${vdir}"
try_task -u 'vim-log-highlighting設定ファイルコピー(ftdetect)' "cp -rp ${vdir}/vim-log-highlighting/ftdetect ${vdir}/"
try_task -u 'vim-log-highlighting設定ファイルコピー(syntax)' "cp -rp ${vdir}/vim-log-highlighting/syntax ${vdir}/"


# ----------
# neomutt
# ----------
echo_ptask 'neomuttセットアップ'

# ディレクトリ作成
mkd -u 'neomutt' "${mdir}"
mkd -u 'mail受信' "${hdir}/mail"
mkd -u 'キャッシュ' "${mdir}/mcache"

# シンボリックリンク作成
ln_s "${dotfiles}/.muttrc" "${hdir}/.muttrc"
ln_s "${dotfiles}/bin/mf2md.sh" "${bdir}/mf2md.sh"
ln_s "${dotfiles}/bin/re-filter.sh" "${bdir}/re-filter.sh"
ln_s "${dotfiles}/bin/ical2txt.sh" "${bdir}/ical2txt.sh"

# カラースキーマインストール
#git_clone "${GIT_REPO_NEOMUTT_SOLARIZED}" "${mdir}"
#git_clone "${GIT_REPO_NEOMUTT_GRUVBOX}" "${mdir}"


# ----------
# Rust
# ----------
#echo_ptask 'rustセットアップ'
#
## インストール用のスクリプトダウンロード
#fdl -u 'https://sh.rustup.rs -O sh.rustup.rs.sh'
#try_task -u 'スクリプトに実行権限を付与' 'chmod +x sh.rustup.rs.sh'
#
#check_task -u 'rustがインストールされていることを確認' "type cargo"
#if [ -n "${prx_url}" ]; then
#    try_task -u 'rustインストール実行' "https_proxy=${prx_url} ./sh.rustup.rs.sh -q -y"
#else
#    try_task -u 'rustインストール実行' "./sh.rustup.rs.sh -q -y"
#fi
#try_task -u '環境設定' "source ${hdir}/.cargo/env"
#try_task -u 'piprインストール' 'cargo install pipr'


# ----------
# Docker
# ----------
echo_ptask 'dockerセットアップ'
# official reference: https://docs.docker.com/engine/install/ubuntu/

# docker インストール用関数
docker_install(){
    # 依存パッケージのインストール
    install_pkg 'ca-certificates'
    install_pkg 'gnupg'
    install_pkg 'lsb-release'
    install_pkg 'curl' 'curl'

    # GPG鍵の追加
    mkd 'GPG鍵' '/etc/apt/keyrings'
    check_task 'GPG鍵が存在することの確認' 'test -f /etc/apt/keyrings/docker.gpg'
    try_task 'GPG鍵のダウンロード' \
     "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg"

    # リポジトリのセットアップ
    docker_repo_setup='echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null'
    try_task 'リポジトリのセットアップ' "${docker_repo_setup}"

    # Docker Engine のインストール
    try_task 'apt updateの実行' 'apt update'
    install_pkg 'docker-ce'
    install_pkg 'docker-ce-cli'
    install_pkg 'containerd.io'
    install_pkg 'docker-compose-plugin'

}

check_task 'dockerがインストールされていることの確認' 'type docker'
try_task 'dockerのインストール' 'docker_install'

# プロキシ指定がある場合
if [ -n "${prx_url}" ]; then
    proxy_setting="$(cat <<EOS
export http_proxy='${prx_url}'
export https_proxy='${prx_url}'
EOS
    )"
    check_task 'dockerプロキシ設定が存在することの確認' "grep -Eq '^export https?_proxy' /etc/default/docker"
    try_task 'dockerプロキシ設定' "echo \"${proxy_setting}\" >> /etc/default/docker"
fi

try_task "dockerグループへの${usrname}ユーザの追加" "usermod -aG docker ${usrname}"

check_task 'dockerが起動していることの確認' 'service docker status'
try_task 'dockerの起動' 'service docker start'



# ----------
# PowerShell
# ----------
# 参考: https://learn.microsoft.com/ja-jp/powershell/scripting/install/install-ubuntu
powershell_install(){
    fdl "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
    try_task 'Microsoftのリポジトリを登録' 'dpkg -i packages-microsoft-prod.deb'
    try_task 'apt updateの実行' 'apt update'
    install_pkg 'powershell' 'pwsh'
}

check_task 'powershellがインストールされていることの確認' 'type pwsh'
try_task 'powershellのインストール' 'powershell_install'


# ----------
# Node.js
# ----------
# おそらくnvmのインストールに使用したシェル(.xxshrcファイル)に環境変数が追加される。スクリプト化が難しいので諦める。
#echo_ptask 'node.jsセットアップ'
#
## nvm インストール用関数
#nvm_install(){
#    nvm_installcmd="$(curl https://github.com/nvm-sh/nvm 2>/dev/null | grep -Po 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v[0-9.]+/install.sh \| bash' | sort | uniq)"
#    nvm_installcmd_flg="$(echo ${nvm_installcmd} | grep ^curl | wc -l)"
#
#    if [ ${nvm_installcmd_flg} -ne 1 ]; then
#        return 1
#    fi
#
#    try_task -u 'nvmインストールスクリプトの実行' "${nvm_installcmd}"
#    return $?
#}
#
#check_task -u 'nvmがインストールされていることの確認' 'type nvm'
#try_task 'nvmのインストール' 'nvm_install'


# ----------
# setup result
# ----------
echo_ptask 'セットアップ結果'
echo "Total: ${cnt_tsk} 件"
echo "   OK: ${cnt_ok} 件"
echo "   NG: ${cnt_ng} 件"
echo "   NA: ${cnt_na} 件"
echo "セットアップログファイル: ${lfile}"
echo '=================================================='
