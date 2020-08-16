﻿
; Just some handy hotkeys for Media Player Classic
;

; --
; MPC's Main/Player Window
#IfWinActive ahk_class MediaPlayerClassicW ahk_exe mpc-hc64.exe

; Alternative "Play/Pause" button
NumpadIns::Media_Play_Pause

XButton1 & RButton::Return ; NOP – to prevent closing video
XButton1 & LButton::Return ; NOP – to prevent activating the device recorder

; --
; …when playing in the background
#If MPC_IsPlaying()

; Quick "Pause" button
NumpadIns::
DetectHiddenWindows On ; Required for when we're on a different desktop
; See, https://www.autohotkey.com/boards/viewtopic.php?p=155967#p155967
SendMessage, 0x111, 888,,, ahk_class MediaPlayerClassicW ; MEDIA_PAUSE
Return

MPC_IsPlaying() {
	DetectHiddenWindows On ; Required for when we're on a different desktop
	return WinExist("ahk_class MediaPlayerClassicW ahk_exe mpc-hc64.exe")
		&& ControlGetText("Static3") == "Playing"
}

#If ; End If

