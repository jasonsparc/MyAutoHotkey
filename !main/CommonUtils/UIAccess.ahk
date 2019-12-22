
IsUIAccess() {
	return A_AhkPath ~= "Si)[\\/]AutoHotkey[^\\/]*_UIA\.exe$"
}

RequireUIAccess() {
	if (IsUIAccess())
		return
	MsgBox, % 0x4, , This script requires UI access to run.`n`nWould you like to re-run the script with UI Access instead?
	IfMsgBox Yes
		RestartWithUIAccess()
	ExitApp
}

EnsureUIAccess() {
	if (!IsUIAccess())
		RestartWithUIAccess()
}

RestartWithUIAccess() {
	SplitPath A_AhkPath, _, AhkInstallDir
	Loop, Files, %AhkInstallDir%\AutoHotkey*_UIA.exe
	{
		AhkExe := A_LoopFileLongPath
		ArgsPart := ""
		for _, v in A_Args {
			if (SubStr(v, StrLen(v), 1) == "\")
				v .= "\"
			ArgsPart .= " """ StrReplace(v, """", "\""") """"
		}
		Run "%AhkExe%" "%A_ScriptFullPath%"%ArgsPart%
		ExitApp
	}
	MsgBox, % 0x10, , Error: Cannot run with UI Access.`nExecutable ``AutoHotkey*_UIA.exe`` not found.
	ExitApp
}
