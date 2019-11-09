
; For Microsoft Excel.
;
; Also, with horizontal scrolling acceleration.
;

; NOTE: Not using `MouseIsOver` since our remaps involve non-modifier keys.
#IfWinActive ahk_class XLMAIN ahk_exe EXCEL.exe

; Scroll left
XButton1 & WheelUp::
; No need to stabilize scroll
Amount := A_EventInfo ** A_EventInfo
if (GetKeyState("ScrollLock", "T")) {
	SendInput {Blind}{Left %Amount%}
} else
	SendInput {Blind}{ScrollLock}{Left %Amount%}{ScrollLock}
Return

; Scroll right
XButton1 & WheelDown::
; No need to stabilize scroll
Amount := A_EventInfo ** A_EventInfo
if (GetKeyState("ScrollLock", "T")) {
	SendInput {Blind}{Right %Amount%}
} else
	SendInput {Blind}{ScrollLock}{Right %Amount%}{ScrollLock}
Return

#If ; End If

