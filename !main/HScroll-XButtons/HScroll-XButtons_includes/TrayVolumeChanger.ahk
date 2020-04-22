
; TODO Description
;

#If MouseIsOverNotificationArea()

; Prevents unintentional XButton1 + LButton hotkeys triggering
; -- when we really just meant the LButton (to click on a tray icon)
XButton1 & LButton::LButton

#If MouseIsOverTaskbar()

; Volume Up
XButton1 & WheelUp::
Amount := A_EventInfo ** A_EventInfo
SendInput {Volume_Up %Amount%}
Return

; Volume Down
XButton1 & WheelDown::
Amount := A_EventInfo ** A_EventInfo
SendInput {Volume_Down %Amount%}
Return

; Volume Mute
XButton1 & MButton::
;SendInput {Media_Play_Pause}
SendInput {Volume_Mute}
Return

#IfWinActive Volume Control ahk_class Windows.UI.Core.CoreWindow ahk_exe ShellExperienceHost.exe

; Prevents horizontal scrolls
; (since that makes the volume controls go the opposite way)
XButton1 & WheelUp::WheelUp
XButton1 & WheelDown::WheelDown

#If ; End If

