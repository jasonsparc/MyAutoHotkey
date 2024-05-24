#Requires AutoHotkey v2.0
#NoTrayIcon

loop Files "Startup\*" {
	if (A_LoopFileExt = "gitignore")
		continue

	Run "*UIAccess " A_LoopFilePath
}
