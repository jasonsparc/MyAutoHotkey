; Easily change the `Critical` setting while also backing up any former
; settings for a later restoration.
;

global ___CriticalStack

PushCritical(OnOffNumeric:="On") {
	if (!___CriticalStack)
		___CriticalStack := {}

	___CriticalStack.Push(A_IsCritical)
	Critical, %OnOffNumeric%
}

PopCritical() {
	if (!___CriticalStack.Length())
		return

	Critical, % ___CriticalStack.Pop()
}
