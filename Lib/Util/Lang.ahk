#Requires AutoHotkey v2.0

ThrowAndExitApp(error) {
	Thread "Priority", 2147483647 ; Unlike `Critical`, events aren't buffered.
	; Ensures that the script terminates after the `throw` below, regardless of
	; what option was selected from the error dialog that would be shown.
	SetTimer () => ExitApp(1), -1, 2147483646 ; NOTE: 1 less than 2147483647.
	throw error
}
