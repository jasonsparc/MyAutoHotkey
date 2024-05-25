
; For D2R
;

#HotIf WinActive("ahk_class OsWindow ahk_exe D2R.exe")

; See also, https://www.autohotkey.com/docs/v2/misc/Remap.htm#actually
XButton2::XButton2
; NOTE: We used a `~` here so that `XButton2` won't be consumed.
~XButton2 & LButton::LButton
~XButton2 & RButton::RButton

#HotIf
