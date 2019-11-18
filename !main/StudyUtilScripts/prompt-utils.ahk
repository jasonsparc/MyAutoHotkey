
IsMsgBox(ButtonName) {
	IfMsgBox %ButtonName%
		return true
	return false
}

Prompt(AskTitle:="Start Routine", AskMsg:="", HasCancel:=false, ExitOnCancel:=false, ExtraOptions:=0) {
	MsgBox, % (HasCancel ? 35 : 36) + ExtraOptions, %AskTitle%, %AskMsg%
	IfMsgBox Yes
		return true
	IfMsgBox Cancel
		If ExitOnCancel
			Exit
	return false
}
