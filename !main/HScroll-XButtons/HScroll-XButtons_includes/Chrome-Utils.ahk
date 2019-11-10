
#IfWinActive ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

; Easily reopen closed tab.
;
; Now a necessity, ever since Chrome's UX team made a dumb update. See,
; https://bugs.chromium.org/p/chromium/issues/detail?id=515930
;
XButton1 & MButton::^T

#If ; End If
