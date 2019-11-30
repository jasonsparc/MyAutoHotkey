
; File Open Utilities

ResolveLnk(sTarget, byref sOutLnkParams:="") {
	local ; --
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
	local ; --
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
	local ; --
	IniRead OutUrl, %sInternetShortcutFile%, InternetShortcut, Url, %A_Space%
	Return OutUrl
}

FindExecutable(sDocument, pMaxPathLen:=260) {
	local ; --
	; See, https://stackoverflow.com/a/9540278

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
	local ; --
	WinGetTitle Out, %sWinTitle%
	return Out
}

IsValidWinTitleText(sWinTitle) {
	local ; --
	WinGetTitle Out, %sWinTitle%

	; Checks if invalid window.
	; Add more checks below.
	if (not Out or Out ~= "Opening - (Excel|Word)") {
		return ""
	}

	return Out
}

GetValidWinIDs(sWinTitle, sPredicate:="IsValidWinTitleText") {
	local ; --
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
	local ; --
	Ret := {}
	i := 0
	For k,v in pTestMap
		if not pTargetMap[k]
			Ret[k] := ++i
	return Ret
}

FirstKey(pMap) {
	local ; --
	For i,v in pMap {
		return i
	}
	return ""
}

EntriesToString(pMap, sSep:="`n") {
	local ; --
	Out := ""
	For i,v in pMap
		Out .= i . " := " . v . sSep
	return Out
}

GetAbsolutePath(pPath) {
	Loop Files, %pPath%, DF
		Return A_LoopFileLongPath
}
