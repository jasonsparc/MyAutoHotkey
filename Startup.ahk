#Requires AutoHotkey v2.0
#NoTrayIcon

; NOTE: We use a special trick to ensure that each file path entry is processed
; in sorted order, since the file system doesn't necessarily guarantee ordering.
; - See, https://www.autohotkey.com/docs/v2/lib/LoopFiles.htm#ExSortName

items := ""
loop Files "Startup\*" {
	if (A_LoopFileExt = "gitignore")
		continue

	items .= A_LoopFilePath "`n"
}

loop Parse Sort(items), "`n" {
	if A_LoopField = "" ; Ignore the blank item at the end of the list.
        continue

	Run "*UIAccess " A_LoopField
}
