
; Just some extras for easy copy-pasting via the mouse.
;
; Also, quickly invoke Windows 10's Clipboard History.
;

; Copy
XButton2 & RButton up::Send "^c"

; Paste
XButton2 & LButton up::Send !GetKeyState("Shift", "P") ? "^v" : "#v"
