
; File Open Utilities

ResolveLnk(sTarget, byref sOutLnkParams:="") {
	SplitPath, sTarget, , , OutExt
	if (OutExt = "lnk") {
		FileGetShortcut %sTarget%, sTarget, , sOutLnkParams
		if (ErrorLevel) {
			MsgBox 16, Error, %sTarget%`n`nLink could not be resolved.
			return ""
		}
	}
	return sTarget
}

OpenWaitHwnd(sTarget, sParams:="", RunState:="", pTimeout:=4, sValidHwndPredicate:="IsValidWinTitleText") {
	; -- Find Exe --

	sExe := sTarget
	SplitPath, sTarget, , , OutExt

	if (OutExt = "lnk") {
		FileGetShortcut %sTarget%, sTarget, , sLnkParams
		if (ErrorLevel) {
			MsgBox 16, Error, %sTarget%`n`nCould not be opened.
			return 0
		}
		if (sLnkParams) {
			sParams = %sLnkParams% %sParams%
		}
	}

	if (not OutExt = "exe") {
		sExe := FindExecutable(sTarget)

		if (not sExe) {
			IfNotExist sTarget
			{
				MsgBox 16, Error, %sTarget%`n`nThe specified file was not found.
			} else {
				MsgBox 16, Error, %sTarget%`n`nCould not find the associated executable for the specified document.
			}
			return 0
		} else if (sParams) {
			sParams = "%sTarget%" %sParams%
		} else {
			sParams = "%sTarget%"
		}
	}

	; -- Begin Run --

	sTargetWin = ahk_exe %sExe%
	OldIDs := GetValidWinIDs(sTargetWin, sValidHwndPredicate)

	; NOTE Not using `RunWait` here since some programs either doesn't respond
	; directly or doesn't respond instantly even after the program has started.
	Run "%sExe%" %sParams%, , %RunState%

	Retries := pTimeout / 0.5
	FailInterval := 500

	Loop %Retries% {
		WinWait %sTargetWin%,, pTimeout

		if ErrorLevel ; Check for timeout
			break

		TestIDs := GetValidWinIDs(sTargetWin, sValidHwndPredicate)
		NewIDs := GetNewEntries(OldIDs, TestIDs)
		;MsgBox % GetWinTitleText("ahk_id " . FirstKey(NewIDs))
		;MsgBox % EntriesToString(NewIDs)

		if (NewIDs.Length()) {
			return FirstKey(NewIDs)
		}

		Sleep FailInterval
	}

	return 0
}

; Additional Utility Functions

GetInternetShortcutUrl(sInternetShortcutFile) {
	IniRead OutUrl, %sInternetShortcutFile%, InternetShortcut, Url, %A_Space%
	Return OutUrl
}

FindExecutable(sDocument, pMaxPathLen:=260) {
	VarSetCapacity(Ret, pMaxPathLen)
	RetCode := DllCall("shell32.dll\FindExecutable", "Str", sDocument, "Str", "", "Str", Ret)

	if (RetCode > 32) {
		Ret = %Ret%
		return Ret
	}

	ErrorLevel := RetCode
	return ""
}

GetWinTitleText(sWinTitle) {
	WinGetTitle Out, %sWinTitle%
	return Out
}

IsValidWinTitleText(sWinTitle) {
	WinGetTitle Out, %sWinTitle%

	; Checks if invalid window.
	; Add more checks below.
	if (not Out or Out ~= "Opening - (Excel|Word)") {
		return ""
	}

	return Out
}

GetValidWinIDs(sWinTitle, sPredicate:="IsValidWinTitleText") {
	WinGet FoundIDs, List, %sWinTitle%
	IDMap := {}
	i := 0
	Loop %FoundIDs%
	{
		FoundID := FoundIDs%A_Index%
		if (%sPredicate%("ahk_id " . FoundID))
			IDMap[FoundID] := ++i
	}
	return IDMap
}

; Utility Map Functions

GetNewEntries(pTargetMap, pTestMap) {
	Ret := {}
	i := 0
	For k,v in pTestMap
		if not pTargetMap[k]
			Ret[k] := ++i
	return Ret
}

FirstKey(pMap) {
	For i,v in pMap {
		return i
	}
	return ""
}

EntriesToString(pMap, sSep:="`n") {
	Out := ""
	For i,v in pMap
		Out .= i . " := " . v . sSep
	return Out
}

GetAbsolutePath(pPath) {
	Loop %pPath%, 1
		Return A_LoopFileLongPath
}
