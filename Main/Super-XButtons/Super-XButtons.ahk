#Requires AutoHotkey v2.0
#Include <Lib\CheckUIAccess.ahk>

#SingleInstance force
TraySetIcon "imageres.dll", 106

CoordMode "Mouse", "Screen"
SetTitleMatchMode 3
SetTitleMatchMode "Fast"
goto IncludesSetup

; -----------------------------------------------------------------------------

; Scroll left
XButton2 & WheelUp::{
	MouseClick "WL", , , Ceil(GetHScrollLines() * GetWheelTurns())
}

; Scroll right
XButton2 & WheelDown::{
	MouseClick "WR", , , Ceil(GetHScrollLines() * GetWheelTurns())
}

; -----------------------------------------------------------------------------
; Utilities

GetWheelTurns() {
	; 120 represents 1 notch. See, https://www.autohotkey.com/docs/v2/Hotkeys.htm#Wheel
	return A_EventInfo / 120
}

GetHScrollLines() {
	hScrollLines := 0
	; https://autohotkey.com/board/topic/8435-mouse-wheel-speed/
	; https://msdn.microsoft.com/en-us/library/windows/desktop/ms724947(v=vs.85).aspx
	;
	; Retrieve the original horizontal scroll wheel setting
	; #define SPI_GETWHEELSCROLLLINES    0x68
	DllCall("SystemParametersInfo", "UInt", 0x68, "UInt", 0, "UIntP", &hScrollLines, "UInt", 0)
	return hScrollLines
}

HScrollControl(isScrollRight) {
	try {
		MouseGetPos , , &mwin, &mcontrol, 1
		turns := GetWheelTurns()
		isScrollRight := isScrollRight != 0
		loop Ceil(GetHScrollLines() * turns) {
			; 0x114 is WM_HSCROLL and the value after it is either SB_LINELEFT
			; (which is 0) or SB_LINERIGHT (which is 1).
			SendMessage 0x0114, isScrollRight, 0, mcontrol, "ahk_id " mwin
		}
	} catch {
		; Ignore
	}
}

HScrollControlAccelerated(isScrollRight) {
	try {
		MouseGetPos , , &mwin, &mcontrol, 1
		turns := GetWheelTurns()
		isScrollRight := isScrollRight != 0
		loop Ceil((GetHScrollLines() * turns) ** turns) {
			; 0x114 is WM_HSCROLL and the value after it is either SB_LINELEFT
			; (which is 0) or SB_LINERIGHT (which is 1).
			SendMessage 0x0114, isScrollRight, 0, mcontrol, "ahk_id " mwin
		}
	} catch {
		; Ignore
	}
}

MouseIsOver(WinTitle) {
	if !WinTitle {
		; Fail-fast, since an empty `WinTitle` is probably not on purpose.
		return 0x0
	}
	MouseGetPos , , &Win, , 1
	return WinExist(WinTitle " ahk_id " Win)
}

MouseIsOverTaskbar() {
	MouseGetPos , , &Win, , 1
	return WinExist("ahk_class Shell_TrayWnd ahk_id " Win)
}

MouseIsOverNotificationArea() {
	;CoordMode "Mouse", "Screen"  ; <-- Set this instead in the auto-execute section
	MouseGetPos &X, &Y, &Win, , 1
	if (WinExist("ahk_class Shell_TrayWnd ahk_id " Win)) {
		WinGetPos &sX, &sY, , , "ahk_class Shell_TrayWnd"
		X -= sX
		Y -= sY
		ControlGetPos &tX, &tY, &tW, &tH, "TrayNotifyWnd1", "ahk_class Shell_TrayWnd"
		return X >= tX && X <= tX + tW && Y >= tY && Y <= tY + tH
	}
	return false
}

; -----------------------------------------------------------------------------

IncludesSetup:
IncludesSetup_init()
IncludesSetup_init() {
	Thread "NoTimers"
	global IncludesSetup_done := 0
	SetTimer IncludesSetup_check, -1, 2147483647
}
IncludesSetup_deinit() {
	Thread "NoTimers", 0
	global IncludesSetup_done := 1
}
IncludesSetup_check() {
	if (IncludesSetup_done)
		return
	throw Error(
		"Auto-execute section ended abruptly. Some scripts might not have been initialized.`n"
		"Perhaps an included script did a ``return`` while under the auto-execute section.",
		-1, ; Helps in detecting where the abrupt return/exit happened
	)
}

; -----------------------------------------------------------------------------
; Custom handler includes

#Include Apps\Notepad2.ahk

; -----------------------------------------------------------------------------

#Warn Unreachable
IncludesSetup_deinit()
