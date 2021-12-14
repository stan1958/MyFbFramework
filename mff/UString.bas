﻿#include once "UString.bi"
#include once "utf_conv.bi"

Private Constructor UString()
	m_Length = 0
	m_BytesCount = SizeOf(WString)
	m_Data = CAllocate_(SizeOf(WString))
	If m_Data <> 0 Then
		m_Data[0] = 0
	End If
End Constructor

Private Constructor UString(ByRef Value As WString)
	m_Length = Len(Value)
	m_BytesCount = (m_Length + 1) * SizeOf(WString)
	m_Data = CAllocate_(m_BytesCount)
	If m_Data <> 0 Then
		*m_Data = Value
	End If
End Constructor

Private Constructor UString(ByRef Value As UString)
	m_Length = Value.m_Length
	m_BytesCount = Value.m_BytesCount
	m_Data = CAllocate_(m_BytesCount)
	If m_Data <> 0 Then
		*m_Data = *Value.m_Data
	End If
End Constructor

Private Destructor UString
	If m_Data <> 0 Then
		Deallocate_(m_Data)
	End If
End Destructor

Private Function UString.StartsWith(ByRef Value As UString) As Boolean
	Return Left(*m_Data, Value.m_Length) = * (Value.vptr)
End Function

Private Function UString.EndsWith(ByRef Value As UString) As Boolean
	Return Right(*m_Data, Value.m_Length) = * (Value.vptr)
End Function

Private Function UString.ToLower As UString
	Return LCase(*m_Data)
End Function

Private Function UString.ToUpper As UString
	Return UCase(*m_Data)
End Function

Private Function UString.TrimAll As UString
	Return Trim(*m_Data)
End Function

Private Function UString.TrimEnd As UString
	Return RTrim(*m_Data)
End Function

Private Function UString.TrimStart As UString
	Return LTrim(*m_Data)
End Function

Private Sub UString.Resize(NewLength As Integer)
	'If NewLength > m_Length Then
	m_BytesCount = (NewLength + 1) * SizeOf(WString)
	If m_Length < NewLength Then
		WReallocate(m_Data, NewLength)
	End If
	m_Length = NewLength
	'		If m_Data <> 0 Then
	'			Deallocate_(m_Data)
	'		End If
	'		m_Data = Allocate_(m_BytesCount)
	'End If
End Sub

Private Function UString.AppendBuffer(ByVal addrMemory As Any Ptr, ByVal NumBytes As ULong) As Boolean
	This.Resize(m_Length + NumBytes)
	If m_Data = 0 Then Return False
	#ifdef __FB_WIN32__
		memcpy(m_Data + m_BufferLen, addrMemory, NumBytes)
	#endif
	m_BufferLen += NumBytes
	Return True
End Function

Private Operator UString.[](ByVal Index As Integer) ByRef As UShort
	Static Zero As UShort = 0
	If Index < 0 Or Index > m_Length Then Return Zero
	Operator = *Cast(UShort Ptr, m_Data + (Index * 2))
End Operator

Private Operator UString.Let(ByRef lhs As UString)
	If @This <> @lhs Then
		If lhs.m_Length > m_Length Then
			If m_Data <> 0 Then
				Deallocate_(m_Data)
			End If
			m_Data = Allocate_(lhs.m_BytesCount)
		End If
		m_Length = lhs.m_Length
		m_BytesCount = lhs.m_BytesCount
		m_BufferLen = lhs.m_BufferLen
		
		If m_Data <> 0 Then
			*m_Data = *lhs.m_Data
		End If
	End If
End Operator

Private Operator UString.Let(ByRef lhs As WString)
	Resize Len(lhs)
	If m_Data <> 0 Then
		*m_Data = lhs
		m_BufferLen = Len(lhs) * 2
	End If
End Operator

Private Property UString.Length() As Integer
	Return m_Length
End Property

Private Operator UString.Cast() ByRef As WString
	Return *m_Data
End Operator

Private Operator UString.Cast() As Any Ptr
	Return CPtr(Any Ptr, m_Data)
End Operator

Private Function UString.vptr As WString Ptr
	Return m_Data
End Function

Private Function Val Overload(ByRef subject As UString) As Double
	Return Val(*(subject.vptr))
End Function

Private Operator Len(ByRef lhs As UString) As Integer
	Return Len(*lhs.vptr)
End Operator

Private Function WStrPtr(ByRef Value As UString) As WString Ptr
	Return Value.vptr
End Function

