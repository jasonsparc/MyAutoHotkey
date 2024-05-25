
; Just some extras for easy copy-pasting via the mouse.
;
; Also, quickly invoke Windows 10's Clipboard History.
;

; Copy
XButton2 & RButton up::Send "^c"

; Paste
XButton2 & LButton up::Send !GetKeyState("Shift", "P") ? "^v" : "#v"

; --
; The following are the "down and release" counterparts of our "up"-only custom
; combination hotkeys, necessary so as to prevent triggering other hotkeys that
; may use a similar key from our "up"-only combination hotkeys.
XButton2 & LButton::return
XButton2 & RButton::return
