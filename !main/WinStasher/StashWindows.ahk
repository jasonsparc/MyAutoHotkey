#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include <VirtualDesktopAccessorWrapper>

MsgBox, 36, Stash Windows, Push all windows to a new desktop?
IfMsgBox No
	Exit

WinActivate ahk_class WorkerW ahk_exe explorer.exe
CurDesktop := GetCurrentDesktop()

Send ^#d
Sleep 50

GoToDesktopNumber(CurDesktop)
TransferWindowsOfDesktop(CurDesktop, GetDesktopCount())
