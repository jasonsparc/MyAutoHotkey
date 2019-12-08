
global ___Clipboard_PseudoStack ; `ClipboardAll` breaks on non-pseudo-arrays

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

GetSelectedText(Timeout:="") {
	local ; --
	tmp := ClipboardAll
	Clipboard := ""
	SendInput, ^c
	ClipWait, %Timeout%
	ret := ErrorLevel ? "" : Clipboard
	Clipboard := tmp
	return ret
}
