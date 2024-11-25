# windows セットアップ

## 初めにやる
- 「設定」アプリから色々変更する (マウスカーソルとか)
- タスクバーから邪魔なものを消す
- ダークモードに設定
- エクスプローラで拡張子を表示するようにする
- 不要なプログラムをアインストールする
- タスクスケジューラから邪魔なものを消す
- スタートアップから不要なものを消す
- サービス一覧から不要なものを停止+スタートアップ無効化
- エクスプローラの右クリックを従来のものに戻す
- 電源管理設定 (スリープしないようにする等)
- 固定キー機能無効化 (shiftを5回連打)

## フォントインストール
- https://github.com/yuru7/HackGen/releases/latest
  - windows terminal には HackGenNerd Console を適用 (exaのアイコン対応)
  - vscode には HackGen を適用 (設定同期で自動適用されるはず)
  - 表示名が微妙に変わっているかも
    - win10 の場合は HackGenNerd Console だった
- もしくは以下のフォントを使う
  - https://github.com/yuru7/PlemolJP
  - windows terminal では NF フォントが必要なので、PlemolJP Console NF を指定する

## ソフトウェアインストール
### 特に設定のいらないもの
- 7zip
- ctrl2cap (管理者権限で .\ctrl2cap.exe /install を実行する)
- vlc
- honeyview
- adobe acrobat reader
- winmerge
- winshot
- powertoys (microsoft store)

### 設定が必要なもの
#### google日本語入力
1. タスクバーのアイコンを右クリックし、プロパティを開く
2. 「一般」タブの「キー設定の選択」から「編集」を選択
3. 変換キーで IME を有効化、無変換キーで IME を無効化するようにする (半角/全角キーの設定を参考)

#### google chrome
1. 設定同期 (4114)
2. ブックマークや履歴等は同期しないようにする
3. ブックマークの手動インポート
4. URLバーを右クリックして、URL 全体を常に表示するようにする

#### keyhac
1. keyhac のインストール
2. keyhac の起動
3. zsh(wsl2) から keyhac_git2local コマンドを実行 (config.py をローカルにコピー)
4. keyhac 設定のリロード

#### tweeten
1. GUI から適当に設定

#### clibor
1. GUI から適当に設定

#### tascher
1. GUI から適当に設定

#### CraftLaunch
1. 適当に設定

#### wsl
1. microsoft store からインストール
   1. 以下で検索
      1. Windows Subsystem for Linux
      2. Ubuntu
2. %UserProfile% 配下に win/11/.wslconfig をコピー

#### windows terminal
1. microsoft store からインストール
   1. 既定のプロファイルを Ubuntu に変更
   2. ubuntu のプロファイルを変更
      1. 配色: GruvboxMaterialMediumDark
      2. フォントフェイス: HackGen Console NF
      3. フォントサイズ: 12
2. ~/dotfiles/win/10/winterm_colorthemes.json を windows terminal の設定(.json)に追記

#### Ubuntu
1. dotfiles をクローン
   1. git clone 'https://github.com/rytmt/dotfiles.git'
2. root で setup.sh を実行
   1. sudo su -
   2. bash /path/to/script/setup.sh <セットアップ対象アカウント名> 'http://<プロキシ>'
3. ~/.zsh_history を引っ越す
4. その他は wsl2/ubuntu/README.md を参照

#### vscode
1. インストール
2. 設定同期 (rytmt@outlook.jp)
3. wsl からの起動が「Installing VS Code Server for x64」で進まない場合は、vscode の左下のアイコンから wsl を選択してみる

#### old
##### autohotkey
1. autohotkey のインストール
2. dotfiles/win/10/myscript.ahk をダウンロードして、実行

##### tablacus Explorer
1. インストール
2. アドオンインストール (ツール -> アドオン)
   1. ダークモード
   2. 分割
   3. 6分割
   4. フォント設定
      1. 以下の設定にすると更新日時列の自動調整がうまくいく
         1. フォント：cica
         2. サイズ：15
   5. フォルダ設定
      1. 「フォルダの表示設定を覚える」と競合するので、これは無効化しておく
      2. 以下の設定を行う (列幅の自動調整用)
         1. フィルタ：*
         2. タイプ：JScript
         3. オプション
```
FV.CurrentViewMode(4,16);
FV.Columns='"名前" -2 "更新日時" -2 "サイズ" -2 "種類" -2';
FV.GroupBy='System.Null';
FV.SortColumn='名前';
```
