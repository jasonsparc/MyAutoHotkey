
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

