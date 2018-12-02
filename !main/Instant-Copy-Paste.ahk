#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
Menu, Tray, Icon, shell32.dll, 135

Gosub InitSetup

; -------------------------------------------------------------------------

~XButton1 & c::^c
~XButton1 & RButton::^c

~XButton1 & v::^v
~XButton1 & LButton::^v

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
