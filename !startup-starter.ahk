#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Find the best AHK EXE to execute the startup scripts with UIA if possible

SplitPath A_AhkPath, _, AhkInstallDir
AhkInstallDir .= "\"
AhkExe := AhkInstallDir . "AutoHotkeyU64_UIA.exe"

IfNotExist %AhkExe%
	AhkExe := AhkInstallDir . "AutoHotkeyU32_UIA.exe"

IfNotExist %AhkExe%
	AhkExe := AhkInstallDir . "AutoHotkey.exe"

; Start everything under "!startup"

InitAhkStartupFiles(".\!startup\*", AhkExe)

; Note: NEVER put hotkeys here!!!
ExitApp

; -=-=-

; Utility Functions

InitAhkStartupFiles(pLoopDir:=".\!startup\*", pAhkExe:="AutoHotkey.exe") {
	Loop, Files, %pLoopDir%
	{
		Target := A_LoopFileFullPath
		Ext := A_LoopFileExt
		RunDir := ""
		RunState := ""
		QTarget := ""

		if (Ext = "gitignore") {
			continue
		}

		if (Ext = "LNK") {
			FileGetShortcut %Target%, Target, RunDir, OutArgs, , , , OutState
			SplitPath Target, , , Ext
			QTarget := OutArgs ? """" Target """ " OutArgs """" : """" Target """"

			if (OutState = 3) {
				RunState = Max
			} else if (OutState = 7) {
				RunState = Min
			}
		} else {
			QTarget = "%Target%"
		}

		if (Ext = "AHK") {
			Run %pAhkExe% %QTarget%, %RunDir%, %RunState%
		} else {
			Run %A_LoopFileFullPath%
		}
	}
}
