
; Just some extras for easy screen snipping.
;

SnippingTool_init() {
	local ; --
	static _ := SnippingTool_init()

	EnvGet windir, windir
	global SnippingTool_exe := windir "\system32\SnippingTool.exe"
	global SnippingTool_WinTitle := "ahk_exe " SnippingTool_exe
	; ^- To simplify things, we avoid `ahk_class`, since the snip editor has a
	; different window class, and would have to be treated specially otherwise.

	global SnippingTool_SnipEditor_WinTitle
		:= "ahk_class Microsoft-Windows-SnipperEditor " SnippingTool_WinTitle
}

; Instant rectangular snip
XButton1 & s::
DetectHiddenWindows On
if (WinExist(SnippingTool_WinTitle)) {
	Process Close, % WinGet("PID")
	WinWaitClose,,, 1
	if (ErrorLevel)
		return
}
Run %SnippingTool_exe%
WinWaitActive %SnippingTool_WinTitle%
if (ErrorLevel)
	return
Send {alt down}mr{alt up}
Return

; --
; Snipping Tool Window
#If WinActive(SnippingTool_WinTitle)

; Quickly close snipping tool
XButton1 & q::
WinClose ahk_exe %SnippingTool_exe%
Return

; Quickly switch to window snip
XButton1 & w::
Send {alt down}mw{alt up}
Goto SnippingTool_ForceNewSnipIfInEditor

; Quickly switch to fullscreen snip
XButton1 & f::
Send {alt down}ms{alt up}
Goto SnippingTool_ForceNewSnipIfInEditor

; Quickly switch to rectangular snip
XButton1 & r::
XButton1 & s::
Send {alt down}mr{alt up}
Goto SnippingTool_ForceNewSnipIfInEditor

SnippingTool_ForceNewSnipIfInEditor:
if (WinActive(SnippingTool_SnipEditor_WinTitle))
	Send !n
Return

#If ; End If

