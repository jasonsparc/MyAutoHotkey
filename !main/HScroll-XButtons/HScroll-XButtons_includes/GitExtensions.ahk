
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
GitExtensions_HeldKeys := true
Return

XButton1 & WheelDown::
StabilizeScroll()
Send {shift down}{WheelDown %A_EventInfo%}
GitExtensions_HeldKeys := true
Return

; Auto-release held keys regardless of current mouseover
#If GitExtensions_HeldKeys

*~XButton1 up::
GitExtensions_HeldKeys := false
Send {shift up}
Return

#If ; End If

