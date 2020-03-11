
; Just some extras for easy copy-pasting via the mouse.
;
; Also, quickly invoke Windows 10's Clipboard History.
;

XButton1 & RButton::^c
XButton1 & LButton::Send % GetKeyState("Shift") ? "#v" : "^v"
