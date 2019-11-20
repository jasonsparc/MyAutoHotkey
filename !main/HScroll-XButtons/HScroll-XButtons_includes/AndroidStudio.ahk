
; Android Studio and IntelliJ currently does not support `WheelLeft` and
; `WheelRight` mouse events for horizontal scrolls.
;
; But it does provide `Shift + Wheel[Up/Down]` for horizontal scrolls, so we
; simulate that instead.
;

#If MouseIsOver("ahk_class SunAwtFrame ahk_exe studio64.exe")

XButton1 & WheelUp::
Send {shift down}{WheelUp %A_EventInfo%}
AndroidStudio_HeldKeys := true
Return

XButton1 & WheelDown::
Send {shift down}{WheelDown %A_EventInfo%}
AndroidStudio_HeldKeys := true
Return

; Auto-release held keys regardless of current mouseover
#If AndroidStudio_HeldKeys

*~XButton1 up::
AndroidStudio_HeldKeys := false
; Sends a dummy keypress along with the shift key up input, to avoid triggering
; ...IntelliJ’s “Search everything” action.
Send {ctrl downtemp}{shift up}{ctrl up}
Return

#If ; End If

