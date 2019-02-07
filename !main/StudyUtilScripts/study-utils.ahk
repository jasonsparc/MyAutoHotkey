
#Include <file-open-utils>
#Include <Functions>

global calc_sheets := "C:\dev\studies\``helper-calc-sheets"

global StudyWindowPrefs_X := Round(A_ScreenWidth * 440/1920)
global StudyWindowPrefs_Y := Round(A_ScreenHeight * 0/1080)

global StudyWindowPrefs_W := Round(A_ScreenWidth * 1336/1920)
global StudyWindowPrefs_H := SysGet(62) - 9
;global StudyWindowPrefs_H := Round(A_ScreenHeight * 1047/1080)

;MsgBox %StudyWindowPrefs_X%`t%StudyWindowPrefs_Y%`n%StudyWindowPrefs_W%`t%StudyWindowPrefs_H%

Prompt(AskTitle:="Start Routine", AskMsg:="", HasCancel:=false, ExitOnCancel:=false) {
	MsgBox, % HasCancel ? 35 : 36, %AskTitle%, %AskMsg%
	IfMsgBox Yes
		return true
	IfMsgBox Cancel
		If ExitOnCancel
			Exit
	return false
}

PromptStart(CourseName:="", Suffix:="") {
	if (Not CourseName) {
		SplitPath A_ScriptDir, CourseName
	}
	if (Suffix) {
		CourseName = %CourseName%%Suffix%
	}
	Msg = Start Studying?`n`n%CourseName%
	if (Not Prompt(, Msg))
		Exit
}

PromptOpenProjects(AskTitle:="Start Routine", AskMsg:="Open associated projects?") {
	return Prompt(AskTitle, AskMsg)
}

ReviewQuizes(sTargetPseudoArray:="Quiz_", pStartIndex:=1, pEndIndex:=0) {
	Index := pStartIndex
	While %sTargetPseudoArray%%Index% {
		StudyUrl(%sTargetPseudoArray%%Index%, true,, Index=pStartIndex)
		Index++
		if (pEndIndex AND Index > pEndIndex) {
			Break
		}
		Sleep 200
	}
}

StudyUrl(sUrl, bDontMinimize=false, pTimeout:=4, bNewWindow=true) {
	if (sUrl != "")
		sUrl = "%sUrl%"
	if (bNewWindow) {
		OutHwnd := OpenWaitHwnd("chrome.exe", "--new-window " . sUrl,, pTimeout)
		HandleStudyWinPos(OutHwnd, bDontMinimize)
	} else {
		Run chrome.exe %sUrl%
	}
}

StudyDoc(sFile, bDontMinimize=false, pTimeout:=4) {
	OutHwnd := OpenWaitHwnd(sFile,,, pTimeout)
	HandleStudyWinPos(OutHwnd, bDontMinimize)
}

StudyTarget(sTarget, sParams:="", bDontMinimize=false, pTimeout:=4) {
	OutHwnd := OpenWaitHwnd(sTarget, sParams,, pTimeout)
	HandleStudyWinPos(OutHwnd, bDontMinimize)
}

HandleStudyWinPos(sHwnd, bDontMinimize=false) {
	if (sHwnd) {
		WinRestore ahk_id %sHwnd%
		WinMove ahk_id %sHwnd%,
			, StudyWindowPrefs_X, StudyWindowPrefs_Y
			, StudyWindowPrefs_W, StudyWindowPrefs_H

		if (!bDontMinimize) {
			WinMinimize ahk_id %sHwnd%
		}
	}
}
