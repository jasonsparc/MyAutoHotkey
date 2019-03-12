﻿
; Adobe Reader currently does not support `WheelLeft` and `WheelRight` mouse
; events for horizontal scrolls.
;
; But it does provide `Shift + Wheel[Up/Down]` for horizontal scrolls, so we
; simulate that instead.
;
; Also, some extras for Adobe Reader that augments the reading experience.
;

#If MouseIsOver("ahk_class AcrobatSDIWindow ahk_exe AcroRd32.exe")

XButton1 & WheelUp::
StabilizeScroll()
Send {shift down}{WheelUp %A_EventInfo%}
Return

XButton1 & WheelDown::
StabilizeScroll()
Send {shift down}{WheelDown %A_EventInfo%}
Return

~XButton1 up::
Send {shift up}
Return

; Handy mappings to quickly toggle between the "Hand Tool" and "Select Tool"
XButton1 & Space::
XButton1 & MButton::
XButton1 & LButton::
AdobeReader_ToggleHandOrSelect()
Return

; Handy mappings to quickly "Highlight" the current selection
XButton1 & q::
!q::
!+q::
^+q::
XButton1 & x::
!x::
!+x::
^+x::
Send {AppsKey}h
Return

; Mouse mappings for undo and redo
XButton1 & z::^z
XButton1 & y::^+z

; Correct "redo" mapping
^y::^+z

; Mouse mappings for the delete key
XButton1 & d::Delete

;
; Utilities
;

AdobeReader_ToggleHandOrSelect() {
	static SelectToolSet := AdobeReader_RegRead_DefaultSelect()

	if (SelectToolSet) {
		Send h
		SelectToolSet := false
	} else {
		Send v
		SelectToolSet := true
	}
}

AdobeReader_RegRead_DefaultSelect() {
	RegRead v, HKCU\Software\Adobe\Acrobat Reader\DC\Selection, aDefaultSelect
	return v == "Select" ? true : false
}

#If ; End If

