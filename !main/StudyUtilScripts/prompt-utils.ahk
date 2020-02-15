
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

ShowNotice(Title) {
	if (Title) {
		Progress, A M T zh0 zx10 zy10 fs8 cwFFFFFF ct000000, %Title%
		WinActivate ahk_class AutoHotkey2
	} else {
		Progress, Off
	}
}
