
; Just some handy hotkeys for Media Player Classic
;

MPC_init() {
	static _ := MPC_init()
	global MPC_WinTitle := "ahk_class MediaPlayerClassicW"
}

; --
; MPC's Main/Player Window
#If WinActive(MPC_WinTitle)

; Alternative "Play/Pause" button
NumpadIns::
Send {Media_Play_Pause}
KeyWait NumpadIns ; Prevents the keyboard's auto-repeat feature
Return

XButton1 & RButton::Return ; NOP – to prevent closing video
XButton1 & LButton::Return ; NOP – to prevent activating the device recorder

; --
; …when playing in the background
#If !WinActive(MPC_WinTitle)
&& (MPC_IsPlaying_List_cached := MPC_IsPlaying_List()).Length()

; Quick "Pause" button
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
		if (ControlGetText("Static3", "ahk_id " g%A_Index%) == "Playing")
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

