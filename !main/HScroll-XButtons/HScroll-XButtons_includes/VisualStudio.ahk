
; Visual Studio 2017 doesn't respect horizontal scrolling lines settings.
;
; Also, provides horizontal scrolling acceleration.
;

#If MouseIsOver("ahk_exe devenv.exe")

; Scroll left
XButton1 & WheelUp::
; No need to stabilize scroll
Amount := GetHScrollLines() * A_EventInfo ** A_EventInfo
Click WheelLeft %Amount%
Return

; Scroll right
XButton1 & WheelDown::
; No need to stabilize scroll
Amount := GetHScrollLines() * A_EventInfo ** A_EventInfo
Click WheelRight %Amount%
Return

#If ; End If

