﻿
; Just some handy hotkeys for SuperMemo
;

; SuperMemo Element Window
#IfWinActive ahk_class TElWind ahk_exe sm18.exe

; Quickly apply a template
XButton1 & s::
^s::^+m

; Quickly edit references
XButton1 & r::
Send ^{Enter}
SendRaw Reference: Edit
Send {Enter}
return

; Fixes issues with CTRL+V (and possibly CTRL+C as well) -- The issue is mainly
; that when you paste something, 'v' would also be typed sometimes.
^c::Send ^{Ins}
^v::Send +{Ins}
XButton1 & RButton::^Ins
XButton1 & LButton::+Ins

; --
; Only when an HTML component is in focus
#If WinActive("ahk_class TElWind ahk_exe sm18.exe")
&& SubStr(ControlGetFocus(), 1, 24) == "Internet Explorer_Server"

; Quick Esc
XButton1 & MButton::Esc

; Quick edit file
XButton1 & `::
^`::
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
!1::Send ^+1

; Quickly paste a `<span class="Cloze">[...]</span>`
XButton1 & 2::
!2::
Thread, Priority, 1000 ; Only one instance! No Buffering!
ClipboardPush()
Clipboard = <span class="Cloze">[...]</span>
Send, {AppsKey}xp
Sleep 100
ClipboardPop()
return

; --
; Only when editing an HTML component via Notepad2
#If WinActive("ahk_class Notepad2 ahk_exe Notepad2.exe")
&& WinGetTitle() ~= "Si)^(?:\* )?\d+\.HTML? \[[A-Z]:\\supermemo\\systems\\[^\\]+\\elements(?:\\|\] - Notepad2-mod$)"

; Quickly paste a `<span class="Cloze">[...]</span>`
XButton1 & 2::
!2::
Thread, Priority, 1000 ; Only one instance! No Buffering!
ClipboardPush()
Clipboard = <span class="Cloze">[...]</span>
Send, ^v
Sleep 100
ClipboardPop()
return

; Quickly enclose selection within a `<span class="clozed">...</span>`
XButton1 & 3::
!3::
Thread, Priority, 1000 ; Only one instance! No Buffering!
SuperMemoUtils_Sel := GetSelectedText()
if (SuperMemoUtils_Sel == "")
	return
ClipboardPush()
Clipboard := "<span class=""clozed"">" SuperMemoUtils_Sel "</span>"
SuperMemoUtils_Sel := ""
Send, ^v
Sleep 100
ClipboardPop()
return

; --
; ...

#If ; End If

