# windows セットアップ

## 初めにやる
- 変換/無変換キーの割り当て変更
- タスクバーから邪魔なものを消す
- ダークモードに設定
- エクスプローラで拡張子を表示するようにする

## フォントインストール
- https://github.com/yuru7/HackGen/releases/latest
  - windows terminal には HackGenNerd Console を適用 (exaのアイコン対応)
  - vscode には HackGen を適用 (設定同期で自動適用されるはず)

## ソフトウェアインストール
### 特に設定のいらないもの
- 7zip
- ctrl2cap
- vlc
- honeyview
- adobe acrobat reader

### 設定が必要なもの
#### google chrome
1. 設定同期 (4114)
2. ブックマーク等は同期しないようにする

#### autohotkey (old)
1. autohotkey のインストール
2. dotfiles/win/10/myscript.ahk をダウンロードして、実行

#### keyhac (new)
1. keyhac のインストール
2. keyhac の起動
3. zsh(wsl2) から keyhac_cp2local コマンドを実行 (dotfiles からローカルに設定をコピー)
4. keyhac 設定のリロード

#### tweeten
1. GUI から適当に設定

#### clibor
1. GUI から適当に設定

#### tascher
1. GUI から適当に設定

#### wsl2
1. wsl2 の有効化、ディストリビューションのインストール (やり方は都度調べる)

#### windows terminal
1. microsoft store からインストール
2. ~/dotfiles/win/10/winterm_gruvbox.json を windows terminal の設定(.json)に追記
3. GUI から適当に設定

#### vscode
1. インストール
2. 設定同期 (msアカウント:rytmt)

#### tablacus Explorer
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