#if MEMCHECK
	#define WReAllocate(subject, lLen) If subject <> 0 Then: subject = Reallocate_(subject, (lLen + 1) * SizeOf(WString)): Else: subject = CAllocate_((lLen + 1) * SizeOf(WString)): End If
	#define WLet(subject, txt) Scope: Dim As UString txt1 = txt: WReAllocate(subject, Len(txt1)): *subject = txt1: End Scope
#else
	Private Sub WReAllocate(ByRef subject As WString Ptr, lLen As Integer)
		If subject <> 0 Then
			subject = Reallocate_(subject, (lLen + 1) * SizeOf(WString)) 'Cast(WString Ptr, )
		Else
			subject = CAllocate_((lLen + 1) * SizeOf(WString)) 'Cast(WString Ptr, )
		End If
	End Sub
	
	Private Sub WLet(ByRef subject As WString Ptr, ByRef txt As WString)
		WReAllocate(subject, Len(txt))
		*subject = txt
	End Sub
#endif

Private Sub WLetEx(ByRef subject As WString Ptr, ByRef txt As WString, ExistsSubjectInTxt As Boolean)
	If ExistsSubjectInTxt Then
		Dim TempWStr As WString Ptr
		WLet(TempWStr, txt)
		WLet(subject, *TempWStr)
		WDeallocate TempWStr
	Else
		WReAllocate(subject, Len(txt))
		*subject = txt
	End If
End Sub

Private Sub WAdd(ByRef subject As WString Ptr, ByRef txt As WString, AddBefore As Boolean = False)
	Dim TempWStr As WString Ptr
	If AddBefore Then
		WLet(TempWStr, txt & WGet(subject))
	Else
		WLet(TempWStr, WGet(subject) & txt)
	End If
	WLet(subject, *TempWStr)
	WDeallocate TempWStr
End Sub

Private Function tallynumW Overload(ByRef somestring As WString, ByRef partstring As WString) As Integer
	Dim As Integer i,j,ln,lnp,count,num
	ln=Len(somestring):If ln=0 Then Return 0
	lnp=Len(partstring):If lnp=0 Then Return 0
	count=0
	i=-1
	Do
		i+=1
		If somestring[i] <> partstring[0] Then Continue Do
		If somestring[i] = partstring[0] Then
			For j=0 To lnp-1
				If somestring[j+i]<>partstring[j] Then Continue Do
			Next j
		End If
		count+=1
		i=i+lnp-1
	Loop Until i>=ln-1
	Return count
End Function

Private Operator & (ByRef lhs As UString, ByRef rhs As UString) As UString
	Return *(lhs.vptr) & *(rhs.vptr)
End Operator

Private Function Left Overload(ByRef subject As UString, ByVal n As Integer) As UString
	Return Left(*(subject.vptr), n)
End Function

Private Sub WDeAllocate Overload(ByRef subject As WString Ptr)
	If subject <> 0 Then Deallocate_(subject)
	subject = 0
End Sub

Private Sub WDeAllocate Overload(subject() As WString Ptr)
	For i As Integer = 0 To UBound(subject)
		'If subject(i) <> 0 Then Deallocate(subject(i))
		subject(i) = 0
	Next
End Sub

Private Function WGet(ByRef subject As WString Ptr) ByRef As WString
	If subject = 0 Then Return WStr("") Else Return *subject
End Function

