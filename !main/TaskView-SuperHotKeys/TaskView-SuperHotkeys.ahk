#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
Menu, Tray, Icon, shell32.dll, 319

;#MaxThreads 2


;-=-=-=- * * * -=-=-=-

; Common Utilities & Globals

global TaskViewActivated := false
global TaskSwitchingActivated := false

;_+_+_
Return ; Block execution of utility code below...


IsTaskViewActive() {
	Id := WinExist("A")
	If (Id) {
		WinGetTitle ATitle
		WinGetClass AClass
		ATitleFull = %ATitle% ahk_class %AClass%
		If (ATitleFull == "Task View ahk_class Windows.UI.Core.CoreWindow")
			Return Id
	}
	Return 0x0
}

IsTaskViewActivated() {
	Return TaskViewActivated || (TaskViewActivated := IsTaskViewActive())
}

TaskViewPrepareDeactivation(Timeout:=0.5) {
	TaskViewActivated := false
	return TaskViewWaitActive(Timeout)
}

TaskViewWaitActive(Timeout:=0.5) {
	if (IsTaskViewActive())
		return true

	sTickCount := A_TickCount
	while (Timeout > 0) {
		WinWaitNotActive A, , %Timeout%
		if (IsTaskViewActive())
			return true

		xTickCount := A_TickCount
		Timeout -= (xTickCount - sTickCount) / 1000
		sTickCount := xTickCount
	}
	return false
}


IsTaskSwitchingActive() {
	Return WinActive("Task Switching ahk_class MultitaskingViewFrame")
}

IsTaskSwitchingActivated() {
	Return TaskSwitchingActivated || (TaskSwitchingActivated := IsTaskSwitchingActive())
}

TaskSwitchingPrepareDeactivation(Timeout:=0.5) {
	TaskSwitchingActivated := false
	return TaskSwitchingWaitActive()
}

TaskSwitchingWaitActive(Timeout:=0.5) {
	WinWaitActive Task Switching ahk_class MultitaskingViewFrame, , %Timeout%
	return !ErrorLevel
}


; Utilities for switching between virtual desktops

LeftDesktop:  ; Switch to left virtual desktop
	If (!IsTaskViewActive()) {
		; Activates the desktop -- also restores the last active window upon transition.
		WinActivate ahk_class WorkerW ahk_exe explorer.exe
	}
	SendInput {Blind}{LCtrl DownTemp}{LWin DownTemp}{Left}{LWin Up}{LCtrl Up}
	Sleep 180
Return

RightDesktop:  ; Switch to right virtual desktop
	If (!IsTaskViewActive()) {
		; Activates the desktop -- also restores the last active window upon transition.
		WinActivate ahk_class WorkerW ahk_exe explorer.exe
	}
	SendInput {Blind}{RCtrl DownTemp}{RWin DownTemp}{Right}{RWin Up}{RCtrl Up}
	Sleep 180
Return


; Utilities for highlighting tasks in Task View & Task Switching
; -- especially made for "MouseWheel"-related Hotkeys

LeftTask:
	SendInput {Left}
	Sleep 100
Return

RightTask:
	SendInput {Right}
	Sleep 100
Return


; Utilities to go to a specific desktop number

GoToDesktop(desktopNumber) {
	RegRead, DesktopList, HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs

	if (!DesktopList)
		Return

	DesktopCount := StrLen(DesktopList) / 32

	SessionId := getSessionId()
	if (SessionId)
		RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop

	CurrentDesktop := 1
	i := 0
	while (true) {
		if (SubStr(DesktopList, i * 32 + 1, 32) = CurrentDesktopId) {
			CurrentDesktop := i + 1
			break
		}
		i++
		if (i >= DesktopCount)
			Return ; Could not find current desktop
	}

	if (desktopNumber > DesktopCount)
		Return ; Invalid desktop number
	if (CurrentDesktop == desktopNumber)
		Return ; No need to proceed below

	if (CurrentDesktop < desktopNumber) {
		TransitionCount := desktopNumber - CurrentDesktop
		TransitionHotkey = ^#{Right}
	} else if (CurrentDesktop > desktopNumber) {
		TransitionCount := CurrentDesktop - desktopNumber
		TransitionHotkey = ^#{Left}
	}

	; For a smooth transition
	SleepTime := 100 / TransitionCount

	TaskViewWasActive := IsTaskViewActive()

	if (!TaskViewWasActive) {
		; Avoids sending input events to any active window
		WinActivate ahk_class Shell_TrayWnd ahk_exe explorer.exe
	}

	TransitionCount--
	Loop %TransitionCount% {
		SendInput %TransitionHotkey%
		Sleep %SleepTime%
	}

	if (!TaskViewWasActive) {
		; Activates the desktop -- also restores the last active window upon transition.
		WinActivate ahk_class WorkerW ahk_exe explorer.exe
	}

	SendInput %TransitionHotkey%
	Sleep 80
}

