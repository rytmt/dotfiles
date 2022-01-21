# 1. ubuntu on wsl2 セットアップ

- [1. ubuntu on wsl2 セットアップ](#1-ubuntu-on-wsl2-セットアップ)
  - [1.1. setup.sh](#11-setupsh)
  - [1.2. neomutt セットアップ](#12-neomutt-セットアップ)
    - [1.2.1. ファイル構成](#121-ファイル構成)
    - [1.2.2. 手動作成ファイルの作成手順](#122-手動作成ファイルの作成手順)
      - [1.2.2.1. ~/.mutt/account](#1221-muttaccount)
      - [1.2.2.2. ~/.mutt/signature_default, internal](#1222-muttsignature_default-internal)
      - [1.2.2.3. ~/.fetchmailrc](#1223-fetchmailrc)
      - [1.2.2.4. ~/.mailfilter](#1224-mailfilter)
    - [1.2.3. メールフィルタのテスト](#123-メールフィルタのテスト)
    - [1.2.4. メールフォルダ作成](#124-メールフォルダ作成)
    - [1.2.5. 初回メール取り込み](#125-初回メール取り込み)
    - [1.2.6. メール定期受信設定](#126-メール定期受信設定)
    - [1.2.7. メールフィルタの再適用](#127-メールフィルタの再適用)
    - [1.2.8. コマンド/マクロ のメモ](#128-コマンドマクロ-のメモ)
    - [1.2.9. notmuch(メール検索)のセットアップ](#129-notmuchメール検索のセットアップ)

## 1.1. setup.sh
- ubuntu セットアップ用スクリプト
  - 第一引数(必須)：セットアップ対象のユーザ名
  - 第二引数(任意)：プロキシサーバのURL(例：http://proxy.local:8080)
- セットアップ内容の詳細はスクリプト内のコメントを参照


## 1.2. neomutt セットアップ
### 1.2.1. ファイル構成
- neomutt
  - ~/.muttrc                           : [自動作成] mutt 設定ファイルの大本。このファイルから common, account を読み込む。
  - ~/dotfiles/wsl2/ubuntu/.mutt/common : [自動作成] mutt 共有の設定
  - ~/.mutt/account                     : [手動作成] mutt アカウント個別の設定
  - ~/.mutt/mcache                      : [自動作成] ヘッダとメッセージのキャッシュ用ディレクトリ
  - ~/dotfiles/wsl2/ubuntu/.mutt/mailcap: [自動作成] MIME別のアクセス方法の定義
  - ~/.mutt/mutt-colors-solarized       : [自動作成] カラースキーマ用ファイル
  - ~/.mutt/signature_default           : [手動作成] デフォルトの署名
  - ~/.mutt/signature_internal          : [手動作成] 内部向けメールの署名
- fetchmail
  - ~/.fetchmailrc                      : [手動作成] メール受信用設定
- maildrop
  - ~/.mailfilter                       : [手動作成] メール振り分け設定
- notmuch
  - ~/mail/.notmuch                     : [手動作成] メール検索用DB
- others
  - ~/mail                              : [自動作成] メール保存用ディレクトリ
  - ~/bin/mf2md.sh                      : [自動作成] .mailfilter からメールディレクトリを作成するスクリプト
  - ~/bin/re-filter.sh                  : [自動作成] メール手動フィルタリング用スクリプト


### 1.2.2. 手動作成ファイルの作成手順
#### 1.2.2.1. ~/.mutt/account
以下のテンプレートを適宜書き換えて作成する。権限は 600 にしておく
``` shell
set mbox_type = Maildir
set record    = ~/mail/__sent # 送信済みメールの保存先。mf2md.sh で自動作成される
set postponed = ~/mail/__postponed # 下書きメールの保存先。mf2md.sh で自動作成される

set folder    = ~/mail
set spoolfile = ~/mail

# ディレクトリ一覧のデフォルトを指定
macro index,pager a "<change-folder>?<change-folder>^U~/mail/<enter><toggle-mailboxes>" "show incoming mailboxes list"

set realname = 'Taro Yamada' # メール送信時の表示名
set from = 'localpart@domain.local' # メール送信時のFromアドレス
set header_cache = "~/.mutt/mcache"
set message_cachedir = "~/.mutt/mcache"
folder-hook . 'set read_inc=1000'

# macro browser H <change-dir>^U~/mail<enter>

my_hdr Return-Path: localpart@domain.local # メール送信時のReturn-Path

set smtp_url = "smtps://localpart@domain.local@smtpserver.domain.local:465/" # メール送信に使用するSMTPサーバ
set smtp_pass = "my password" # SMTP サーバのパスワード

send-hook . set signature="~/.mutt/signature_default" # デフォルトの署名ファイルのパス
send-hook "~t @domain.local" set signature=~/.mutt/signature_internal # 内部向けメールの署名ファイルのパス

#mailboxes `echo -n "+ "; find ~/mail -maxdepth 1 -type d -name cur -prune -o -type d -name new -prune -o -type d -name tmp -prune -o -type d -printf "+'%f' "`
mailboxes `find ~/mail -maxdepth 1 -type d | while read line; do basename $line; done | grep -v -e ^mail -e '\.notmuch' | while read line; do printf "+'$line' "; done`
```

#### 1.2.2.2. ~/.mutt/signature_default, internal
以下のテンプレートを適宜書き換えて作成する
```
Taro Yamada <taro-yamada@domain.local>
```


#### 1.2.2.3. ~/.fetchmailrc
以下のテンプレートを適宜書き換えて作成する。権限は 600 にしておく。
``` ini
poll imapserver.domain.local
  protocol imap
  port 143 # 平文の場合
  username localpart@domain.local # メールアドレス
  password yourpassword # ここにパスワードを書く
  keep
  ssl # 平文の場合は不要
  no mimedecode
  # -V1 はデバッグレベル(0は何もしない、9が最大)
  # 振り分けでエラーになるときは -V9 にしてログを見る
  mda "maildrop -V1 /path/to/.mailfilter >>/path/to/mailfilter.log 2>&1"
```

#### 1.2.2.4. ~/.mailfilter
以下のテンプレートを適宜書き換えて作成する。

[参考URL](https://www.courier-mta.org/maildrop/maildropfilter.html)
```
# --------------------------------------------------
# Global Definition
# --------------------------------------------------
MAILDIR = "$HOME/mail"



# --------------------------------------------------
# Dustbox
# --------------------------------------------------
# Folders
DUSTBOX = "$MAILDIR/__dustbox"

# Filtering Rules
# 複数行に分割する場合は、末尾に \ を置く
if( \
    /^From:.*dustmail1@domain.local.*/:h || \
    /^Return-Path:.*dustmail2@domain.local.*/:h || \
    /^Return-Path:.*dustmail3@domain.local.*/:h \
)
{
    FLAGS=S # 自動で既読にする場合は S (Seen) フラグをセットする
    to $DUSTBOX
}



# --------------------------------------------------
# To
# --------------------------------------------------
# Folders
folder1 = "$MAILDIR/folder1"
folder2 = "$MAILDIR/folder2"
folder3 = "$MAILDIR/folder3"
folder4 = "$MAILDIR/folder4"

# Filtering Rules
if (/^To:.*localpart@domain.local.*/:h) # if 文は必ずこの形式で記載する必要がある。一行では書けない。
{
    if (/^From:.*localpart@domain.local.*/:h)
    {
        if (/^Subject:.*日本語での振り分けも可能.*/:h)
        {
            FLAGS=F # 注目したいメッセージには F (Flagged) フラグをセットする
            to $folder1
        }
    }
    else
    {
        to $folder2
    }
    # From と Return-Path を比較することも可能
    if (/^From:\s*(.*)/:h)
    {
        ADDR_F=getaddr($MATCH1)
    }
    if (/^Return-Path:\s*(.*)/:h)
    {
        ADDR_R=getaddr($MATCH1)
    }
    if ($ADDR_F eq $ADDR_R)
    {
        to $folder3
    }
}
if (/^Cc:.*localpart@domain.local.*/:h)
{
    to $folder4
}


# --------------------------------------------------
# Default
# --------------------------------------------------
# Folders
DEFAULT = "$MAILDIR/__default"

# Filtering Rules
to $DEFAULT



# if ( /^From:\s*(.*)/ && lookup( $MATCH1, ".blockaddr" ) )
# {
#  to "maildir/.Trash/"
# }
```

### 1.2.3. メールフィルタのテスト
``` shell
maildrop -V 2 .mailfilter </dev/null 2> mailfilter.log
```

### 1.2.4. メールフォルダ作成
.mailfilter ファイルをもとに、以下のスクリプトでフォルダを作成する。
``` shell
mf2md.sh .mailfilter
```

### 1.2.5. 初回メール取り込み
imap のフォルダ一覧を取得 (平文の場合)
``` shell
curl -u 'localpart@domain.local' 'imap://imapserver.domain.local:143' | grep -i inbox >imap_folder_list
```

全フォルダからメールの取得
``` shell
cat imap_folder_list | awk -F '"' '{print $4}' | while read line; do fetchmail -a -r "${line}"; done
```

### 1.2.6. メール定期受信設定
`crontab -e` で以下の設定を追加し、毎分メール受信を行うようにする。
```
MAILTO=""
* * * * * fetchmail
```

### 1.2.7. メールフィルタの再適用
~/mail/__default 内のメールを再度フィルタリングする場合 (一応 cron の fetchmail は止めておく)
``` shell
re-filter.sh .mailfilter ~/mail/__default
```


### 1.2.8. コマンド/マクロ のメモ
- index: メールの件名が表示されている画面
  - ^R: 全てのメールを既読状態にする
  - l: メッセージのフィルタ
    - ~b 検索ワード: メール本文の検索
    - ~f 検索ワード: メールのFromの検索
    - ~t 検索ワード: メールのToの検索
    - ~s 検索ワード: メールのSubjectの検索
    - ~h 検索ワード: メールのヘッダの検索
    - ~F: フラグ付きメッセージ
    - and: 条件を続けて書くだけでOK
    - or: | でつなぐ
  - d: メッセージの削除
  - $: 削除などの反映
  - P: 下書きメッセージの編集再開
- pager: メール本文を表示している状態
  - R: 全員に返信
  - r: 個人に返信
- browser: メールボックスの一覧が表示されている画面
- sidebar: 画面左のフォルダ一覧
  - ^N: 一つ下を選択
  - ^P: 一つ上を選択
  - ^O: 選択しているフォルダを開く


### 1.2.9. notmuch(メール検索)のセットアップ
``` shell
# notmuch のセットアップ (対話形式)
notmuch setup

# DB の作成
# セットアップで指定したディレクトリ配下に、.notmuch ディレクトリが作成される
notmuch new

# メールの検索 (subject はスラッシュで囲まないとうまく検索がヒットしない)
notmuch search 'from:hoge@domain.local'
notmuch search 'subject:/hogehoge/ and to:soge@domain.local'
notmuch search 'subject:/hogehoge/ or  to:soge@domain.local'

# 検索したメールを閲覧する
notmuch find 'thread:xxxxxxxxxx'

# 検索方法の確認
man notmuch-search-terms

# そのほかコマンドのヘルプ
notmuch --help
notmuch search --help
```
