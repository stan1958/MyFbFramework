﻿'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QMonthCalendar(__Ptr__) *Cast(MonthCalendar Ptr, __Ptr__)
	
	Type MonthCalendar Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Public:
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "MonthCalendar.bas"
#EndIf
