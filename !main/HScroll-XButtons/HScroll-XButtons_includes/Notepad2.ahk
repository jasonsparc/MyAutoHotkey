
; Notepad2 currently doesn't support the new `WheelLeft` and `WheelRight` inputs.
;
; Also, provides horizontal scrolling acceleration.
;

#If MouseIsOver("ahk_class Notepad2 ahk_exe Notepad2.exe")

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

#If ; End If

