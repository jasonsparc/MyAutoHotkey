﻿
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

*~XButton1 up::
AdobeReader_HeldKeys := false
Send {shift up}
Return

#If ; End If --------------------------------------------------------------

;
; Extras
;

#If MouseIsOver(AdobeReader_WinTitle)
&& not AdobeReader_AnyEditCtrlInFocus(true)

; Handy mappings to quickly toggle between the "Hand Tool" and "Select Tool"
XButton1 & MButton::
XButton1 & LButton::
If (RequireWinActive() && !AdobeReader_AnyEditCtrlInFocus(true))
	AdobeReader_ToggleHandOrSelect()
Return

; Handy mappings to quickly copy "highlight"-objects
; NOTE: It requires a different handling than a mere `CTRL+C`
^RButton::
If (RequireWinActive() && !AdobeReader_AnyEditCtrlInFocus(true))
	AdobeReader_CopyObjects()
Return

; - - = - = - = - - - +
#If WinActive(AdobeReader_WinTitle)
&& not AdobeReader_AnyEditCtrlInFocus(true)

; Handy mappings to quickly toggle between the "Hand Tool" and "Select Tool"
XButton1 & Space::
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
AdobeReader_CopyObjects()
Return

; Mouse mapping for "Find"
XButton1 & f::^f

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

; Convenience when inputting page numbers
#If MouseIsOver_ControlGetText(AdobeReader_WinTitle) == "AVTopBarView"
&& AdobeReader_AnyEditCtrlInFocus(true)

; Quickly press "Enter" via the mouse alone
XButton1 & MButton::
MButton::Enter

#If ; End If --------------------------------------------------------------

;
; Utilities
;

AdobeReader_IsPageViewInFocus(ViaLastFound:=false) {
	; From AHK docs of `ControlGetFocus`:
	; > The target window must be active to have a focused control. If the
	; > window is not active, _OutputVar_ will be made blank.
	return (ViaLastFound || WinActive(AdobeReader_WinTitle))
		&& ControlGetText(ControlGetFocus()) == "AVPageView"
}

AdobeReader_AnyEditCtrlInFocus(ViaLastFound:=false) {
	return ControlGetFocus(ViaLastFound ? "" : AdobeReader_WinTitle) ~= "i)edit"
}

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

; Quickly copy "highlight"-objects
; NOTE: It requires a different handling than a mere `CTRL+C`
AdobeReader_CopyObjects() {
	Send {Esc}{RButton}c
}

AdobeReader_RegRead_DefaultSelect() {
	RegRead v, HKCU\Software\Adobe\Acrobat Reader\DC\Selection, aDefaultSelect
	return v == "Select" ? true : false
}

#If ; End If

