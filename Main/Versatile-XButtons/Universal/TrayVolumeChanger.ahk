
#HotIf XButtonIsOverNotificationArea()

; Prevents unintentional XButton1 + LButton hotkeys triggering – when we really
; just meant the LButton (to click on a tray icon).
XButton2 & LButton::LButton

#HotIf XButtonIsOverTaskbar()

; Volume up
XButton2 & WheelUp::{
	turns := GetWheelTurns()
	SendInput "{Volume_Up " Ceil(turns ** turns) "}"
}

; Volume down
XButton2 & WheelDown::{
	turns := GetWheelTurns()
	SendInput "{Volume_Down " Ceil(turns ** turns) "}"
}

; Volume Mute
XButton2 & MButton::{
	;SendInput "{Media_Play_Pause}"
	SendInput "{Volume_Mute}"
}

#HotIf WinActive("Volume Control ahk_class Windows.UI.Core.CoreWindow ahk_exe ShellExperienceHost.exe")

; Prevents horizontal scrolls
; (since that makes the volume controls go the opposite way)
XButton2 & WheelUp::WheelUp
XButton2 & WheelDown::WheelDown

#HotIf
