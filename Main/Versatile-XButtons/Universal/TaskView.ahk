
; Window group for the Task View (win-tab)
GroupAdd "TaskView", "Task View ahk_class Windows.UI.Core.CoreWindow"

; Window group for the Task Switcher (alt-tab)
; - See, https://www.autohotkey.com/docs/v2/Hotkeys.htm#AltTabWindow
GroupAdd "TaskSwitcher", "ahk_class MultitaskingViewFrame"  ; Windows 10
GroupAdd "TaskSwitcher", "ahk_class TaskSwitcherWnd"  ; Windows Vista, 7, 8.1
GroupAdd "TaskSwitcher", "ahk_class #32771"  ; Older, or with classic alt-tab enabled

; -----------------------------------------------------------------------------
; Utilities

TaskView_ToDesktop(x) {
	static moving := false
	if moving
		return
	moving := true
	try {
		st := A_TickCount

		SendInput x >= 0
			? "^#{Right " . x . "}"
			: "^#{Left " . -x . "}"

		et := A_TickCount - st
		Sleep Max(-1, 120 - et)
	} finally {
		moving := false
	}
}

TaskView_Open() {
	; NOTE: `SendInput` won't work reliably if a Win key is still held.
	SendEvent "#{Tab}"
}

; -=-

TaskSwitcher_Open() {
	; Opens the Task Switcher while highlighting the next recent task.
	SendEvent "^!{Tab}"
}

TaskSwitcher_OpenP() {
	; Opens the Task Switcher while highlighting the previous recent task.
	SendEvent "^!+{Tab}"
}

TaskSwitcher_ControlSend(keys, useLastWin, maxDuration := 90) {
	static sending := false
	if sending
		return
	sending := true
	try {
		if (IsSet(maxDuration)) {
			st := A_TickCount
		}
		if useLastWin || WinExist("ahk_group TaskSwitcher") {
			ControlSend keys
		}
		if (IsSet(maxDuration)) {
			et := A_TickCount - st
			Sleep Max(-1, maxDuration - et)
		}
	} finally {
		sending := false
	}
}

TaskSwitcher_LeftTask(useLastWin) {
	TaskSwitcher_ControlSend "{Left}", useLastWin
}

TaskSwitcher_RightTask(useLastWin) {
	TaskSwitcher_ControlSend "{Right}", useLastWin
}

TaskSwitcher_SelectTask(useLastWin) {
	TaskSwitcher_ControlSend "{Enter}", useLastWin, unset
}

TaskSwitcher_Cancel(useLastWin) {
	TaskSwitcher_ControlSend "{Esc}", useLastWin, unset
}

; -----------------------------------------------------------------------------
; Relative desktop navigation

; Go to left desktop
NumpadClear & NumpadPgUp::
XButton1 & WheelLeft::
XButton1 & WheelUp::TaskView_ToDesktop(-1)

; Go to right desktop
NumpadClear & NumpadPgDn::
XButton1 & WheelRight::
XButton1 & WheelDown::TaskView_ToDesktop(1)

; -----------------------------------------------------------------------------
; Task View

XButton1 & LButton::TaskView_Open()

NumpadClear & NumpadIns::{
	TaskView_Open()
	KeyWait "NumpadIns" ; Avoids key auto-repeat
}

#z::{
	TaskView_Open()
	KeyWait "z" ; Avoids key auto-repeat
}

; -----------------------------------------------------------------------------
; Task Switcher

XButton1 & RButton::
#RButton::TaskSwitcher_Open()

NumpadClear & NumpadSub::TaskSwitcher_Open_ViaNumpadClear(0)
NumpadClear & NumpadAdd::TaskSwitcher_Open_ViaNumpadClear(1)

TaskSwitcher_Open_ViaNumpadClear(toNext) {
	static opening := false
	if opening
		return
	opening := true
	try {
		if toNext
			TaskSwitcher_Open()
		else
			TaskSwitcher_OpenP()
		KeyWait "NumpadClear"
		TaskSwitcher_SelectTask(0)
	} finally {
		opening := false
	}
}

#HotIf WinExist("ahk_group TaskSwitcher")

*RButton up::TaskSwitcher_SelectTask(1)

NumpadClear & NumpadPgUp::
NumpadClear & NumpadPgDn::TaskSwitcher_Cancel(1)

NumpadClear & NumpadSub::
XButton1 & WheelLeft::
XButton1 & WheelUp::
#WheelLeft::
#WheelUp::TaskSwitcher_LeftTask(1)

NumpadClear & NumpadAdd::
XButton1 & WheelRight::
XButton1 & WheelDown::
#WheelRight::
#WheelDown::TaskSwitcher_RightTask(1)

#HotIf
