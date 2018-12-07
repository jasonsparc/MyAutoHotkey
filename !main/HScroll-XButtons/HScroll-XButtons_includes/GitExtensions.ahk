
; Git Extensions currently does not support `WheelLeft` and `WheelRight` mouse
; events for horizontal scrolls.
;
; But it does provide `Shift + Wheel[Up/Down]` for horizontal scrolls (as of
; v3.00.00.03-RC2), so we simulate that instead.
;

#If MouseIsOver("ahk_exe GitExtensions.exe")

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

