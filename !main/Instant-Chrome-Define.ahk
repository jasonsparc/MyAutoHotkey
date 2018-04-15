#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
Menu, Tray, Icon, DDORes.dll, 34

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

#Include <study-utils>

Return ; ***
; -------------------------------------------------------------------------

; Utilities

; ...
;
