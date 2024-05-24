#Requires AutoHotkey v2.0

; Notepad2 currently doesn't support the new `WheelLeft` and `WheelRight` inputs.
;
; Also, provides horizontal scrolling acceleration.
;

Notepad2_init()
Notepad2_init() {
	; Notepad2-mod -- by XhmikosR
	; https://github.com/XhmikosR/notepad2-mod
	global Notepad2_WinTitle := "ahk_class Notepad2 ahk_exe Notepad2.exe"

	; Notepad2-mod-jrb -- by johnwait
	; https://github.com/johnwait/notepad2-mod-jrb
	;global WinTitle := "ahk_exe Notepad2-jrb.exe"
}

#HotIf MouseIsOver(Notepad2_WinTitle)

; Scroll left
XButton2 & WheelUp::{
	HScrollControlAccelerated(0)
}

; Scroll right
XButton2 & WheelDown::{
	HScrollControlAccelerated(1)
}

#HotIf WinActive(Notepad2_WinTitle)

^+o::return ; NOP – to prevent accidental encoding changes to OEM 437

#HotIf
