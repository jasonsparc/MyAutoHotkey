
; Notepad2 currently doesn't support the new `WheelLeft` and `WheelRight` inputs.
;
; Also, provides horizontal scrolling acceleration.
;

Notepad2_init()
Notepad2_init() {
	; Notepad2-mod -- by XhmikosR
	; https://github.com/XhmikosR/notepad2-mod
	GroupAdd "Notepad2", "ahk_class Notepad2 ahk_exe Notepad2.exe"

	; Notepad2-mod-jrb -- by johnwait
	; https://github.com/johnwait/notepad2-mod-jrb
	;GroupAdd "Notepad2", "ahk_exe Notepad2-jrb.exe"
}

#HotIf XButtonIsOver("ahk_group Notepad2")

; Scroll left
XButton2 & WheelUp::{
	ControlHScrollAccelerated(0)
}

; Scroll right
XButton2 & WheelDown::{
	ControlHScrollAccelerated(1)
}

#HotIf WinActive("ahk_group Notepad2")

^+o::return ; NOP – to prevent accidental encoding changes to OEM 437

#HotIf
