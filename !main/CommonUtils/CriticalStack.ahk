; Easily change the `Critical` setting while also backing up any former
; settings for a later restoration.
;

global ___Critical_Stack

CriticalPush(OnOffNumeric:="On") {
	if (!___Critical_Stack)
		___Critical_Stack := {}

	___Critical_Stack.Push(A_IsCritical)
	Critical, %OnOffNumeric%
}

CriticalPop() {
	if (!___Critical_Stack.Length())
		return

	Critical, % ___Critical_Stack.Pop()
}
