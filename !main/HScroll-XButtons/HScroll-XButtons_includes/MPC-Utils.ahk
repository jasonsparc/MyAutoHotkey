﻿
; Just some handy hotkeys for Media Player Classic
;

MPC_init() {
	static _ := MPC_init()
	global MPC_WinTitle := "ahk_class MediaPlayerClassicW"
}

; --
; MPC's Main/Player Window
#If WinActive(MPC_WinTitle)

;XButton1 & RButton::Return ; NOP – to prevent closing video
;XButton1 & LButton::Return ; NOP – to prevent activating the device recorder

; Alternative "Play/Pause" button
XButton1 & RButton::
XButton1 & LButton::
XButton1 & MButton::
Send {Media_Play_Pause}
;KeyWait MButton ; Prevents the keyboard's auto-repeat feature
Return

; Alternative "Play/Pause" button
XButton1 & Space::
Send {Media_Play_Pause}
KeyWait Space ; Prevents the keyboard's auto-repeat feature
Return

; Alternative "Play/Pause" button that complements the "Numpad Task View
; Hotkeys" of `TaskView-SuperHotKeys.ahk`
NumpadClear & NumpadRight::
MPC_Only_NumpadClear := false
Send {Media_Play_Pause}
; Prevents the keyboard's auto-repeat feature
KeyWait NumpadClear
KeyWait NumpadRight
Return

; Another alternative "Play/Pause" button that complements the "Numpad Task
; View Hotkeys" of `TaskView-SuperHotKeys.ahk`
~NumpadClear::
MPC_Last_TickCount := A_TickCount
MPC_Only_NumpadClear := true
KeyWait NumpadClear
if (MPC_Only_NumpadClear) {
	MPC_Only_NumpadClear := false
	if ((A_TickCount - MPC_Last_TickCount) < 1500 && WinActive(MPC_WinTitle))
		Send {Media_Play_Pause}
}
Return
; ^NOTE: `NumpadClear` is used by `TaskView-SuperHotKeys.ahk` to trigger
; navigation to a different desktop. So we delay our intended action primarily
; for that possibility. We only proceed once `NumpadClear` is released, and it
; must be released while MPC is 'still' the active window.
;
; We could've mapped via `NumpadClear up` but that'll trigger our hotkey even
; when `NumpadClear` was held down outside of MPC, e.g., as a consequence of
; navigating from another desktop.
;
; So in a nutshell, the goal really is to ensure that `NumpadClear` is both
; pressed and released inside MPC only.
; ---

; Another alternative "Play/Pause" button that complements the "Numpad Task
; View Hotkeys" of `TaskView-SuperHotKeys.ahk`
NumpadIns::
Send {Media_Play_Pause}
KeyWait NumpadIns ; Prevents the keyboard's auto-repeat feature
Return

; --
; …when playing in the background
#If !WinActive(MPC_WinTitle)
&& (MPC_IsPlaying_List_cached := MPC_IsPlaying_List()).Length()

; Quick "Pause" button
XButton1 & RButton::
XButton1 & LButton::
XButton1 & MButton::
XButton1 & Space::
NumpadClear & NumpadRight::
NumpadIns::
MPC_Pause_IsPlaying_List(MPC_IsPlaying_List_cached)
Return

MPC_IsPlaying_List() {
	local ; --
	DetectHiddenWindows On ; Required for when we're on a different desktop
	WinGet, g, List, % MPC_WinTitle
	l := []
	l.SetCapacity(g)
	loop % g
		if (ControlGetText("Static3", "ahk_id " g%A_Index%) ~= "A)Playing")
			l.Push(g%A_Index%)
	return l
}

MPC_Pause_IsPlaying_List(l) {
	local ; --
	DetectHiddenWindows On ; Required for when we're on a different desktop
	loop % l.Length() {
		; See, https://www.autohotkey.com/boards/viewtopic.php?p=155967#p155967
		SendMessage, 0x111, 888,,, % "ahk_id " l[A_Index] ; MEDIA_PAUSE
	}
}

#If ; End If

