
global ___Clipboard_PseudoStack ; `ClipboardAll` breaks on non-pseudo-arrays

___ClipboardUtils_init() {
	static _ := ___ClipboardUtils_init()
	___Clipboard_PseudoStack := 0
}

ClipboardPush(NewText:="") {
	local tmp ; (Weird but) Necessary, otherwise the code below won't work.
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

PasteText(txt) {
	local ; --
	Old_IsCritical := A_IsCritical
	Critical ; Prevent interruption

	bak := ClipboardAll
	Clipboard := txt

	wasLCtrlDn := GetKeyState("LCtrl")
	wasRCtrlDn := GetKeyState("RCtrl")

	SendInput, ^v

	if (wasLCtrlDn == 1)
		Send {LCtrl down}
	if (wasRCtrlDn == 1)
		Send {RCtrl down}

	Sleep 50 ; Prevent pasting `bak` below accidentally due to race
	Clipboard := bak
	bak := "" ; Free the memory in case the clipboard was very large

	Critical %Old_IsCritical% ; Restore old setting
	Sleep -1 ; Force any pending interruptions to occur
}

GetSelectedText(Timeout:=1) {
	local ; --
	Old_IsCritical := A_IsCritical
	Critical ; Prevent interruption

	bak := ClipboardAll
	Clipboard := "" ; Empty to allow ClipWait to detect when text has arrived

	wasLCtrlDn := GetKeyState("LCtrl")
	wasRCtrlDn := GetKeyState("RCtrl")

	SendInput, ^c

	if (wasLCtrlDn == 1)
		Send {LCtrl down}
	if (wasRCtrlDn == 1)
		Send {RCtrl down}

	ClipWait, % Timeout+0 ? Timeout : 1
	ret := ErrorLevel ? "" : Clipboard

	Clipboard := bak
	bak := "" ; Free the memory in case the clipboard was very large

	Critical %Old_IsCritical% ; Restore old setting
	Sleep -1 ; Force any pending interruptions to occur

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

ClipWaitTextChange(FromExpectedText, ToExpectedText, Timeout:=0.5) {
	local ; --
	Timeout := Timeout+0 ? Max(Timeout*1000, 500) : 500
	EndTick := A_TickCount + Timeout
	ClipWait, %Timeout%
	loop {
		c := Clipboard
		if (c == ToExpectedText)
			return true
		if (A_TickCount >= EndTick || c != FromExpectedText)
			return false
		Sleep 50
	}
}

ClipWaitTextChangeToAny(FromExpectedText, Timeout:=0.5) {
	local ; --
	Timeout := Timeout+0 ? Max(Timeout*1000, 500) : 500
	EndTick := A_TickCount + Timeout
	ClipWait, %Timeout%
	loop {
		if (Clipboard != FromExpectedText)
			return true
		if (A_TickCount >= EndTick)
			return false
		Sleep 50
	}
}
