
global ___Clipboard_PseudoStack ; `ClipboardAll` breaks on non-pseudo-arrays

___ClipboardUtils_init() {
	static _ := ___ClipboardUtils_init()
	___Clipboard_PseudoStack := 0
}

ClipboardPush(NewText:="") {
	local tmp ; Necessary, otherwise the code below won't work.
	tmp := ClipboardAll
	___Clipboard_PseudoStack++
	___Clipboard_PseudoStack%___Clipboard_PseudoStack% := tmp
	Clipboard := NewText
}

ClipboardPop() {
	if (!___Clipboard_PseudoStack)
		return

	Clipboard := ___Clipboard_PseudoStack%___Clipboard_PseudoStack%
	___Clipboard_PseudoStack%___Clipboard_PseudoStack% := ""
	___Clipboard_PseudoStack--
}

GetSelectedText(Timeout:=1) {
	local ; --
	tmp := ClipboardAll
	Clipboard := ""
	SendInput, ^c
	ClipWait, % Timeout+0 ? Timeout : 1
	ret := ErrorLevel ? "" : Clipboard
	Clipboard := tmp
	tmp := "" ; Free the memory in case the clipboard was very large
	return ret
}

ClipWait(Timeout:="", WaitForAnyData:="") {
	ClipWait, %Timeout%, %WaitForAnyData%
	return !ErrorLevel
}

ClipWaitText(ExpectedText, Timeout:=0.5) {
	local ; --
	Timeout := Timeout+0 ? Max(Timeout*1000, 500) : 500
	EndTick := A_TickCount + Timeout
	ClipWait, %Timeout%
	loop {
		if (Clipboard == ExpectedText)
			return true
		if (A_TickCount >= EndTick)
			return false
		Sleep 50
	}
}
