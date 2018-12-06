#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
Menu, Tray, Icon, imageres.dll, 244

SetMouseDelay, -1
Return

;-=-=-=- * * * -=-=-=-

; Scroll left
XButton1 & WheelUp::
StabilizeScroll()
Click WheelLeft %A_EventInfo%
Return

; Scroll right
XButton1 & WheelDown::
StabilizeScroll()
Click WheelRight %A_EventInfo%
Return

; Make XButton1 NOP
XButton1::Return


;-=-=-=- * * * -=-=-=-
; Utilities for our custom handler includes

GetHScrollLines() {
	; https://autohotkey.com/board/topic/8435-mouse-wheel-speed/
	; https://msdn.microsoft.com/en-us/library/windows/desktop/ms724947(v=vs.85).aspx
	;
	; retrieve original horizontal scroll wheel setting
	; #define SPI_GETWHEELSCROLLCHARS    0x6C
	DllCall("SystemParametersInfo", UInt, 0x6C, UInt, 0, UIntP, Scroll_Lines, UInt, 0) 
	return Scroll_Lines
}

MouseIsOver(WinTitle) {
	MouseGetPos,,, Win
	return WinExist(WinTitle . " ahk_id " . Win)
}

; Needed because mouse wheel sometimes becomes unstable when another button is held.
;
; See,
; https://superuser.com/questions/297798/mouse-wheel-scrolls-the-page-down-then-up-or-up-then-down
StabilizeScroll() {
	if (A_PriorHotkey && A_PriorHotkey != A_ThisHotkey && A_TimeSincePriorHotkey < 500)
		Exit
}

;-=-=-=- * * * -=-=-=-
; Custom handler includes

; Changes the working directory for subsequent #Includes and FileInstalls.
#Include %A_ScriptDir%\HScroll-XButtons_includes

#Include Instant-Copy-Paste.ahk
#Include AdobeReader+Extras.ahk
#Include AndroidStudio.ahk
#Include Blender.ahk
#Include Excel.ahk
#Include Notepad2.ahk
#Include VisualStudio.ahk

;-+-*-+-


;-=-=-=- * * * -=-=-=-
; The END

