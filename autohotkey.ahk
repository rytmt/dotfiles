; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

#z::Run www.autohotkey.com


+vkF4sc029::Send {Esc}
+vkF3sc029::Send {Esc}

^h::Send {Left}
^j::Send {Down}
^k::Send {Up}
^l::Send {Right}

^1::#1
;^2::#2
^2::mutt()
;$^2::
;  mintty()
;  Send ^t
;  Send 0
;  Send #3
^3::#3
;^4::#4
^4::emacs()
;^5::#5
;^6::#6
;^7::#7
;^8::#8
;^9::#9


^BS::Send {Del}

!BS::Send !{F4}

ppcw() {
    Process,Exist,PPCW.EXE
    If ErrorLevel<>0
        WinActivate,ahk_pid %ErrorLevel%
    else
        Run,PPCW.EXE
}

mintty() {
    Process,Exist,mintty.exe
    If ErrorLevel<>0
        WinActivate,ahk_pid %ErrorLevel%
    else
        Run,mintty.exe
}

mutt() {
    Process,Exist,mintty.exe
    If ErrorLevel<>0
        WinActivate,ahk_pid %ErrorLevel%
    else
        Run,mintty.exe
        Send ^t
        Send 1
}

emacs() {
    Process,Exist,mintty.exe
    If ErrorLevel<>0
        WinActivate,ahk_pid %ErrorLevel%
    else
        Run,mintty.exe
        Send ^t
        Send 2
}

^5::ppcw()

^8::Send #+{Right}
^9::Send #+{Left}
^0::Send #+{Up}

; Ctrl + Colon -> Escape
^vkBAsc028::Send {Esc}

; Ctrl + Space -> Enter
;^Space::Send {Enter}

; Ctrl + o -> e/j
;^o::Send {vkF3sc029}

; Ctrl + @ -> BackSpace
;^@::Send {BS}

^+d::Send {Home}+{End}{Del}

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.
