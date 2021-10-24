﻿'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "PageScroller.bi"

Namespace My.Sys.Forms
	Function PageScroller.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "arrowchangesize": Return @FArrowChangeSize
		Case "autoscroll": Return @FAutoScroll
		Case "childdragdrop": Return @FChildDragDrop
		Case "position": Position: Return @FPosition
		Case "style": Return @This.FStyle
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function PageScroller.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "arrowchangesize": This.ArrowChangeSize = QInteger(Value)
			Case "autoscroll": This.AutoScroll = QBoolean(Value)
			Case "childdragdrop": This.ChildDragDrop = QBoolean(Value)
			Case "position": This.Position = QInteger(Value)
			Case "style": This.Style = *Cast(PageScrollerStyle Ptr, Value)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Property PageScroller.ArrowChangeSize As Integer
		Return FArrowChangeSize
	End Property
	
	Property PageScroller.ArrowChangeSize(Value As Integer)
		FArrowChangeSize = Value
	End Property
	
	Property PageScroller.AutoScroll As Boolean
		Return FAutoScroll
	End Property
	
	Property PageScroller.AutoScroll(Value As Boolean)
		FAutoScroll = Value
		#ifndef __USE_GTK__
			ChangeStyle PGS_AUTOSCROLL, Value
		#endif
	End Property
	
	Property PageScroller.ChildDragDrop As Boolean
		Return FChildDragDrop
	End Property
	
	Property PageScroller.ChildDragDrop(Value As Boolean)
		FChildDragDrop = Value
		#ifndef __USE_GTK__
			ChangeStyle PGS_DRAGNDROP, Value
		#endif
	End Property
	
	Property PageScroller.Position As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				FPosition = SendMessage(FHandle, PGM_GETPOS, 0, 0)
			End If
		#endif
		Return FPosition
	End Property
	
	Property PageScroller.Position(Value As Integer)
		FPosition = Value
		#ifndef __USE_GTK__
			If FHandle Then
				SendMessage(FHandle, PGM_SETPOS, 0, Cast(LPARAM, FPosition))
			End If
		#endif
	End Property
	
	Property PageScroller.Style As PageScrollerStyle
		Return FStyle
	End Property
	
	Property PageScroller.Style(Value As PageScrollerStyle)
		Dim As PageScrollerStyle OldStyle
		Dim As Integer iWidth, iHeight
		OldStyle = FStyle
		If Value <> FStyle Then
			#ifndef __USE_GTK__
				ChangeStyle PGS_HORZ, False
				ChangeStyle PGS_VERT, False
			#endif
			Select Case Value
			Case psHorizontal
				#ifndef __USE_GTK__
					ChangeStyle PGS_HORZ, True
				#endif
				'				iWidth = This.Width
				'				iHeight = Height
				'				#ifdef __USE_GTK__
				'					gtk_orientable_set_orientation(gtk_orientable(widget), GTK_ORIENTATION_HORIZONTAL)
				'				#endif
				'				This.Width = iHeight
				'				Height  = iWidth
			Case psVertical
				#ifndef __USE_GTK__
					ChangeStyle PGS_VERT, True
				#endif
				'				iHeight = Height
				'				iWidth = This.Width
				'				#ifdef __USE_GTK__
				'					gtk_orientable_set_orientation(gtk_orientable(widget), GTK_ORIENTATION_VERTICAL)
				'				#endif
				'				Height = iWidth
				'				This.Width  = iHeight
			End Select
			FStyle = Value
		End If
	End Property
	
	Property PageScroller.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property PageScroller.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property PageScroller.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property PageScroller.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Sub PageScroller.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QPageScroller(Sender.Child)
					If .ChildControl AndAlso .ChildControl->Handle Then SendMessage(.Handle, PGM_SETCHILD, 0, Cast(LPARAM, .ChildControl->Handle))
				End With
			End If
		End Sub
		
		Sub PageScroller.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub PageScroller.Add(Ctrl As Control Ptr)
		If ChildControl = 0 Then
			ChildControl = Ctrl
			Base.Add(Ctrl)
			#ifndef __USE_GTK__
				If FHandle AndAlso Ctrl->Handle Then
					SendMessage(FHandle, PGM_SETCHILD, 0, Cast(LPARAM, Ctrl->Handle))
				End If
			#endif
		Else
			Print "MFF: Can't add second control to PageScroller"
		End If
	End Sub
	
	Sub PageScroller.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_NOTIFY
				Dim As NMHDR Ptr nmhdr_ = Cast(NMHDR Ptr, Message.lParam)
				If nmhdr_->code = PGN_CALCSIZE Then
					Dim As NMPGCALCSIZE Ptr nmcal = Cast(NMPGCALCSIZE Ptr, Message.lParam)
					If nmcal->dwFlag = PGF_CALCWIDTH Then
						nmcal->iWidth = ChildControl->Width
					ElseIf nmcal->dwFlag = PGF_CALCHEIGHT Then
						nmcal->iHeight = ChildControl->Height
					EndIf
				ElseIf nmhdr_->code = PGN_SCROLL Then
					Dim As NMPGSCROLL2 Ptr nmgs = Cast(NMPGSCROLL2 Ptr, Message.lParam)
					Dim As Integer NewPos = nmgs->iXpos + nmgs->iYpos
					Select Case nmgs->iDir
					Case PGF_SCROLLDOWN
						NewPos = Min(ChildControl->Height, NewPos + FArrowChangeSize)
					Case PGF_SCROLLRIGHT
						NewPos = Min(ChildControl->Width, NewPos + FArrowChangeSize)
					Case PGF_SCROLLUP, PGF_SCROLLLEFT
						NewPos = Max(0, NewPos - FArrowChangeSize)
					End Select
					nmgs->iScroll = FArrowChangeSize
					If OnScroll Then OnScroll(This, NewPos)
				EndIf
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator PageScroller.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor PageScroller
		With This
			WLet(FClassName, "PageScroller")
			WLet(FClassAncestor, "SysPager")
			FArrowChangeSize = 40
			#ifndef __USE_GTK__
				.RegisterClass "PageScroller","SysPager"
				Base.Style        = WS_CHILD Or PGS_HORZ
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			FTabIndex          = -1
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor PageScroller
		#ifndef __USE_GTK__
			UnregisterClass "PageScroller", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
