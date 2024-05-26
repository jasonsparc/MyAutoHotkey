#Requires AutoHotkey v2.0
#SingleInstance force

; From, https://www.autohotkey.com/boards/viewtopic.php?t=114810
;
; NOTE: For the following to work, this script must be run last, after every
; other AHK script that binds XButton1 and XButton2.
;
#InputLevel 100
XButton1::XButton2
XButton2::XButton1
#InputLevel 0
