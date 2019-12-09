
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

; Quickly paste a `<span class="clozed">{{selection}}</span>`
XButton1 & 3::
!3::
Thread, Priority, 1000 ; Only one instance! No Buffering!
; KeyWait all held keys before BlockInput -- A tip from the AHK manual
KeyWait XButton1
KeyWait Alt
KeyWait 3
; Now go!
BlockInput On
SuperMemo_Utils_ClozedSpanSel()
BlockInput Off
return

SuperMemo_Utils_ClozedSpanSel() {
	local ; --
	ClipboardPush()
	Send, +{Del} ; Cut
	if (ClipWait(0.2, 1) && (selLen := StrLen(selTxt := Clipboard))) {
		sel := ClipboardAll
		Clipboard = <span class="clozed">||</span>
		Sleep 100 ; Give enough time for the `Clipboard` to get unlocked
		Send, {AppsKey}xp+{Left}+{Del}
		if (ClipWaitText("|", 0.2)) {
			Clipboard := sel
			Sleep 100 ; Give enough time for the `Clipboard` to get unlocked
			Send, {Shift down}{Ins}
			KeyWait Ins, L ; Prevent `Insert` key from being interpreted as pressed alone
			Sleep 50 ; Give enough time for SuperMemo to breathe
			Send, {Shift up}
			; Multi-line selections not supported; Manual intervention required
			if selTxt not contains `r,`n
			{
				Send, % "{Left " selLen "}"
				Send, {Backspace}
				Send, % "{Right " selLen "}"
			}
		}
	}
	Sleep 100
	ClipboardPop()
}

SuperMemo_Utils_DoWaitOnWaitCursor() {
	local ; --
	incTick := 300
	loop {
		done := true
		endTick := A_TickCount + incTick
		while (A_TickCount < endTick) {
			if (A_Cursor == "Wait") {
				Sleep 50
				done := false
			}
		}
		incTick := 100
	} until done
}

; --
; ...

#If ; End If

