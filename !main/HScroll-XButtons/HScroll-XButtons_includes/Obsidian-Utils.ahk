
#If MouseIsOver("ahk_class Chrome_WidgetWin_1 ahk_exe Obsidian.exe")

; Easily reopen closed pane.
;
XButton1 & MButton::
; Mouse inputs should always trigger window activation anyway.
if (RequireWinActive())
	Send ^T
Return

; - - = - = - = - - - +
; NOTE: Not using `MouseIsOver` since our remaps involve non-modifier keys.
#IfWinActive ahk_class Chrome_WidgetWin_1 ahk_exe Obsidian.exe

; IntelliJ-like `Shift` twice, to open Obsidian's command palette.
~Shift up::
; From, https://www.autohotkey.com/docs/commands/KeyWait.htm#ExDouble
;
; Detects when a key has been double-pressed (similar to double-click).
; `KeyWait` is used to stop the keyboard's auto-repeat feature from creating an
; unwanted double-press when you hold down the `Shift` key to modify another
; key. It does this by keeping the hotkey's thread running, which blocks the
; auto-repeats by relying upon #MaxThreadsPerHotkey being at its default
; setting of 1.
;
; Note: There is a more elaborate script to distinguish between single, double,
; and triple-presses at the bottom of the `SetTimer` page. See,
; https://www.autohotkey.com/docs/commands/SetTimer.htm#ExampleCount
;
if (A_PriorHotkey != A_ThisHotkey || A_TimeSincePriorHotkey > 400)
{
	; Too much time between presses, so this isn't a double-press.
	KeyWait, Shift ; Stop keyboard's auto-repeat from re-triggering this hotkey.
	Return
}
Send ^p
Return

#If ; End If
