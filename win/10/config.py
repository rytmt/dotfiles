import sys
import os
import datetime

import pyauto
from keyhac import *


def configure(keymap):

    # --------------------------------------------------------------------
    # Text editer setting for editting config.py file

    # 設定ファイル用のエディタ指定 (使用しない)
    # wsl2 の .zshrc に keyhac コマンドが定義してあるのでそちらを使う
    if 1:
        keymap.editor = "notepad.exe"

    # --------------------------------------------------------------------
    # Customizing the display

    # Font
    keymap.setFont( "MS Gothic", 12 )

    # Theme
    keymap.setTheme("black")

    # --------------------------------------------------------------------
    # 関数定義

    # IME 無効化
    def ime_off_esc():
        keymap.wnd.setImeStatus(0)
        keymap.InputKeyCommand("Esc")()

    # --------------------------------------------------------------------
    # グローバルキーマップ
    if 1:
        keymap_global = keymap.defineWindowKeymap()

        # vimライクなキーマップ
        keymap_global["C-H"] = "Left"
        keymap_global["C-J"] = "Down"
        keymap_global["C-K"] = "Up"
        keymap_global["C-L"] = "Right"
        keymap_global["C-A"] = "Home"
        keymap_global["C-E"] = "End"

        # ウインドウのアクティブ化
        keymap_global[ "C-1" ] = "W-1"
        keymap_global[ "C-2" ] = "W-2"
        keymap_global[ "C-3" ] = "W-3"
        keymap_global[ "C-4" ] = "W-4"
        keymap_global[ "C-5" ] = "W-5"

        # ウインドウの移動
        keymap_global[ "C-8" ] = "W-S-Left"
        keymap_global[ "C-9" ] = "W-S-Right"

        # IME Off and Escape
        keymap_global["C-Colon"] = ime_off_esc

    # テキストボックス用のキーマップ
    if 1:
        keymap_edit = keymap.defineWindowKeymap( class_name="Edit" )

        keymap_edit["C-S-D"] = "Home", "S-End", "C-X"