GetSessionId() {
	SessionId := 0
	ProcessId := DllCall("GetCurrentProcessId", "UInt")

	if (ErrorLevel) {
		OutputDebug, Error getting current process id: %ErrorLevel%
		return
	}

	DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
	if (ErrorLevel) {
		OutputDebug, Error getting session id: %ErrorLevel%
		return
	}

	return SessionId
}

; Override to prevent any active window from capturing our keys

^#Left::Goto LeftDesktop
^#Right::Goto RightDesktop

;-=-=-=- * * * -=-=-=-


;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-
; Go to Desktop X HotKeys
;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-


;-=-=-=- * * * -=-=-=-

; Go to Desktop X via Ctrl + Win + NUMBER

^#1::GoToDesktop(1)
^#2::GoToDesktop(2)
^#3::GoToDesktop(3)
^#4::GoToDesktop(4)
^#5::GoToDesktop(5)
^#6::GoToDesktop(6)
^#7::GoToDesktop(7)
^#8::GoToDesktop(8)
^#9::GoToDesktop(9)

; Go to Desktop X via Win + Function Key

#F1::GoToDesktop(1)
#F2::GoToDesktop(2)
#F3::GoToDesktop(3)
#F4::GoToDesktop(4)
#F5::GoToDesktop(5)
#F6::GoToDesktop(6)
#F7::GoToDesktop(7)
#F8::GoToDesktop(8)
#F9::GoToDesktop(9)
#F10::GoToDesktop(10)
#F11::GoToDesktop(11)
#F12::GoToDesktop(12)

; More function keys at the top of other keyboards

#F13::GoToDesktop(13)
#F14::GoToDesktop(14)
#F15::GoToDesktop(15)
#F16::GoToDesktop(16)
#F17::GoToDesktop(17)
#F18::GoToDesktop(18)
#F19::GoToDesktop(19)
#F20::GoToDesktop(20)
#F21::GoToDesktop(21)
#F22::GoToDesktop(22)
#F23::GoToDesktop(23)
#F24::GoToDesktop(24)

;-=-=-=- * * * -=-=-=-


;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-
; Simpler Task View Hotkeys
;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-


;-=-=-=- * * * -=-=-=-

; Open Task View via WinKey + AppsKey
#AppsKey::
Send {Blind}{Tab}
KeyWait AppsKey ; Avoids key repeat (due to holding)
Return


;-=-=-=- * * * -=-=-=-

; Easily switch between virtual desktops when in Task View

;_+_+_
#If IsTaskViewActive()

PgUp::Goto LeftDesktop
PgDn::Goto RightDesktop

; Go to Desktop X via Function Keys when in Task View

F1::GoToDesktop(1)
F2::GoToDesktop(2)
F3::GoToDesktop(3)
F4::GoToDesktop(4)
F5::GoToDesktop(5)
F6::GoToDesktop(6)
F7::GoToDesktop(7)
F8::GoToDesktop(8)
F9::GoToDesktop(9)
F10::GoToDesktop(10)
F11::GoToDesktop(11)
F12::GoToDesktop(12)

; More function keys at the top of other keyboards

F13::GoToDesktop(13)
F14::GoToDesktop(14)
F15::GoToDesktop(15)
F16::GoToDesktop(16)
F17::GoToDesktop(17)
F18::GoToDesktop(18)
F19::GoToDesktop(19)
F20::GoToDesktop(20)
F21::GoToDesktop(21)
F22::GoToDesktop(22)
F23::GoToDesktop(23)
F24::GoToDesktop(24)

;_+_+_
#If ; End If


;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-
; Numpad Task View Hotkeys
;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-


;-=-=-=- * * * -=-=-=-

; NOTE: NumpadClear is Numpad5 when NumLock is OFF

; Open Task View via NumpadClear key combinations

NumpadClear & NumpadIns::
Send #{Tab}
KeyWait NumpadIns ; Avoids key repeat (due to holding)
Return

NumpadClear & NumpadEnter::
Send #{Tab}
KeyWait NumpadEnter ; Avoids key repeat (due to holding)
Return

; Switch between virtual desktops via NumpadClear + NumpadPgUp/NumpadPgDn

