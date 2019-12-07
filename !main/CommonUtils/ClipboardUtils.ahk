
GetSelectedText(Timeout:=1) {
	local ; --
	tmp := ClipboardAll
	Clipboard := ""
	Sleep 50
	SendInput, ^c
	ClipWait, %Timeout%
	ret := ErrorLevel ? "" : Clipboard
	Clipboard := tmp
	return ret
}
