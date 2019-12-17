#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
Gosub InitSetup

; -------------------------------------------------------------------------

!#d::
~XButton1 & d::
	OutHwnd := OpenWaitHwnd("chrome.exe", "--new-window")
	HandleStudyWinPos(OutHwnd, 1)
	Send % "define "
Return

; -------------------------------------------------------------------------
Return ; ***
InitSetup:

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Icon, DDORes.dll, 34

#Include <study-utils>

Return ; ***
; -------------------------------------------------------------------------

; Utilities

; ...
;
