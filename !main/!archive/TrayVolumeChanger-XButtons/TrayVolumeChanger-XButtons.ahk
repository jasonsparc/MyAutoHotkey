#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
Menu, Tray, Icon, DDORes.dll, 5

SetMouseDelay, -1
CoordMode Mouse, Screen
Return

;-=-=-=- * * * -=-=-=-

; Adjust volume by scrolling the mouse wheel over the notification area
#If MouseIsOverNotificationArea()

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
XButton1 & LButton::
XButton1 & MButton::
XButton1 & RButton::
SendInput {Volume_Mute}
Return

; Make XButton1 NOP
*XButton1::
XButton1 & XButton2::
Return

#If ; End If


;-=-=-=- * * * -=-=-=-
; Utilities

MouseIsOverNotificationArea() {
	MouseGetPos, X,Y, win,, 1
	if (WinExist("ahk_class Shell_TrayWnd ahk_id " . win)) {
		WinGetPos sX,sY,,, ahk_class Shell_TrayWnd
		X -= sX
		Y -= sY

		ControlGetPos tX,tY,tW,tH, TrayNotifyWnd1, ahk_class Shell_TrayWnd
		return X >= tX && X <= tX+tW && Y >= tY && Y <= tY+tH
	}
	return false
}

;-+-*-+-


;-=-=-=- * * * -=-=-=-
; The END

