; https://github.com/Ciantic/VirtualDesktopAccessor

; Must hard code to function correctly with #includes
LibDir = %A_MyDocuments%\AutoHotkey\!submodules\VirtualDesktopAccessor\x64\Release

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", LibDir . "\VirtualDesktopAccessor.dll", "Ptr")
global GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")
global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetCurrentDesktopNumber", "Ptr")
global GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetDesktopCount", "Ptr")
global IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsWindowOnCurrentVirtualDesktop", "Ptr")
global GetWindowDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetWindowDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")
global IsPinnedWindowProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsPinnedWindow", "Ptr")

_ToRawDesktopNumber(desktopNumber) {
	maxDesktop := GetDesktopCount()
	if (desktopNumber > maxDesktop)
		desktopNumber := maxDesktop

	desktopNumber--
	if (desktopNumber < 0)
		desktopNumber = 0

	return desktopNumber
}

_GoToRawDesktopNumber(desktopNumber) {
	; Try to avoid flashing task bar buttons, deactivate the current window
	if (Not(WinActive("Task View ahk_class MultitaskingViewFrame")
			Or WinActive("WinActivate ahk_class Shell_TrayWnd ahk_exe explorer.exe")))
		WinActivate ahk_class WorkerW ahk_exe explorer.exe

	; Change desktop
	DllCall(GoToDesktopNumberProc, "Int", desktopNumber)
}

GoToDesktopNumber(desktopNumber) {
	desktopNumber := _ToRawDesktopNumber(desktopNumber)
	if (DllCall(GetCurrentDesktopNumberProc, "Int") != desktopNumber)
		_GoToRawDesktopNumber(desktopNumber)
}

GetCurrentDesktop() {
	return DllCall(GetCurrentDesktopNumberProc, "Int") + 1
}

GetDesktopCount() {
	return DllCall(GetDesktopCountProc, "Int")
}

GoToPrevDesktop() {
	_GoToRawDesktopNumber(DllCall(GetCurrentDesktopNumberProc, "Int") - 1)
}

GoToNextDesktop() {
	_GoToRawDesktopNumber(DllCall(GetCurrentDesktopNumberProc, "Int") + 1)
}

IsWindowOnCurrentDesktop(winTitle) {
	WinGet, winHwnd, ID, %winTitle%
	return IsWinHwndOnCurrentDesktop(winHwnd)
}

IsWinHwndOnCurrentDesktop(winHwnd) {
	return DllCall(IsWindowOnCurrentVirtualDesktopProc, "Ptr", winHwnd, "Int")
		> 0 ; Since the procedure may return -1 on error
}

GetWindowDesktopNumber(winTitle) {
	WinGet, winHwnd, ID, %winTitle%
	return GetWinHwndDesktopNumber(winHwnd)
}

; Can return 0 if the window doesn't belong to any desktop (e.g., pinned) or if
; an error was encountered.
GetWinHwndDesktopNumber(winHwnd) {
	return DllCall(GetWindowDesktopNumberProc, "Ptr", winHwnd, "Int") + 1
}

IsWindowPinned(winTitle) {
	WinGet, winHwnd, ID, %winTitle%
	return IsWinHwndPinned(winHwnd)
}

IsWinHwndPinned(winHwnd) {
	return DllCall(IsPinnedWindowProc, "Ptr", winHwnd, "Int")
		> 0 ; Since the procedure may return -1 on error
}

MoveWindowToDesktop(winTitle, desktopNumber) {
	WinGet, winHwnd, ID, %winTitle%
	return MoveWinHwndToDesktop(winHwnd, desktopNumber)
}

; Returns 1 on success
MoveWinHwndToDesktop(winHwnd, desktopNumber) {
	return DllCall(MoveWindowToDesktopNumberProc, "Ptr", winHwnd, "Int", _ToRawDesktopNumber(desktopNumber), "Int")
}

; Returns the total number of windows moved
TransferWindowsOfDesktop(fromDesktopNumber, toDesktopNumber) {
	fromDesktopNumber := _ToRawDesktopNumber(fromDesktopNumber)
	toDesktopNumber := _ToRawDesktopNumber(toDesktopNumber)

	WinGet, id, List
	total := 0
	Loop, %id% {
		id := id%A_Index%
		if (DllCall(GetWindowDesktopNumberProc, "Ptr", id, "Int") == fromDesktopNumber) {
			total += DllCall(MoveWindowToDesktopNumberProc, "Ptr", id, "Int", toDesktopNumber, "Int")
		}
	}
	return total
}

; Returns the total number of windows moved
TransferWindowsOfCurrentDesktop(toDesktopNumber) {
	return TransferWindowsOfDesktop(GetCurrentDesktop(), toDesktopNumber)
}
