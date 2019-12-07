﻿
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

; --
; Easily make multi-clozed single items. Inspired from,
; https://masterhowtolearn.wordpress.com/2019/05/26/prettifying-code-snippets-in-supermemo/

; Quick "Parse HTML" over selected text
XButton1 & 1::
!1::^+1

; Quickly paste a `<span class="Cloze">[...]</span>`
XButton1 & 2::
!2::
SendRaw, <span class="Cloze">[...]</span>?
Send, {Left}+{Left 32}^+1{Del}+{Left 5}
return

; --
; ...

#If ; End If

