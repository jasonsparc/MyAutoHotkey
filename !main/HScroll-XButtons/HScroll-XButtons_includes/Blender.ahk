
; Blender currently does not support `WheelLeft` and `WheelRight` mouse events
; for horizontal scrolls.
;
; But it does provide `Ctrl + Wheel[Up/Down]` for horizontal scrolls, so we can
; simulate that instead.
;
; Also, provides a handy mapping for zooming in/out.
;

Blender_init() {
	static _ := Blender_init()
	global Blender_WinTitle := "ahk_class GHOST_WindowClass ahk_exe blender.exe"
}

; NOTE: Not using `MouseIsOver` here since Blender doesn't consume key input
; events (including modifier keys) when its window is inactive.
#If WinActive(Blender_WinTitle)

XButton1 & WheelUp::
Send {blind}{ctrl down}{WheelUp %A_EventInfo%}
Blender_HeldKeys := true
Return

XButton1 & WheelDown::
Send {blind}{ctrl down}{WheelDown %A_EventInfo%}
Blender_HeldKeys := true
Return

; Auto-release held keys regardless of current mouseover
#If Blender_HeldKeys

*~XButton1 up::
Blender_HeldKeys := false
SendInput {ctrl up}
Return

#If ; End If --------------------------------------------------------------

; Extras
;

#If WinActive(Blender_WinTitle)

; Handy mapping for zooming
XButton1 & MButton::SendInput {ctrl down}{MButton down}
XButton1 & MButton up::SendInput {ctrl up}{MButton up}

#If ; End If

