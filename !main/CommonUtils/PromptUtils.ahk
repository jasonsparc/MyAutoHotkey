
IsMsgBox(ButtonName) {
	IfMsgBox %ButtonName%
		return true
}

Prompt(AskTitle:="Start Routine", AskMsg:="", HasCancel:=false, ExitOnCancel:=false, ExtraOptions:=0) {
	MsgBox, % (HasCancel ? 35 : 36) + ExtraOptions, %AskTitle%, %AskMsg%
	IfMsgBox Yes
		return true
	IfMsgBox Cancel
		If ExitOnCancel
			Exit
}

Show(Title:="", OnCloseCallback:="") {
	local ; --
	global Show____GuiClose_Callback, Show____Hwnd

	if (OnCloseCallback && !IsFunc(OnCloseCallback) && !IsFunc(OnCloseCallback.__Call))
		throw Exception("Parameter #2 must either be a valid function object or left blank.", -1)

	B_IsCritical := A_IsCritical
	Critical

	if (Title) {
		Progress, A M T zh0 zx10 zy10 fs8 cwFFFFFF ct000000, %Title%
		WinActivate ahk_class AutoHotkey2
		if (OnCloseCallback) {
			Show____Hwnd := WinExist("A")
			Show____GuiClose_Callback := OnCloseCallback
			SetTimer, Show____CheckClose, 500
		}
	} else {
		if (Show____GuiClose_Callback) {
			SetTimer, Show____CheckClose, Off
			Show____GuiClose_Callback := ""
			Show____Hwnd := 0
		}
		Progress, Off
	}

	Critical, %B_IsCritical%
}

Show____CheckClose() {
	local ; --
	global Show____GuiClose_Callback, Show____Hwnd
	DetectHiddenWindows On
	if (!WinExist("ahk_id " Show____Hwnd)) {
		callback := Show____GuiClose_Callback ; Backup
		Show() ; Turn off
		%callback%()
	}
}
