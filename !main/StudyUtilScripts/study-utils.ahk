
#Include <file-open-utils>

global calc_sheets := "C:\dev\studies\``helper-calc-sheets"

global StudyWindowPrefs_X := 440, global StudyWindowPrefs_Y := 0
global StudyWindowPrefs_W := 1336, global StudyWindowPrefs_H := 1046

Prompt(AskTitle:="Start Routine", AskMsg:="") {
	MsgBox, 36, %AskTitle%, %AskMsg%
	IfMsgBox Yes
		return true
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

StudyUrl(sUrl, bDontMinimize=false, pTimeout:=10, bNewWindow=true) {
	if (bNewWindow) {
		OutHwnd := OpenWaitHwnd("chrome.exe", "--new-window " . sUrl,, pTimeout)
		HandleStudyWinPos(OutHwnd, bDontMinimize)
	} else {
		Run chrome.exe %sUrl%
	}
}

StudyDoc(sFile, bDontMinimize=false, pTimeout:=10) {
	OutHwnd := OpenWaitHwnd(sFile,,, pTimeout)
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
