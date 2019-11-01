
#If MouseIsOver("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")

; Easily reopen closed tab.
;
; Now a necessity, ever since Chrome's UX team made a dumb update.
;
XButton1 & MButton::^T

#If ; End If
