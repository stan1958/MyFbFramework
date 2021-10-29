﻿'################################################################################
'#  ReBar.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "Control.bi"
#include once "Graphic.bi"

Namespace My.Sys.Forms
	#define QReBar(__Ptr__) *Cast(ReBar Ptr, __Ptr__)
	#define REBAR_HEIGHT 35
	
	Type ReBarBand Extends My.Sys.Object
	Private:
		FCaption As WString Ptr
	Public:
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ReBarBandCollection Extends List
	Private:
	Public:
		Declare Property Item(Index As Integer) As ReBarBand Ptr
		Declare Property Item(Index As Integer, FItem As ReBarBand Ptr)
		Declare Sub Add(FItem As Any Ptr)
		Declare Sub Add(ByRef Caption As WString)
		Declare Sub Insert(Index As Integer, FItem As Any Ptr)
		Declare Sub Add(ByRef Caption As WString)
		Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
		Declare Sub Remove(Index As Integer)
		Declare Sub Clear
		Declare Function IndexOf(FItem As Any Ptr) As Integer
		Declare Function Contains(FItem As Any Ptr) As Boolean
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ReBar Extends ContainerControl
	Private:
		FBackColor      As Integer
		m_BandCount     As Integer   = 0
		m_BMP           As WString Ptr                                ' Bitmap strip for imgList
		' Handle to the popup menu
		Declare Static Sub GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		ImageList       As ImageList Ptr                                   ' One image per band
		ImageBacking    As My.Sys.Drawing.BitmapType                                       ' Bitmap used for backing image
		Declare Property BackColor() As Integer
		Declare Property BackColor(value As Integer)
		Declare Property BandCount() As Integer
		Declare Property BandCount(value As Integer)
		Declare Property BMP() ByRef As WString
		Declare Property BMP(ByRef value As WString)
		Declare Property BandRect(ByVal uBand As Integer) As My.Sys.Drawing.Rect
		Declare Sub Add(Ctrl As Control Ptr)
		Declare Sub AddBand(value As Control Ptr)
		Declare Sub AddBand(value  As Control Ptr, ByRef Caption As WString)
		Declare Sub AddBand(value  As Control Ptr, idx As Integer, ByRef Caption As WString)
		Declare Sub UpdateReBar()
		Declare Property ShowBand(ByVal uBand As Integer, ByVal fShow As Boolean) ' Shows or hides a given band in a rebar control.
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnHeightChange As Sub(ByRef Sender As ReBar)
		OnPopup        As Sub(ByRef Sender As ReBar, Index As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ReBar.bas"
#endif
