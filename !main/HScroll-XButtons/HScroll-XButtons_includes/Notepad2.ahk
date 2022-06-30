
; Notepad2 currently doesn't support the new `WheelLeft` and `WheelRight` inputs.
;
; Also, provides horizontal scrolling acceleration.
;

Notepad2_init() {
	static _ := Notepad2_init()

	; Notepad2-mod -- by XhmikosR
	; https://github.com/XhmikosR/notepad2-mod
	;global Notepad2_WinTitle := "ahk_class Notepad2 ahk_exe Notepad2.exe"

	; Notepad2-mod-jrb -- by johnwait
	; https://github.com/johnwait/notepad2-mod-jrb
	global Notepad2_WinTitle := "ahk_exe Notepad2-jrb.exe"
}

#If MouseIsOver(Notepad2_WinTitle)

; Scroll left
XButton1 & WheelUp::
StabilizeScroll()
MouseGetPos,,, mwin, mcontrol, 1
Loop % GetHScrollLines() * A_EventInfo ** A_EventInfo
	; 0x114 is WM_HSCROLL and the 0 after it is SB_LINELEFT.
	SendMessage, 0x114, 0, 0, %mcontrol%, ahk_id %mwin%
Return

; Scroll right
XButton1 & WheelDown::
StabilizeScroll()
MouseGetPos,,, mwin, mcontrol, 1
Loop % GetHScrollLines() * A_EventInfo ** A_EventInfo
	; 0x114 is WM_HSCROLL and the 1 after it is SB_LINERIGHT.
	SendMessage, 0x114, 1, 0, %mcontrol%, ahk_id %mwin%
Return

#If WinActive(Notepad2_WinTitle)

^+o::Return ; NOP – to prevent accidental encoding changes to OEM 437

#If ; End If

