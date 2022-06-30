
; Just some extras for easy copy-pasting via the mouse.
;
; Also, quickly invoke Windows 10's Clipboard History.
;

XButton1 & RButton::
	SendInput ^c
	ReleaseKeys("XButton1", "RButton")
Return

XButton1 & LButton::
	Send % GetKeyState("Shift") ? "{Shift Up}#v" : "^v"
	ReleaseKeys("XButton1", "LButton")
Return
