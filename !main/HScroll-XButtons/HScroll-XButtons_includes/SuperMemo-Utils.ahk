
; Just some handy hotkeys for SuperMemo
;

; --
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

; Quickly delete all components
XButton1 & Del::
!Del::
Send {Alt down}{F10}d{Alt up}
WinWait Select ahk_class TChecksDlg ahk_exe sm18.exe, , 1
if (!ErrorLevel) ; Proceed only if there were components to delete
	Send ^a{Enter}
return

; Fixes issues with CTRL+V (and possibly CTRL+C as well) -- The issue is mainly
; that when you paste something, 'v' would also be typed sometimes.
^c::Send ^{Ins}
^v::Send +{Ins}
XButton1 & RButton::^Ins
XButton1 & LButton::+Ins

; --
; SuperMemo Element Window and/or Content Window
#If WinActive("ahk_exe sm18.exe")
&& (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents"))

; Convenient alternatives for history and general navigation
XButton1 & Left::Send !{Left}
XButton1 & Right::Send !{Right}
!Up::
XButton1 & Up::Send ^{Up}
XButton1 & PgUp::Send !{PgUp} ; Note: we could simply press PgUp when no component is in focus
XButton1 & PgDn::Send !{PgDn} ; Note: same as above

XButton1 & Tab::Send % GetKeyState("Shift") ? "!{PgUp}" : "!{PgDn}"

; ^--
#If WinActive("ahk_exe sm18.exe")
&& (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents"))
&& GetKeyState("Shift")

XButton1 & WheelUp::
Send !{PgUp}
Sleep 300
return

XButton1 & WheelDown::
Send !{PgDn}
Sleep 300
return

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

; Quickly paste a `<SPAN class=cloze>[...]</SPAN>`
XButton1 & 2::
!2::
Thread, Priority, 1000 ; Only one instance! No Buffering!
ClipboardPush()
Clipboard = <SPAN class=cloze>[...]</SPAN>
Send, {Alt down}{F12}xp{Alt up}
Sleep 100
ClipboardPop()
return

; --
; Only when editing an HTML component via Notepad2
#If WinExist("ahk_class TElWind ahk_exe sm18.exe")
&& WinActive("ahk_class Notepad2 ahk_exe Notepad2.exe")
&& WinGetTitle() ~= "Si)^(?:\* )?\d+\.HTML? \[[A-Z]:\\supermemo\\systems\\[^\\]+\\elements(?:\\|\] - Notepad2-mod$)"

; Quickly paste a `<SPAN class=cloze>[...]</SPAN>`
XButton1 & 2::
!2::
Thread, Priority, 1000 ; Only one instance! No Buffering!
ClipboardPush()
Clipboard = <SPAN class=cloze>[...]</SPAN>
Send, ^v
Sleep 100
ClipboardPop()
return

; Quickly enclose selection within a `<SPAN class=clozed>...</SPAN>`
XButton1 & 3::
!3::
Thread, Priority, 1000 ; Only one instance! No Buffering!
SuperMemoUtils_Sel := GetSelectedText()
if (SuperMemoUtils_Sel == "")
	return
ClipboardPush()
Clipboard := "<SPAN class=clozed>" SuperMemoUtils_Sel "</SPAN>"
SuperMemoUtils_Sel := ""
Send, ^v
Sleep 100
ClipboardPop()
return

; --
; ...

#If ; End If

