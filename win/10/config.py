import sys
import os
import datetime

import pyauto
from keyhac import *


def configure(keymap):

    # --------------------------------------------------------------------
    # Text editer setting for editting config.py file

    # 設定ファイル用のエディタ指定 (使用しない)
    # wsl2 の .zshrc に keyhac_edit コマンドが定義してあるのでそちらを使う
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

    # IME 無効化と Escape キーの送信
    def ime_off_esc():
        keymap.wnd.setImeStatus(0)
        keymap.InputKeyCommand("Esc")()

    # IME 無効化/有効化
    def ime_off():
        keymap.wnd.setImeStatus(0)
    def ime_on():
        keymap.wnd.setImeStatus(1)

    # カーソル移動用
    input_down_command = keymap.InputKeyCommand("Down")
    input_up_command = keymap.InputKeyCommand("Up")
    def down_multi():
        for i in range(10):
            input_down_command()
    def up_multi():
        for i in range(10):
            input_up_command()

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
        keymap_global["A-J"] = lambda: down_multi()
        keymap_global["A-K"] = lambda: up_multi()

        # ウインドウのアクティブ化
        keymap_global[ "C-1" ] = "W-1"
        keymap_global[ "C-2" ] = "W-2"
        keymap_global[ "C-3" ] = "W-3"
        keymap_global[ "C-4" ] = "W-4"
        keymap_global[ "C-5" ] = "W-5"

        # アクティブ化で使えなくなったキーの有効化
        keymap_global[ "W-1" ] = "C-1"
        keymap_global[ "W-2" ] = "C-2"
        keymap_global[ "W-3" ] = "C-3"
        keymap_global[ "W-4" ] = "C-4"
        keymap_global[ "W-5" ] = "C-5"

        # ウインドウの移動
        keymap_global[ "C-8" ] = "W-S-Left"
        keymap_global[ "C-9" ] = "W-S-Right"

        # IME Off and Escape
        keymap_global["C-Colon"] = lambda: ime_off_esc()

        # 変換キー/無変換キーでの IME 切り替え
        keymap_global["(28)"] = lambda: ime_on()
        keymap_global["(29)"] = lambda: ime_off()
        # Shift+無変換 で全角英数入力にならないようにする
        keymap_global["S-(29)"] = lambda: None


    # Edit class 用のキーマップ
    if 1:
        keymap_edit = keymap.defineWindowKeymap( class_name="Edit" )

        keymap_edit["C-S-D"] = "Home", "S-End", "C-X"

    # Google Chrome用のキーマップ
    if 1:
        keymap_chrome = keymap.defineWindowKeymap( exe_name="chrome.exe" )

        keymap_chrome["C-N"] = "C-Tab"
        keymap_chrome["C-P"] = "C-S-Tab"


