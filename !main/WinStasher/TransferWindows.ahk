#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include <VirtualDesktopAccessorWrapper>

global Commenced = 0
global Timeout = 5

MsgBox, 0, % "Transfer Windows", % "Currently at Desktop " . GetCurrentDesktop() . "`r`n`r`nPress any FN or Num key to transfer all windows to a corresponding desktop.`r`n`r`nOtherwise, simply close this dialog.", % Timeout
ExitApp

CommenceTransfer(dest) {
	if (Commenced)
		Return
	if (dest > GetDesktopCount())
		Return
	Commenced = 1

	MsgBox, 33, Transfer Windows, Transfer to Desktop %dest%?
	IfMsgBox Cancel
		ExitApp

	TransferWindowsOfCurrentDesktop(dest)
	GoToDesktopNumber(dest)
	ExitApp
}

Tab::
`::Enter

0::
CommenceTransfer(GetDesktopCount())
ExitApp

1::
F1::CommenceTransfer(1)
2::
F2::CommenceTransfer(2)
3::
F3::CommenceTransfer(3)
4::
F4::CommenceTransfer(4)
5::
F5::CommenceTransfer(5)
6::
F6::CommenceTransfer(6)
7::
F7::CommenceTransfer(7)
8::
F8::CommenceTransfer(8)
9::
F9::CommenceTransfer(9)

F10::CommenceTransfer(10)
F11::CommenceTransfer(11)
F12::CommenceTransfer(12)

; More function keys at the top of other keyboards

F13::CommenceTransfer(13)
F14::CommenceTransfer(14)
F15::CommenceTransfer(15)
F16::CommenceTransfer(16)
F17::CommenceTransfer(17)
F18::CommenceTransfer(18)
F19::CommenceTransfer(19)
F20::CommenceTransfer(20)
F21::CommenceTransfer(21)
F22::CommenceTransfer(22)
F23::CommenceTransfer(23)
F24::CommenceTransfer(24)
