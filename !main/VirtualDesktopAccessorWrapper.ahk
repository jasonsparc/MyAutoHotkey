; https://github.com/Ciantic/VirtualDesktopAccessor

; Must hard code to function correctly with #includes
LibDir = %A_MyDocuments%\AutoHotkey\!submodules\VirtualDesktopAccessor\x64\Release

hVirtualDesktopAccessor := DllCall("LoadLibrary", Str, LibDir . "\VirtualDesktopAccessor.dll", "Ptr")
global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
global GetDesktopCountProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetDesktopCount", "Ptr")
global IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnCurrentVirtualDesktop", "Ptr")
global GetWindowDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetWindowDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
global IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")

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
	DllCall(GoToDesktopNumberProc, Int, desktopNumber)
}

GoToDesktopNumber(desktopNumber) {
	desktopNumber := _ToRawDesktopNumber(desktopNumber)
	if (DllCall(GetCurrentDesktopNumberProc, UInt) != desktopNumber)
		_GoToRawDesktopNumber(desktopNumber)
}

GetCurrentDesktop() {
	return DllCall(GetCurrentDesktopNumberProc, UInt) + 1
}

GetDesktopCount() {
	return DllCall(GetDesktopCountProc, UInt)
}

GoToPrevDesktop() {
	_GoToRawDesktopNumber(DllCall(GetCurrentDesktopNumberProc, UInt) - 1)
}

GoToNextDesktop() {
	_GoToRawDesktopNumber(DllCall(GetCurrentDesktopNumberProc, UInt) + 1)
}

IsWindowOnCurrentDesktop(windowTitle) {
	WinGet, winHwnd, ID, %windowTitle%
	return IsWinHwndOnCurrentDesktop(winHwnd)
}

IsWinHwndOnCurrentDesktop(winHwnd) {
	return DllCall(IsWindowOnCurrentVirtualDesktopProc, UInt, winHwnd)
}

GetWindowDesktopNumber(windowTitle) {
	WinGet, winHwnd, ID, %windowTitle%
	return GetWinHwndDesktopNumber(winHwnd)
}

GetWinHwndDesktopNumber(winHwnd) {
	return DllCall(GetWindowDesktopNumberProc, UInt, winHwnd) + 1
}

IsWindowPinned(windowTitle) {
	WinGet, winHwnd, ID, %windowTitle%
	return IsWinHwndPinned(winHwnd)
}

IsWinHwndPinned(winHwnd) {
	return DllCall(IsPinnedWindowProc, UInt, winHwnd)
}

MoveWindowToDesktop(windowTitle, desktopNumber) {
	WinGet, winHwnd, ID, %windowTitle%
	MoveWinHwndToDesktop(winHwnd, desktopNumber)
}

MoveWinHwndToDesktop(winHwnd, desktopNumber) {
	DllCall(MoveWindowToDesktopNumberProc, UInt, winHwnd, UInt, _ToRawDesktopNumber(desktopNumber))
}

TransferWindowsOfDesktop(fromDesktopNumber, toDesktopNumber) {
	fromDesktopNumber := _ToRawDesktopNumber(fromDesktopNumber)
	toDesktopNumber := _ToRawDesktopNumber(toDesktopNumber)

	WinGet, id, List
	Loop, %id% {
		id := id%A_Index%
		if (DllCall(GetWindowDesktopNumberProc, UInt, id) == fromDesktopNumber) {
			DllCall(MoveWindowToDesktopNumberProc, UInt, id, UInt, toDesktopNumber)
		}
	}
}

TransferWindowsOfCurrentDesktop(toDesktopNumber) {
	TransferWindowsOfDesktop(GetCurrentDesktop(), toDesktopNumber)
}
