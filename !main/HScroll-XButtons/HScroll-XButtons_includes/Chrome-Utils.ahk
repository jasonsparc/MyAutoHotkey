
#If MouseIsOver(ChromeUtils_WinTitle)

; Easily reopen closed tab.
;
; Now a necessity, ever since Chrome's UX team made a dumb update. See,
; https://bugs.chromium.org/p/chromium/issues/detail?id=515930
;
XButton1 & MButton::
; This mimics `MButton`'s behavior in which upon pressing, activates Chrome if
; inactive. Mouse inputs should always trigger window activation anyway.
if (RequireWinActive(ChromeUtils_WinTitle))
	Send ^T
Return

;
; Utilities
;

ChromeUtils_WinTitle_init() {
	static _ := ChromeUtils_WinTitle_init()
	global ChromeUtils_WinTitle := "ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
}

#If ; End If
