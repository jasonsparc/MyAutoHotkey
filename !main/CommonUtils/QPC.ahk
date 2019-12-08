
; QPC(Reset) :: Based on QueryPerformanceCounter()
;
; Reset = True : Resets the counter (and returns the number of seconds since the computer was rebooted).
; Reset = False : Returns the number of seconds elapsed since last reset.
;
; TIP: Use with `SetBatchLines -1` to ensure effectiveness.
;
; --
; From, https://www.autohotkey.com/boards/viewtopic.php?f=6&t=4437
;
QPC(R:=0) { ; By SKAN,  http://goo.gl/nf7O4G,  CD:01/Sep/2014 | MD:01/Sep/2014
	Static P:=0, F:=0, Q:=DllCall("QueryPerformanceFrequency","Int64P",F)
	Return !DllCall("QueryPerformanceCounter", "Int64P", Q) + (R ? (P:=Q)/F : (Q-P)/F)
}
