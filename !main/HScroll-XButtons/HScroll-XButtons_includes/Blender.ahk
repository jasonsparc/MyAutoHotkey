
; Blender currently does not support `WheelLeft` and `WheelRight` mouse events
; for horizontal scrolls.
;
; But it does provide `Ctrl + Wheel[Up/Down]` for horizontal scrolls, so we can
; simulate that instead.
;
; Also, provides a handy mapping for zooming in/out.
;

#If MouseIsOver("ahk_class GHOST_WindowClass ahk_exe blender.exe")

XButton1 & WheelUp::
Loop %A_EventInfo%
	Send {blind}{ctrl down}{WheelUp}
Return

XButton1 & WheelDown::
Loop %A_EventInfo%
	Send {blind}{ctrl down}{WheelDown}
Return

*~XButton1 up::SendInput {ctrl up}

; Handy mapping for zooming
XButton1 & MButton::SendInput {ctrl down}{MButton down}
XButton1 & MButton up::SendInput {ctrl up}{MButton up}

#If ; End If

