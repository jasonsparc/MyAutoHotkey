#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
Menu, Tray, Icon, imageres.dll, 244

SetMouseDelay, -1
CoordMode Mouse, Screen
Return

;-=-=-=- * * * -=-=-=-

; Scroll left
XButton1 & WheelUp::
StabilizeScroll()
Click WheelLeft %A_EventInfo%
Return

; Scroll right
XButton1 & WheelDown::
StabilizeScroll()
Click WheelRight %A_EventInfo%
Return

; Make XButton1 NOP by default
*XButton1::Return


;-=-=-=- * * * -=-=-=-
; Utilities for our custom handler includes

#Include <Functions>
#Include <ClipboardUtils>

MouseIsOver(WinTitle) {
	if (!WinTitle)
		; Fail-fast, since an empty `WinTitle` is probably not on purpose.
		return 0x0

	MouseGetPos,,, Win
	return WinExist(WinTitle . " ahk_id " . Win)
}

MouseIsOverTaskbar() {
	MouseGetPos,,, Win
	return WinExist("ahk_class Shell_TrayWnd ahk_id " . Win)
}

MouseIsOverNotificationArea() {
	;CoordMode Mouse, Screen	; <-- Set this instead in the auto-execute section
	MouseGetPos, X,Y, Win,, 1
	if (WinExist("ahk_class Shell_TrayWnd ahk_id " . Win)) {
		WinGetPos sX,sY,,, ahk_class Shell_TrayWnd
		X -= sX
		Y -= sY

		ControlGetPos tX,tY,tW,tH, TrayNotifyWnd1, ahk_class Shell_TrayWnd
		return X >= tX && X <= tX+tW && Y >= tY && Y <= tY+tH
	}
	return false
}

MouseIsOver_ControlGet(WinTitle, Flag) {
	if (!WinTitle)
		; Fail-fast, since an empty `WinTitle` is probably not on purpose.
		return ""

	MouseGetPos,,, Win, CtrlOut, %Flag%
	return WinExist(WinTitle . " ahk_id " . Win) ? CtrlOut : ""
}

MouseIsOver_ControlGetText(WinTitle) {
	CtrlHwnd := MouseIsOver_ControlGet(WinTitle, 2)
	return CtrlHwnd ? ControlGetText("", "ahk_id " . CtrlHwnd) : ""
}

WinTitleUnderMouse() {
	MouseGetPos,,, Win
	return ahk_id %Win%
}

GetHScrollLines() {
	; https://autohotkey.com/board/topic/8435-mouse-wheel-speed/
	; https://msdn.microsoft.com/en-us/library/windows/desktop/ms724947(v=vs.85).aspx
	;
	; retrieve original horizontal scroll wheel setting
	; #define SPI_GETWHEELSCROLLCHARS    0x6C
	DllCall("SystemParametersInfo", UInt, 0x6C, UInt, 0, UIntP, Scroll_Lines, UInt, 0) 
	return Scroll_Lines
}

; Needed because mouse wheel sometimes becomes unstable when another button is held.
;
; See,
; https://superuser.com/questions/297798/mouse-wheel-scrolls-the-page-down-then-up-or-up-then-down
StabilizeScroll() {
	if (A_PriorHotkey && A_PriorHotkey != A_ThisHotkey && A_TimeSincePriorHotkey < 500)
		Exit
}

; A handy utility that activates a window while also waiting for it to do so.
; Useful for triggering actions only once the window is in focus.
;
; Mainly useful for mouse actions, since mouse inputs should always trigger
; window activation -- i.e., more specifically when the hotkey trigger involves
; the primary mouse buttons, `LButton`, `RButton` and `MButton`.
RequireWinActive(WinTitle:="", WinText:="", Timeout:=1, ExcludeTitle:="", ExcludeText:="") {
	if (!WinTitle)
		WinTitle := WinTitleUnderMouse()

	if (WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText)) {
		if (WinActive())
			return true

		WinActivate
		WinWaitActive, , , %Timeout%
		return !ErrorLevel
	}
}

; Detects whether any primary mouse buttons (i.e., `LButton`, `RButton` and
; `MButton`) were involved in the hotkey, and if so, delegates call to
; `RequireWinActive()`, returning its value.
;
; Otherwise, for mainly keyboard inputs, returns true only when the target
; window is active.
;
; Use the return value as an indicator of whether a hotkey action should
; proceed. This allows natural input handling where mouse inputs usually
; trigger window activation, and keyboard inputs almost never...
HandleInputsNaturally(ThisHotKey:="", WinTitle:="", WinText:="", Timeout:=1, ExcludeTitle:="", ExcludeText:="") {
	if (!ThisHotKey)
		ThisHotKey := A_ThisHotKey

	if ThisHotKey contains LButton, RButton, MButton
		return RequireWinActive(WinTitle, WinText, Timeout, ExcludeTitle, ExcludeText)

	if (!WinTitle)
		WinTitle := WinTitleUnderMouse()
	return WinActive(WinTitle, WinText, ExcludeTitle, ExcludeText)
}

;-=-=-=- * * * -=-=-=-
; Custom handler includes

; Changes the working directory for subsequent #Includes and FileInstalls.
#Include %A_ScriptDir%\HScroll-XButtons_includes

#Include Instant-Snipping-Tool.ahk
#Include Instant-Copy-Paste.ahk
#Include TrayVolumeChanger.ahk
#Include Chrome-Utils.ahk

#Include AdobeReader+Extras.ahk
#Include AndroidStudio.ahk
#Include Blender.ahk
#Include Excel.ahk
#Include GitExtensions.ahk
#Include Notepad2.ahk
#Include Notion-Utils.ahk
#Include MPC-Utils.ahk
#Include SuperMemo-Utils.ahk
#Include VisualStudio.ahk
#Include WinMerge.ahk

;-+-*-+-


;-=-=-=- * * * -=-=-=-
; The END

