
#If MouseIsOver("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")

; Easily reopen closed tab.
;
; Now a necessity, ever since Chrome's UX team made a dumb update. See,
; https://bugs.chromium.org/p/chromium/issues/detail?id=515930
;
XButton1 & MButton::
; This mimics `MButton`'s behavior in which upon pressing, activates Chrome if
; inactive. Mouse inputs should always trigger window activation anyway.
if (RequireWinActive())
	Send ^T
Return

; - - = - = - = - - - +
; NOTE: Not using `MouseIsOver` since our remaps involve non-modifier keys.
#IfWinActive ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

; Quickly open/close the "Developer Tools"
XButton1 & `::^I

; Quickly inspect an element
XButton1 & q::^C

#If ; End If
