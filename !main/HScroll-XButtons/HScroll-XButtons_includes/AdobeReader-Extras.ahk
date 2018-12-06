
; Just some extras for Adobe Reader that augments the reading experience.
;

#If MouseIsOver("ahk_class AcrobatSDIWindow ahk_exe AcroRd32.exe")

XButton1 & Space::
XButton1 & MButton::
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

