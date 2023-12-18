import sys
import os
import datetime
import fnmatch

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
    input_left_command = keymap.InputKeyCommand("Left")
    input_right_command = keymap.InputKeyCommand("Right")
    def down_multi():
        for i in range(10):
            input_down_command()
    def up_multi():
        for i in range(10):
            input_up_command()
    def left_multi():
        for i in range(10):
            input_left_command()
    def right_multi():
        for i in range(10):
            input_right_command()


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
        keymap_global["A-H"] = lambda: left_multi()
        keymap_global["A-L"] = lambda: right_multi()

        # ウインドウのアクティブ化
#        keymap_global["C-1"] = "W-1"
#        keymap_global["C-2"] = "W-2"
#        keymap_global["C-3"] = "W-3"
#        keymap_global["C-4"] = "W-4"
#        keymap_global["C-5"] = "W-5"
        #keymap_global["C-A-1"] = "W-6"

        # アクティブ化で使えなくなったキーの有効化
#        keymap_global[ "W-1" ] = "C-1"
#        keymap_global[ "W-2" ] = "C-2"
#        keymap_global[ "W-3" ] = "C-3"
#        keymap_global[ "W-4" ] = "C-4"
#        keymap_global[ "W-5" ] = "C-5"

        # ウインドウの移動
        keymap_global["C-8"] = "W-S-Left"
        keymap_global["C-9"] = "W-S-Right"

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

    # 日付入力ショートカット
    if 1:
        def input_date(fmt):
            ime_off()
            text = datetime.datetime.today()
            keymap.InputTextCommand(text.strftime(fmt))()
        keymap_global["C-A-1"] = lambda: input_date(r"%Y-%m-%d")
        keymap_global["C-A-2"] = lambda: input_date(r"%Y/%m/%d")
        keymap_global["C-A-3"] = lambda: input_date(r"%Y%m%d")

    # ウインドウアクティブ化
    if 1:
        # 関数定義1 (ウィンドウを探す)
        def find_window(exe_name, class_name=None):
            found = [None]
            def _callback(wnd, arg):
                if not wnd.isVisible() : return True
                if not fnmatch.fnmatch(wnd.getProcessName(), exe_name) : return True
                if class_name and not fnmatch.fnmatch(wnd.getClassName(), class_name) : return True
                found[0] = wnd.getLastActivePopup()
                return False
            pyauto.Window.enum(_callback, None)
            return found[0]

        # 関数定義2 (アクティブ化 or 最小化)
        def activate_window(wnd):
            # ウインドウがフォーカスされている場合は最小化
            if pyauto.Window.getFocus().getProcessName() == wnd.getProcessName():
                wnd.minimize()
                return True

            # フォーカスされていない場合はアクティブ化
            if wnd.isMinimized():
                wnd.restore()
            trial = 0
            while trial < 10:
                trial += 1
                try:
                    wnd.setForeground()
                    if pyauto.Window.getForeground() == wnd:
                        wnd.setForeground(True)
                        return True
                except:
                    return False
            return False

        # 関数定義3 (クロージャ生成)
        def pseudo_cuteExec(exe_name, class_name, exe_path):
            def _executer():
                found_wnd = find_window(exe_name, class_name)
                if not found_wnd:
                    pass
                else:
                    if activate_window(found_wnd):
                        return None
            return _executer

        # キー割当
        for key, params in {
            "C-1": ("chrome.exe", None, None),
            "C-2": ("msedge.exe", None, None),
            "C-3": ("WindowsTerminal.exe", None, None),
            "C-4": ("Code.exe", None, None),
        }.items():
            keymap_global[key] = pseudo_cuteExec(*params)
