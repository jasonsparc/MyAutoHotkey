#Requires AutoHotkey v2.0
#SingleInstance force

TraySetIcon "shell32.dll", 321
#Include <Lib\CheckUIAccess>

CoordMode "Mouse", "Screen"
SetTitleMatchMode 3
SetTitleMatchMode "Fast"

; -----------------------------------------------------------------------------

; Make the XButtons NOP by default – they can be re-enabled via hotkeys like
; `*XButton0::Send "{Blind}{XButton0}"` in some `#HotIf` context or similar.
*XButton1::return
*XButton2::return

; -----------------------------------------------------------------------------
; Includes setup

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

; NOTE: Named similar to `ControlClick` command.
ControlHScroll(isScrollRight) {
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

ControlHScrollAccelerated(isScrollRight) {
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

/**
 * NOTE: Using this function in `#HotIf` checks can be costly. It is recommended
 * to only use this in `#HotIf` checks for `XButton`-related hotkeys.
 */
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

/**
 * A handy utility that activates the window under the mouse cursor while also
 * waiting for that window to actually activate.
 *
 * Mainly useful for mouse hotkeys, since mouse inputs should generally trigger
 * window activation -- i.e., more specifically when the hotkey trigger involves
 * mouse buttons such as, `LButton`, `MButton`, `XButton1`, etc.
 */
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

/**
 * Utility to ensure held keys never get stuck or jammed.
 */
ReleaseKeys(keysToRelease*) {
	releaseCommand := ""
	for , key in keysToRelease {
		if GetKeyState(key)
			releaseCommand .= "{" key " up}"
	}
	if (releaseCommand)
		SendInput releaseCommand
}

; -----------------------------------------------------------------------------
; Includes

#Include Games\! ! Includes.ahk
#Include Apps\! ! Includes.ahk
#Include Universal\! ! Includes.ahk

; -----------------------------------------------------------------------------

#Warn Unreachable
IncludesSetup_deinit()
