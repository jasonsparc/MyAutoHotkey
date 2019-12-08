
GetSelectedText(Timeout:=1) {
	local ; --
	tmp := ClipboardAll
	Clipboard := ""
	SendInput, ^c
	ClipWait, %Timeout%
	ret := ErrorLevel ? "" : Clipboard
	Clipboard := tmp
	return ret
}
