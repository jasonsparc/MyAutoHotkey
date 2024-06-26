﻿#Requires AutoHotkey v2.0
#SingleInstance force

TraySetIcon "shell32.dll", 321
#Include <CheckUIAccess>

CoordMode "Mouse", "Screen"
SetTitleMatchMode 3
SetTitleMatchMode "Fast"

#UseHook ; Makes hotkeys more reliable

; -----------------------------------------------------------------------------

; Make the XButtons NOP by default.
; - They can be re-enabled in some `#HotIf` context via hotkeys like
; `*XButton1::Send "{Blind}{XButton1}"` or by remapping to itself, e.g.,
; `XButton1::XButton1` – see, https://www.autohotkey.com/docs/v2/misc/Remap.htm#actually
*XButton1::return
*XButton2::return

; Wheel left
XButton2 & WheelUp::MouseClick "WL", , , Ceil(GetWheelTurns())

; Wheel right
XButton2 & WheelDown::MouseClick "WR", , , Ceil(GetWheelTurns())

; -----------------------------------------------------------------------------
; Includes setup

IncludesSetup_init()
IncludesSetup_init() {
	Thread "Priority", 2147483647 ; Unlike `Critical`, events aren't buffered.
	global IncludesSetup_done := 0
	SetTimer IncludesSetup_check, -1, 2147483647
}

IncludesSetup_deinit() {
	global IncludesSetup_done := 1
	Thread "Priority", 0 ; Reset
}

IncludesSetup_check() {
	if (IncludesSetup_done)
		return

	ThrowAndExitApp Error(
		"Auto-execute section ended abruptly. Some scripts might not have been initialized.`n"
		"Perhaps an included script did a ``return`` while under the auto-execute section."
		, -1 ; Helps in detecting where the abrupt return/exit happened
	)
}

; -----------------------------------------------------------------------------
; Utilities

; Intended usage:
; ```
; Ceil(GetWheelTurns())
; ```
GetWheelTurns() {
	; 120 represents 1 notch. See, https://www.autohotkey.com/docs/v2/Hotkeys.htm#Wheel
	return A_EventInfo / 120
}

GetHScrollChars() {
	hScrollChars := 0
	; https://www.autohotkey.com/board/topic/8435-mouse-wheel-speed/
	; https://msdn.microsoft.com/en-us/library/windows/desktop/ms724947(v=vs.85).aspx
	;
	; > Retrieves the number of characters to scroll when the horizontal mouse
	; > wheel is moved. The default value is 3.
	; #define SPI_GETWHEELSCROLLCHARS    0x006C
	DllCall("SystemParametersInfo", "UInt", 0x6C, "UInt", 0, "UIntP", &hScrollChars, "UInt", 0)
	return hScrollChars
}

; NOTE: Named similar to `ControlClick` command.
ControlHScroll(isScrollRight) {
	isScrollRight := isScrollRight != 0 ; Sanitize
	MouseGetPos , , &mwin, &mcontrol, 1
	loop Ceil(GetWheelTurns()) {
		; 0x114 is WM_HSCROLL and the value after it is either SB_LINELEFT
		; (which is 0) or SB_LINERIGHT (which is 1).
		try SendMessage 0x0114, isScrollRight, 0, mcontrol, "ahk_id " mwin
	}
}

ControlHScrollAccelerated(isScrollRight) {
	isScrollRight := isScrollRight != 0 ; Sanitize
	MouseGetPos , , &mwin, &mcontrol, 1
	turns := GetWheelTurns()
	loop Ceil(turns * turns) {
		; 0x114 is WM_HSCROLL and the value after it is either SB_LINELEFT
		; (which is 0) or SB_LINERIGHT (which is 1).
		try SendMessage 0x0114, isScrollRight, 0, mcontrol, "ahk_id " mwin
	}
}

; NOTE: Using this function in `#HotIf` checks can be costly. It is recommended
; to only use this in `#HotIf` checks for `XButton`-related hotkeys.
XButtonIsOver(WinTitle) {
	if !WinTitle {
		; Fail-fast, since an empty `WinTitle` is probably not on purpose.
		return 0x0
	}
	MouseGetPos , , &Win, , 1
	return WinExist(WinTitle " ahk_id " Win)
}

XButtonIsOverTaskbar() {
	MouseGetPos , , &Win, , 1
	return WinExist("ahk_class Shell_TrayWnd ahk_id " Win)
}

XButtonIsOverNotificationArea() {
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

; A handy utility that activates the window under the mouse cursor while also
; waiting for that window to actually activate.
;
; Mainly useful for mouse hotkeys, since mouse inputs should generally trigger
; window activation -- i.e., more specifically when the hotkey trigger involves
; mouse buttons such as, `LButton`, `MButton`, `XButton1`, etc.
MouseWinActivate() {
	MouseGetPos , , &mwin, , 1
	try {
		if !WinExist("ahk_id " mwin)
			return
		WinActivate
		WinWaitActive
	} catch TargetError {
		; Ignore
	}
}

; Utility to ensure held keys never get stuck or jammed.
ReleaseKeys(keysToRelease*) {
	releaseCommand := ""
	for , key in keysToRelease {
		if GetKeyState(key)
			releaseCommand .= "{" key " up}"
	}
	if (releaseCommand)
		SendInput releaseCommand
}

GetVirtualDesktopInfo() {
	sessionId := GetSessionId()
	if (!sessionId)
		return

	currentDesktopId := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\" SessionId "\VirtualDesktops", "CurrentVirtualDesktop")
	desktopList := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "VirtualDesktopIDs")
	desktopCount := StrLen(desktopList) / 32

	currentDesktop := 1
	i := 0
	while true {
		if SubStr(desktopList, i * 32 + 1, 32) = currentDesktopId {
			currentDesktop := i + 1
			break
		}
		i++
		if i >= desktopCount
			return ; Could not find current desktop
	}

	return {
		Current: currentDesktop,
		Count: desktopCount,
	}
}

GetSessionId() {
	sessionId := 0
	processId := DllCall("GetCurrentProcessId", "UInt")
	DllCall("ProcessIdToSessionId", "UInt", processId, "UInt*", &sessionId)
	return sessionId
}

; -----------------------------------------------------------------------------
; Includes

#Include Games\! ! Includes.ahk
#Include Apps\! ! Includes.ahk
#Include Universal\! ! Includes.ahk

; -----------------------------------------------------------------------------

#Warn Unreachable
IncludesSetup_deinit()