NumpadClear & NumpadPgUp::Goto LeftDesktop
NumpadClear & NumpadPgDn::Goto RightDesktop


;-=-=-=- * * * -=-=-=-

; Easily switch between virtual desktops when in Task View

;_+_+_
#If IsTaskViewActive()

NumpadPgUp::Goto LeftDesktop
NumpadPgDn::Goto RightDesktop

;_+_+_
#If ; End If


;-=-=-=- * * * -=-=-=-

; BONUS: Switch to most recent task

; Open task switching
NumpadClear & NumpadSub::
Send ^!+{Tab} ; Previous recent task
TaskSwitchingActivated := true
Return

NumpadClear & NumpadAdd::
Send ^!{Tab} ; Next recent task
TaskSwitchingActivated := true
Return

;_+_+_
#If IsTaskSwitchingActivated()

; Select higlighted task
*~NumpadClear up::
if (TaskSwitchingPrepareDeactivation())
	Send {Enter}
Return

;_+_+_
#If ; End If


;-=-=-=- * * * -=-=-=-


;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-
; XButton2 + MouseWheel Task View Hotkeys
;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-


;-=-=-=- * * * -=-=-=-

; Switch between virtual desktops via XButton2 + MouseWheel

XButton2 & WheelUp::Goto LeftDesktop
XButton2 & WheelDown::Goto RightDesktop
XButton2 & WheelLeft::Goto LeftDesktop
XButton2 & WheelRight::Goto RightDesktop


;-=-=-=- * * * -=-=-=-

; Open task view via XButton2
XButton2::Send #{Tab}


;-=-=-=- * * * -=-=-=-

; BONUS: Switch to most recent task

; Open task switching
XButton2 & RButton::
Send ^!{Tab}
TaskSwitchingActivated := true
Return

;_+_+_
#If IsTaskSwitchingActivated()

; Select higlighted task
*RButton up::
if (TaskSwitchingPrepareDeactivation())
	Send {Enter}
Return

*~Esc::TaskSwitchingActivated := false

; Shouldn't activate task view at the moment
*XButton2::Return

;_+_+_
#If IsTaskSwitchingActive()

; Highlight tasks via MouseWheel, when in Task Switching

XButton2 & WheelUp::Goto LeftTask
XButton2 & WheelDown::Goto RightTask
XButton2 & WheelLeft::Goto LeftTask
XButton2 & WheelRight::Goto RightTask

;_+_+_
#If ; End If


;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-
; Go to Desktop X HotKeys via XButton2
;-=-=-=- * * * -=-=-=- * * * -=-=-=- * * * -=-=-=-

; Go to Desktop X via XButton2 + NUMBER

XButton2 & 1::GoToDesktop(1)
XButton2 & 2::GoToDesktop(2)
XButton2 & 3::GoToDesktop(3)
XButton2 & 4::GoToDesktop(4)
XButton2 & 5::GoToDesktop(5)
XButton2 & 6::GoToDesktop(6)
XButton2 & 7::GoToDesktop(7)
XButton2 & 8::GoToDesktop(8)
XButton2 & 9::GoToDesktop(9)

; Go to Desktop X via Win + Function Key

XButton2 & F1::GoToDesktop(1)
XButton2 & F2::GoToDesktop(2)
XButton2 & F3::GoToDesktop(3)
XButton2 & F4::GoToDesktop(4)
XButton2 & F5::GoToDesktop(5)
XButton2 & F6::GoToDesktop(6)
XButton2 & F7::GoToDesktop(7)
XButton2 & F8::GoToDesktop(8)
XButton2 & F9::GoToDesktop(9)
XButton2 & F10::GoToDesktop(10)
XButton2 & F11::GoToDesktop(11)
XButton2 & F12::GoToDesktop(12)

; More function keys at the top of other keyboards

XButton2 & F13::GoToDesktop(13)
XButton2 & F14::GoToDesktop(14)
XButton2 & F15::GoToDesktop(15)
XButton2 & F16::GoToDesktop(16)
XButton2 & F17::GoToDesktop(17)
XButton2 & F18::GoToDesktop(18)
XButton2 & F19::GoToDesktop(19)
XButton2 & F20::GoToDesktop(20)
XButton2 & F21::GoToDesktop(21)
XButton2 & F22::GoToDesktop(22)
XButton2 & F23::GoToDesktop(23)
XButton2 & F24::GoToDesktop(24)

;_+_+_
#If ; End If


;-=-=-=- * * * -=-=-=-
; The END

