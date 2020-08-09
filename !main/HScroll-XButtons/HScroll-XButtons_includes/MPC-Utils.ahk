
; Just some handy hotkeys for Media Player Classic
;

; --
; MPC's Main/Player Window
#IfWinActive ahk_class MediaPlayerClassicW ahk_exe mpc-hc64.exe

; Alternative "Play/Pause" button
NumpadIns::Media_Play_Pause

; --
; …when playing in the background
#If WinExist("ahk_class MediaPlayerClassicW ahk_exe mpc-hc64.exe")
&& ControlGetText("Static3", "ahk_class MediaPlayerClassicW") == "Playing"

; Quick "Pause" button
NumpadIns::
; See, https://www.autohotkey.com/boards/viewtopic.php?p=155967#p155967
SendMessage, 0x111, 888,,, ahk_class MediaPlayerClassicW ; MEDIA_PAUSE
Return

#If ; End If

