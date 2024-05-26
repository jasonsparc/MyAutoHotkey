#Requires AutoHotkey v2.0
#Include Lang.ahk

IsUIAccess() {
	static r := RegExMatch(A_AhkPath, "i)[\\/]AutoHotkey[^\\/]*_UIA\.exe$") != 0
	return r
}

RequireUIAccess(force:=false) {
	if IsUIAccess()
		return

	if !force && MsgBox(
		"This script requires UI access to run.`n`n" .
		"Would you like to re-run the script with UI Access instead?", , 0x4
	) !== "Yes"
		ExitApp

	; NOTE: While we could've used `Run("*UIAccess " …)`, the following ensures
	; that we stay consistent with the `IsUIAccess()` logic.

	SplitPath A_AhkPath, , &ahkExeDir, &ahkExeExt, &ahkExeName
	ahkExe := ahkExeDir "\" ahkExeName "_UIA." ahkExeExt

	if (FileExist(AhkExe)) {
		q(v) {
			v := StrReplace(v, "\", "\\")
			v := StrReplace(v, "`"", "\`"")
			return v
		}
		target := "`"" q(ahkExe) "`" `"" q(A_ScriptFullPath) "`""
		for , v in A_Args
			target .= " `"" q(v) "`""
		Run target
	} else {
		MsgBox "Error: Cannot run with UI Access.`n`n" .
			"Could not find executable:`n" AhkExe, , 0x10
	}
	ExitApp
}

EnsureUIAccess() {
	RequireUIAccess(true)
}

CheckUIAccess(what := -1) {
	if IsUIAccess()
		return

	ThrowAndExitApp Error("Must be run with UI Access.", what)
}
