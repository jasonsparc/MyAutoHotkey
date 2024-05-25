
; Just some extras for easy screen snipping.
;

SnippingTool_init()
SnippingTool_init() {
	windir := EnvGet("windir")
	global SnippingTool_exe := windir "\system32\SnippingTool.exe"
	GroupAdd "SnippingTool", "ahk_exe " SnippingTool_exe
	; ^- To simplify things, we avoid `ahk_class`, since the snip editor has a
	; different window class, and would have to be treated specially otherwise.
	GroupAdd "SnippingToolEditor",
		"ahk_class Microsoft-Windows-SnipperEditor ahk_exe " SnippingTool_exe
}
SnippingTool_IsInEditor() => WinActive("ahk_group SnippingToolEditor")
SnippingTool_NewSnipSeqIfInEditor() => SnippingTool_IsInEditor() ? "!n" : ""

; Instant rectangular snip
XButton2 & s::{
	DetectHiddenWindows true
	if WinExist("ahk_group SnippingTool") {
		ProcessClose WinGetPID()
		if !WinWaitClose(,, 1)
			return ; Timed out
	}
	Run SnippingTool_exe
	if !WinWaitActive("ahk_group SnippingTool")
		return ; Timed out
	Send "{alt down}mr{alt up}"
	KeyWait "s" ; Suppresses auto-repeat
}

; --
; Snipping Tool Window
#HotIf WinActive("ahk_group SnippingTool")

; Quickly close snipping tool
XButton2 & q up::WinClose

; Quickly cancel snip
XButton2 & x up::
XButton2 & c up::{
	if (!SnippingTool_IsInEditor())
		Send "{alt down}c{alt up}"
}

; Quickly switch to free-form snip
XButton2 & d::{
	Send SnippingTool_NewSnipSeqIfInEditor() "{alt down}mf{alt up}"
	KeyWait "d" ; Suppresses auto-repeat
}

; Quickly switch to rectangular snip
XButton2 & s::
XButton2 & r::{
	Send SnippingTool_NewSnipSeqIfInEditor() "{alt down}mr{alt up}"
	KeyWait "r" ; Suppresses auto-repeat
	KeyWait "s"
}

; Quickly switch to window snip
XButton2 & w::{
	Send SnippingTool_NewSnipSeqIfInEditor() "{alt down}mw{alt up}"
	KeyWait "w" ; Suppresses auto-repeat
}

; Quickly switch to fullscreen snip
XButton2 & f::{
	Send SnippingTool_NewSnipSeqIfInEditor() "{alt down}ms{alt up}"
	KeyWait "f" ; Suppresses auto-repeat
}

#HotIf
