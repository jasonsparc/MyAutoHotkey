
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

; Searches for an XML element with the specified start tag.
;
; The `Haystack` input string need not be a complete XML data, and can instead
; be a substring of a larger XML string.
;
; The specified `ExactStartTag` parameter must be an XML start tag definition,
; e.g., `<name attr="val">`. It will be searched for and matched against
; exactly, e.g., the order of the attributes matter, how their values are
; quoted, etc. Also, if `LiteralWhitespace` is true (the default), even
; whitespace characters, such as those delimiting each attribute, will be
; treated literally. The final `>` symbol in the `ExactStartTag` parameter can
; be omitted, and if so, it will then also match start tags that have
; additional attributes after those specified by this parameter.
;
; The parser is highly lenient: it will allow an otherwise invalid XML tag, and
; even allows for HTML-style unquoted and valueless attributes.
XMLBalancedFind(Haystack, ExactStartTag, CaseSensitive:=true, StartPos:=1, LiteralWhitespace:=true) {
	local ; --
	static cache := {}
	static cacheKeys_totalStrLen := 0

	cacheKey := ExactStartTag "," CaseSensitive "," LiteralWhitespace
	cacheEntry := cache[cacheKey]

	if (cacheEntry) {
		startTagNeedle := cacheEntry.startTagNeedle
		balancedTagNeedle := cacheEntry.balancedTagNeedle
		; It's an LRU cache
		cache.RemoveAt(cacheEntry.lruIndex)
		cacheEntry.lruIndex := cache.Push(cacheKey)
	} else {
		; Note: we're being lenient
		static namePatt := "[^\s/<>=""']+"
		static attrValPatt := """[^""]*""|'[^']*'|[^\s<>=""']+"
		static attrPatt := namePatt "(?:\s*=\s*(?:" attrValPatt "))?"
		static validator := "^<(?P<TagName>" namePatt ")((?:\s+" attrPatt ")*)\s*(>)?$"

		if (!RegexMatch(ExactStartTag, validator, m))
			throw Exception("Parameter ``ExactStartTag`` must be an XML start tag.", -1, ExactStartTag)

		static regexEscSet := "S)[\Q\.*?+[{|()^$\E]"
		targetTagNamePatt := RegexReplace(mTagName, regexEscSet, "\$0")

		if (LiteralWhitespace) {
			startTagNeedle := "\Q" StrReplace(ExactStartTag, "\E", "\E\\E\Q") "\E"
			if (!m3)
				startTagNeedle .= "(?:\s+" attrPatt ")*\s*>"
		} else {
			startTagNeedle := "<" targetTagNamePatt
			if (m2) {
				m2 := RegexReplace(m2, regexEscSet, "\$0")
				m2 := RegexReplace(m2, "\s+(" attrPatt ")", "\s+$1")
				m2 := RegexReplace(m2, "\s*=\s*(" attrValPatt ")", "\s*=\s*$1")
				startTagNeedle .= m2
			}
			startTagNeedle .= m3 ? "\s*>" : "(?:\s+" attrPatt ")*\s*>"
		}

		caseSenseOpt := CaseSensitive ? "" : "(?i)"
		; Also, take into account comments and CDATA sections
		static cdataOrCommentPatt := "<!(?:\[CDATA\[.*?\]\]|--.*?--)>"
		static UCP := A_IsUnicode ? "(*UCP)" : ""

		startTagNeedle := "Ss)" UCP cdataOrCommentPatt
			. "|(?P<StartTag>" caseSenseOpt startTagNeedle ")"

		balancedTagNeedle := "Ss)" UCP cdataOrCommentPatt ""
			. "|(?P<InnerStartTag>" caseSenseOpt "<" targetTagNamePatt "(?:\s+" attrPatt ")*\s*>)"
			. "|(?P<EndTag>" caseSenseOpt "</" targetTagNamePatt "\s*>)"

		; Now cache it!
		cacheEntry := {startTagNeedle: startTagNeedle, balancedTagNeedle: balancedTagNeedle}
		cache[cacheKey] := cacheEntry
		cacheEntry.lruIndex := cache.Push(cacheKey)
		cacheKeys_totalStrLen += StrLen(cacheKey)

		cacheKeys_totalStrLen_max := Max(4096, StrLen(cacheKey))
		while (cacheKeys_totalStrLen > cacheKeys_totalStrLen_max) {
			removedKey := cache.RemoveAt(1)
			if (!removedKey || (cacheKeys_totalStrLen -= StrLen(removedKey)) < 0) {
				; This shouldn't happen. But, just in case it does...
				cache := {}
				cacheKeys_totalStrLen := 0
				break
			}
			cache.Delete(removedKey)
		}
	}

	; --
	; Find the start tag

	cur := StartPos
	loop {
		startTagPos := RegexMatch(Haystack, startTagNeedle, m, cur)
		if (!startTagPos)
			return ""
		cur := startTagPos + StrLen(m)
	} until (StrLen(mStartTag))

	global XMLBalancedFind_Return
	ret := new XMLBalancedFind_Return()

	ret.Pos := startTagPos
	ret.StartTag := mStartTag

	; --
	; Find the end tag

	depth := 0
	while (cur := RegexMatch(Haystack, balancedTagNeedle, m, cur)) {
		if (mEndTag) {
			if (!depth) {
				contentPos := startTagPos + StrLen(mStartTag)
				ret.Content := SubStr(Haystack, contentPos, cur - contentPos)
				ret.EndTag := mEndTag
				return ret
			}
			depth--
		} else if (mInnerStartTag) {
			depth++
		}
		cur += StrLen(m)
	}

	; No matching end tag found
	ret.Content := SubStr(Haystack, startTagPos + StrLen(mStartTag))
	return ret
}

class XMLBalancedFind_Return
{
	Element {
		get {
			this.StrLength := StrLen(this.Element := this.StartTag . this.Content . this.EndTag)
			return this.Element
		}
	}

	StrLength {
		get {
			return (this.StrLength := StrLen(this.StartTag) + StrLen(this.Content) + StrLen(this.EndTag))
		}
	}
}
