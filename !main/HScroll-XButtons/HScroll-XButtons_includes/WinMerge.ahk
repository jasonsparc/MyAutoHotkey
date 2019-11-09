
; WinMerge currently does not support `WheelLeft` and `WheelRight` mouse events
; for horizontal scrolls.
;
; But it does provide `Shift + Wheel[Up/Down]` for horizontal scrolls, so we
; simulate that instead.
;

#If MouseIsOver("ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe")

XButton1 & WheelUp::
StabilizeScroll()
Send {shift down}{WheelUp %A_EventInfo%}
Return

XButton1 & WheelDown::
StabilizeScroll()
Send {shift down}{WheelDown %A_EventInfo%}
Return

~XButton1 up::
Send {shift up}
Return

#If ; End If
