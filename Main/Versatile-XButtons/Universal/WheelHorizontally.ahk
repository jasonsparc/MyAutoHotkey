
; Wheel left
XButton2 & WheelUp::{
	MouseClick "WL", , , Ceil(GetHScrollLines() * GetWheelTurns())
}

; Wheel right
XButton2 & WheelDown::{
	MouseClick "WR", , , Ceil(GetHScrollLines() * GetWheelTurns())
}
