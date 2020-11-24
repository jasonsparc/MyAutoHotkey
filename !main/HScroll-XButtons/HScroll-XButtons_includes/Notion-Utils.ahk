
#If MouseIsOver("ahk_class Chrome_WidgetWin_1 ahk_exe Notion.exe")

; Replaces less useful `MButton` function with something more useful:
; Open links (if hovering any) in a new window.
;
MButton::
; Mouse inputs should always trigger window activation anyway.
if (RequireWinActive())
	Send ^{LButton}
Return

#If ; End If
