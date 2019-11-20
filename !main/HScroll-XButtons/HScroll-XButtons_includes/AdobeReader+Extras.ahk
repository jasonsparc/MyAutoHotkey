
; Adobe Reader currently does not support `WheelLeft` and `WheelRight` mouse
; events for horizontal scrolls.
;
; But it does provide `Shift + Wheel[Up/Down]` for horizontal scrolls, so we
; simulate that instead.
;
; Also, some extras for Adobe Reader that augments the reading experience.
;

AdobeReader_init() {
	static _ := AdobeReader_init()
	global AdobeReader_WinTitle := "ahk_class AcrobatSDIWindow ahk_exe AcroRd32.exe"
}

#If MouseIsOver(AdobeReader_WinTitle)

XButton1 & WheelUp::
StabilizeScroll()
Send {shift down}{WheelUp %A_EventInfo%}
AdobeReader_HeldKeys := true
Return

XButton1 & WheelDown::
StabilizeScroll()
Send {shift down}{WheelDown %A_EventInfo%}
AdobeReader_HeldKeys := true
Return

; Auto-release held keys regardless of active window or current mouseover
#If AdobeReader_HeldKeys

~XButton1 up::
AdobeReader_HeldKeys := false
Send {shift up}
Return

#If ; End If --------------------------------------------------------------

;
; Extras
;

#If MouseIsOver(AdobeReader_WinTitle)

; Handy mappings to quickly toggle between the "Hand Tool" and "Select Tool"
XButton1 & MButton::
XButton1 & LButton::
If (RequireWinActive(AdobeReader_WinTitle))
	Goto AdobeReader_ToggleHandOrSelect
Return

; Handy mappings to quickly copy "highlight"-objects
; NOTE: It requires a different handling than a mere `CTRL+C`
^RButton::
If (RequireWinActive(AdobeReader_WinTitle))
	Goto AdobeReader_CopyObjects
Return

; - - = - = - = - - - +
#If WinActive(AdobeReader_WinTitle)

; Handy mappings to quickly toggle between the "Hand Tool" and "Select Tool"
XButton1 & Space::
AdobeReader_ToggleHandOrSelect:
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

; Handy mappings to quickly copy "highlight"-objects
; NOTE: It requires a different handling than a mere `CTRL+C`
XButton1 & c::
AdobeReader_CopyObjects:
Send {Esc}{RButton}c
Return

; Mouse mappings for undo and redo
XButton1 & z::^z
XButton1 & y::^+z

; Correct "redo" mapping
^y::^+z

; Mouse mappings for the delete key
XButton1 & `::
^`::
!`::
Send {Delete}
Return

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

