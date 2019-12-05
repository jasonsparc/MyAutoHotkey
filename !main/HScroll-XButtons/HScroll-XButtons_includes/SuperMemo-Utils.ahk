
; Just some handy hotkeys for SuperMemo
;

#IfWinActive ahk_class TElWind ahk_exe sm18.exe

; Quickly apply a template
XButton1 & s::
^s::^+m

; --
; Only when an HTML component is in focus
#If WinActive("ahk_class TElWind ahk_exe sm18.exe")
&& SubStr(ControlGetFocus(), 1, 24) == "Internet Explorer_Server"

; Quick Esc
XButton1 & MButton::Esc

; Quick edit file
XButton1 & `::
!`::Send ^{F9}

; Cloze via mouse
XButton1 & z::!z

; Extract via mouse
; -- Usable also with [Shift] key
XButton1 & x::!x

; Quick splitline, via CTRL+| (pipe)
; -- https://www.reddit.com/r/super_memo/comments/aqma21/
^\::Send !+h{Down}

#If ; End If

