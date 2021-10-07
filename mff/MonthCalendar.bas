﻿'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "MonthCalendar.bi"

Namespace My.Sys.Forms
	Function MonthCalendar.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "selecteddate": FSelectedDate = SelectedDate: Return @FSelectedDate
		Case "weeknumbers": Return @FWeekNumbers
		Case "todaycircle": Return @FTodayCircle
		Case "todayselector": Return @FTodaySelector
		Case "trailingdates": Return @FTrailingDates
		Case "shortdaynames": Return @FShortDayNames
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function MonthCalendar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "selecteddate": SelectedDate = QLong(Value)
			Case "weeknumbers": WeekNumbers = QBoolean(Value)
			Case "todaycircle": TodayCircle = QBoolean(Value)
			Case "todayselector": TodaySelector = QBoolean(Value)
			Case "trailingdates": TrailingDates = QBoolean(Value)
			Case "shortdaynames": ShortDayNames = QBoolean(Value)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Property MonthCalendar.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property MonthCalendar.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property MonthCalendar.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property MonthCalendar.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Property MonthCalendar.SelectedDate() As Long
		If This.FHandle Then
			#ifdef __USE_GTK__
				Dim As guint y, m, d
				gtk_calendar_get_date(gtk_calendar(FHandle), @y, @m, @d)
				FSelectedDate = DateSerial(y, m + 1, d)
			#else
				Dim As SYSTEMTIME pst
				MonthCal_GetCurSel(This.FHandle, @pst)
				FSelectedDate = DateSerial(pst.wYear, pst.wMonth, pst.wDay)
			#endif
		End If
		Return FSelectedDate
	End Property
	
	Property MonthCalendar.SelectedDate(ByVal Value As Long)
		If This.FHandle Then
			#ifdef __USE_GTK__
				gtk_calendar_select_month(gtk_calendar(FHandle), Month(FSelectedDate) - 1, Year(FSelectedDate))
				gtk_calendar_select_day(gtk_calendar(FHandle), Day(FSelectedDate))
				If FTodayCircle Then
					If Month(FSelectedDate) = Month(Now) AndAlso Year(FSelectedDate) = Year(Now) Then
						gtk_calendar_mark_day(gtk_calendar(FHandle), Day(Now))
					Else
						gtk_calendar_unmark_day(gtk_calendar(FHandle), Day(Now))
					End If
				End If
			#else
				Dim As SYSTEMTIME pst
				pst.wYear  = Year(Value)
				pst.wMonth = Month(Value)
				pst.wDay   = Day(Value)
				MonthCal_SetCurSel(This.FHandle, @pst)
			#endif
		End If
		FSelectedDate = Value
	End Property
	
	
	Property MonthCalendar.WeekNumbers() As Boolean
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(gtk_calendar(FHandle))
				FWeekNumbers = StyleExists(GTK_CALENDAR_SHOW_WEEK_NUMBERS)
			#else
				FWeekNumbers = StyleExists(MCS_WEEKNUMBERS)
			#endif
		End If
		Return FWeekNumbers
	End Property
	
	Property MonthCalendar.WeekNumbers(ByVal Value As Boolean)
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(gtk_calendar(FHandle))
				ChangeStyle GTK_CALENDAR_SHOW_WEEK_NUMBERS, Value
				gtk_calendar_set_display_options(gtk_calendar(FHandle), FStyle)
			#else
				ChangeStyle MCS_WEEKNUMBERS, Value
				This.Repaint
			#endif
		End If
		FWeekNumbers = Value
	End Property
	
	Property MonthCalendar.TodayCircle() As Boolean
		If This.FHandle Then
			#ifndef __USE_GTK__
				FTodayCircle = Not StyleExists(MCS_NOTODAYCIRCLE)
			#endif
		End If
		Return FTodayCircle
	End Property
	
	Property MonthCalendar.TodayCircle(ByVal Value As Boolean)
		If This.FHandle Then
			#ifndef __USE_GTK__
				ChangeStyle MCS_NOTODAYCIRCLE, Not Value
				This.Repaint
			#endif
		End If
		FTodayCircle = Value
	End Property
	
	Property MonthCalendar.TodaySelector() As Boolean
		If This.FHandle Then
			#ifndef __USE_GTK__
				FTodaySelector = Not StyleExists(MCS_NOTODAY)
			#endif
		End If
		Return FTodaySelector
	End Property
	
	Property MonthCalendar.TodaySelector(ByVal Value As Boolean)
		If This.FHandle Then
			#ifndef __USE_GTK__
				ChangeStyle MCS_NOTODAY, Not Value
				This.Repaint
			#endif
		End If
		FTodaySelector = Value
	End Property
	
	Property MonthCalendar.TrailingDates() As Boolean
		If This.FHandle Then
			#ifndef __USE_GTK__
				#if _WIN32_WINNT >= &h0600
					FTrailingDates = Not StyleExists(MCS_NOTRAILINGDATES)
				#endif
				This.Repaint
			#endif
		End If
		Return FTrailingDates
	End Property
	
	Property MonthCalendar.TrailingDates(ByVal Value As Boolean)
		If This.FHandle Then
			#ifndef __USE_GTK__
				#if _WIN32_WINNT >= &h0600
					ChangeStyle MCS_NOTRAILINGDATES, Not Value
				#endif
				This.Repaint
			#endif
		End If
		FTrailingDates = Value
	End Property
	
	Property MonthCalendar.ShortDayNames() As Boolean
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(gtk_calendar(FHandle))
				FShortDayNames = StyleExists(GTK_CALENDAR_SHOW_DAY_NAMES)
			#else
				#if _WIN32_WINNT >= &h0600
					FShortDayNames = StylExists(MCS_SHORTDAYSOFWEEK)
				#endif
			#endif
		End If
		Return FShortDayNames
	End Property
	
	Property MonthCalendar.ShortDayNames(ByVal Value As Boolean)
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(gtk_calendar(FHandle))
				ChangeStyle GTK_CALENDAR_SHOW_DAY_NAMES, Value
				gtk_calendar_set_display_options(gtk_calendar(FHandle), FStyle)
			#else
				#if _WIN32_WINNT >= &h0600
					ChangeStyle MCS_SHORTDAYSOFWEEK, Value
				#endif
				This.Repaint
			#endif
		End If
		FShortDayNames = Value
	End Property
	
	#ifndef __USE_GTK__
		Sub MonthCalendar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QMonthCalendar(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub MonthCalendar.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub MonthCalendar.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_NOTIFY
				Dim lpChange As NMSELCHANGE Ptr = Cast(NMSELCHANGE Ptr, message.lparam)
				Select Case lpChange->nmhdr.code
				Case MCN_SELECT
					If OnClick Then OnClick(This)
				Case MCN_SELCHANGE
					If OnSelectionChanged Then OnSelectionChanged(This)
				End Select
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator MonthCalendar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub MonthCalendar.Calendar_DaySelected(calendar As GtkCalendar Ptr, user_data As Any Ptr)
			Dim As MonthCalendar Ptr cal = user_data
			If cal->OnSelect Then cal->OnSelect(*cal)
		End Sub
	#endif
	
	Constructor MonthCalendar
		With This
			WLet(FClassName, "MonthCalendar")
			WLet(FClassAncestor, "SysMonthCal32")
			FTabIndex          = -1
			FTabStop           = True
			#ifdef __USE_GTK__
				widget = gtk_calendar_new ()
				g_signal_connect(widget, "day-selected", G_CALLBACK(@Calendar_DaySelected), @This)
				.RegisterClass "MonthCalendar", @This
			#else
				.RegisterClass "MonthCalendar","SysMonthCal32"
				.Style        = WS_CHILD
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor MonthCalendar
		#ifndef __USE_GTK__
			UnregisterClass "MonthCalendar",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
