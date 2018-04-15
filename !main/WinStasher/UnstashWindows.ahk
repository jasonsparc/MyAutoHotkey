#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include <VirtualDesktopAccessorWrapper>

MsgBox, 36, Unstash Windows, Pop the last desktop and move all its windows here?
IfMsgBox No
	Exit

WinActivate ahk_class WorkerW ahk_exe explorer.exe
CurDesktop := GetCurrentDesktop()
LastDesktop := GetDesktopCount()

if (CurDesktop == LastDesktop) {
	Exit
}

GoToDesktopNumber(LastDesktop)
TransferWindowsOfDesktop(LastDesktop, CurDesktop)

SendInput ^#{F4}
GoToDesktopNumber(CurDesktop)
