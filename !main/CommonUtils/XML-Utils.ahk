
; Escapes all potentially dangerous characters, so that the resulting string
; can be safely inserted into an XML element text (or an attribute, when
; `quotesEncoded` is true).
;
; References:
; - https://stackoverflow.com/a/30558011
; - https://stackoverflow.com/q/6800467
; - https://www.w3.org/TR/xml/#NT-Char
;
; Regarding the treatment of line breaks:
; - https://stackoverflow.com/q/7277
XMLEncode(value, quotesEncoded:=false, lineBreaksEncoded:=true) {
	local ; --
	; Line break characters. See:
	; - https://en.wikipedia.org/wiki/Newline#Unicode
	; - https://docs.python.org/3/library/stdtypes.html#str.splitlines
	static NLChars := "`r`n`v`f" chr(0x85) chr(0x1E) chr(0x1D) chr(0x1C) chr(0x2028) chr(0x2029)
	; --
	out := ""
	prev := 1
	regexNeedle := "S)"
		. "[" chr(0xD800) "-" chr(0xDBFF) "][" chr(0xDC00) "-" chr(0xDFFF) "]|" ; Surrogate Pair
		. "[&<>" (quotesEncoded ? "'""" : "") "]|"
		. "[^ -~" (lineBreaksEncoded ? "" : NLChars ) "]" ; Match everything outside of normal chars
	while (cur := RegExMatch(value, regexNeedle, m, prev)) {
		out .= SubStr(value, prev, cur-prev)
		switch m
		{
		case "&":	out .= "&amp;"
		case "<":	out .= "&lt;"
		case ">":	out .= "&gt;"
		default:	out .= "&#" Ord(m) ";"
		}
		prev := cur + StrLen(m)
	}
	out .= SubStr(value, prev)
	return out
}

; Unescapes all numeric character references and the five XML 1.0 predefined
; entities. DTD entities are not supported and are therefore not handled.
;
; References:
; - https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references#Predefined_entities_in_XML
; - https://www.tutorialspoint.com/dtd/dtd_entities.htm
XMLDecode(value) {
	local ; --
	out := ""
	prev := 1
	regexNeedle := "S)&(?:"
		. "amp|[lg]t|apos|quot|"
		. "#(?:\d+|x[[:xdigit:]]+)"
		. ");"
	while (cur := RegExMatch(value, regexNeedle, m, prev)) {
		out .= SubStr(value, prev, cur-prev)
		switch m
		{
		case "&amp;":	out .= "&"
		case "&lt;":	out .= "<"
		case "&gt;":	out .= ">"
		case "&apos;":	out .= "'"
		case "&quot;":	out .= """"
		default:
			num := SubStr(m, 3)
			out .= Chr(SubStr(num, 1, 1) == "x" ? "0" num : num)
		}
		prev := cur + StrLen(m)
	}
	out .= SubStr(value, prev)
	return out
}