Private Function ToUtf8(ByRef nWString As WString) As String
	'	#ifdef __USE_GTK__
	'		Static As gchar Ptr s = NULL
	'		Dim As GError Ptr Error1 = NULL
	'		Dim As gsize r_bytes, w_bytes
	'		Dim As ZString Ptr fc
	'		Dim As gchar Ptr from_codeset = NULL
	'
	'		If nWString = "" Then Return ""
	'		'If (t = 0) Then g_assert_not_reached()
	'		'If (g_utf8_validate(Cast(gchar Ptr, @nWString), -1, NULL)) Then Return nWString
	'
	'		/' so we got a non-UTF-8 '/
	'
	'		If Len(Environ("SMB_CODESET")) <> 0 Then
	'			from_codeset = g_strdup(Environ("SMB_CODESET"))
	'		Else
	'			g_get_charset(@fc)
	'			If (fc) Then
	'				from_codeset = g_strdup(fc)
	'			Else
	'				from_codeset = g_strdup("ISO-8859-1")
	'			End If
	'		End If
	'
	'		If *from_codeset = "ISO-" Then
	'			g_free(from_codeset)
	'			from_codeset = g_strdup("ISO-8859-1")
	'		End If
	'		If (s) Then g_free(s)
	'
	''		For c As Integer = 0 To Len(nWString)
	''			If (@nWString)[c] < 32 AndAlso (@nWString)[c] <> Asc(!"\n") Then (@nWString)[c] = Asc(" ")
	''		Next
	'		s = g_convert(nWString, Len(nWString), "UTF-8", from_codeset, @r_bytes, @w_bytes, @Error1)
	'		g_free(from_codeset)
	'
	''		If (s = 0) Then
	''			s = g_strdup(Cast(gchar Ptr, @nWString))
	''			For c As Integer = 0 To Len(*s)
	''				If s[c] > 128 Then s[c] = Asc("?")
	''			Next
	''		End If
	'		If (Error1) Then
	'			'Print ("DBG: %s. Codeset for system is: %s\n", Error->message,from_codeset)
	'			'Print ("DBG: You should set the environment variable SMB_CODESET To ISO-8859-1\n")
	'			g_error_free(Error1)
	'		End If
	'		Return *s
	'		'Return *g_locale_to_utf8(nWString, Len(nWString), 0, 0, 0)
	'	#else
	'		Dim cbLen As Integer
	'		Dim m_BufferLen As Integer = Len(nWString)
	'		If m_BufferLen = 0 Then Return ""
	'		Dim buffer As String = String(m_BufferLen * 5 + 1, 0)
	'		Return *Cast(ZString Ptr, WCharToUTF(1, @nWString, m_BufferLen * 2, StrPtr(buffer), @cbLen))
	Dim As Integer m_BufferLen = Len(nWString)
	Dim i1 As ULong = m_BufferLen * 5 + 1                   'if all unicode chars use 5 bytes in utf8
	Dim As String ansiStr = String(i1, 0)
	Return *Cast(ZString Ptr, WCharToUTF(1, @nWString, m_BufferLen, StrPtr(ansiStr), Cast(Integer Ptr, @i1)))
	'#endif
End Function

Private Function FromUtf8(pZString As ZString Ptr) ByRef As WString
	'	#ifdef __USE_GTK__
	'		Return g_locale_from_utf8(*pZString, Len(*pZString), 0, 0, 0)
	'	#else
	'UTF-8: EF BB BF
	'UTF-16: FF FE
	'UTF-16 big-endian: FE FF
	'UTF-32 little-endian: FF FE 00 00
	'UTF-32 big-endian: 00 00 FE FF
	Dim cbLen As Integer
	Dim m_BufferLen As Integer = Len(*pZString)
	If m_BufferLen = 0 Then Return ""
	Dim buffer As WString Ptr
	WLet(buffer, WString(m_BufferLen * 5 + 1, 0))
	'WReallocate buffer, m_BufferLen * 5 + 1
	Return WGet(UTFToWChar(1, pZString, buffer, @cbLen))
	'#endif
End Function

Private Function StrLSet(ByRef MainStr As Const WString, ByVal StringLength As Long, ByRef PadCharacter As Const WString = " ") As UString
	Dim strn As UString = WString(StringLength, PadCharacter)
	Mid(strn, 1, Len(MainStr)) = MainStr
	Return strn
End Function

Private Function StrRSet(ByRef MainStr As Const WString, ByVal StringLength As Long, ByRef PadCharacter As Const WString = " ") As UString
	If Len(MainStr) > StringLength Then Return Left(MainStr, StringLength)
	Dim strn As UString = WString(StringLength, PadCharacter)
	Mid(strn, StringLength - Len(MainStr) + 1, Len(MainStr)) = MainStr
	Return strn
End Function

#ifndef __USE_JNI__
	Private Function FileExists (ByRef FileName As UString) As Boolean
		#ifdef __USE_GTK__
			If g_file_test(ToUtf8(*FileName.vptr), G_FILE_TEST_EXISTS) Then
				Return True
			Else
				Return False
			End If
		#elseif __USE_JNI__
			Return 0
		#else
			If Dir(*FileName.vptr) <> "" Then
				Return True
			Else
				Return False
			End If
		#endif
	End Function
	
	Private Function FileExists Overload(ByRef FileName As WString) As Boolean
		#ifdef __USE_GTK__
			If g_file_test(ToUtf8(FileName), G_FILE_TEST_EXISTS) Then
				Return True
			Else
				Return False
			End If
		#elseif __USE_JNI__
			Return 0
		#else
			If Dir(FileName) <> "" Then
				Return True
			Else
				Return False
			End If
		#endif
	End Function
#endif