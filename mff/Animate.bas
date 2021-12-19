﻿'###############################################################################
'#  Animate.bas                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TAnimate.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#include once "Animate.bi"

Namespace My.Sys.Forms
	Private Function Animate.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "autoplay": Return @FAutoPlay
		Case "autosize": Return @FAutoSize
		Case "center": Return @FCenter
		Case "commonavi": Return @FCommonAVI
		Case "file": Return FFile
		Case "repeat": Return @FRepeat
		Case "startframe": Return @FStartFrame
		Case "stopframe": Return @FStopFrame
		Case "timers": Return @FTimers
		Case "transparency": Return @FTransparent
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function Animate.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "autoplay": AutoPlay = QBoolean(Value)
		Case "autosize": AutoSize = QBoolean(Value)
		Case "center": Center = QBoolean(Value)
		Case "commonavi": CommonAVI = *Cast(CommonAVIs Ptr, Value)
		Case "file": File = QWString(Value)
		Case "repeat": Repeat = QInteger(Value)
		Case "startframe": StartFrame = QInteger(Value)
		Case "stopframe": StopFrame = QInteger(Value)
		Case "timers": Timers = QBoolean(Value)
		Case "transparency": Transparency = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Sub Animate.GetAnimateInfo
		#ifdef __USE_GTK__
			If pixbuf_animation <> 0 Then
				FFrameWidth = gdk_pixbuf_animation_get_width(pixbuf_animation)
				FFrameHeight = gdk_pixbuf_animation_get_height(pixbuf_animation)
			End If
		#else
			If basvideo <> 0 Then
				IBasicVideo_get_SourceWidth(basvideo, @FFrameWidth)
				IBasicVideo_get_SourceHeight(basvideo, @FFrameHeight)
			Else
				Dim As HRSRC Resource
				Dim As HGLOBAL Global
				Dim As Any Ptr PResource
				Dim As UByte Ptr P
				Dim As Integer F, Size
				Dim As Integer Ptr Buff = Allocate_(18*SizeOf(Integer))
				If *FFile <> "" Then
					F = FreeFile
					.Open *FFile For Binary Access Read As #F
					Get #F, , *Buff, 18
					.Close #F
					FFrameCount  = Buff[12]
					FFrameWidth  = Buff[16]
					FFrameHeight = Buff[17]
				Else
					Resource  = FindResource(GetModuleHandle("Shell32"),MakeIntResource(FCommonAvi),"AVI")
					Global    = LoadResource(GetModuleHandle("Shell32"),Resource)
					PResource = LockResource(Global)
					Size = SizeOfResource(GetModuleHandle("Shell32"),Resource)
					P = Allocate_(Size)
					P = PResource
					FreeResource(Resource)
					memcpy Buff, P, 18 * SizeOf(Integer)
					FFrameCount  = Buff[12]
					FFrameWidth  = Buff[16]
					FFrameHeight = Buff[17]
				End If
			End If
		#endif
	End Sub
	
	Private Property Animate.Center As Boolean
		Return FCenter
	End Property
	
	Private Property Animate.Center(Value As Boolean)
		If FCenter <> Value Then
			FCenter = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Private Property Animate.Transparency As Boolean
		Return FTransparent
	End Property
	
	Private Property Animate.Transparency(Value As Boolean)
		If FTransparent <> Value Then
			FTransparent = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Private Property Animate.Timers As Boolean
		Return FTimers
	End Property
	
	Private Property Animate.Timers(Value As Boolean)
		If FTimers <> Value Then
			FTimers = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Private Property Animate.File ByRef As WString
		If FFile> 0 Then Return *FFile Else Return ""
	End Property
	
	Private Property Animate.File(ByRef Value As WString)
		FFile = Reallocate_(FFile, (Len(Value) + 1) * SizeOf(WString))
		*FFile = Value
		#ifdef __USE_GTK__
			pixbuf_animation = gdk_pixbuf_animation_new_from_file(ToUTF8(*FFile), NULL)
		#else
			If FHandle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle(NULL))
				Open
			End If
		#endif
	End Property
	
	Private Property Animate.Repeat As Integer
		Return FRepeat
	End Property
	
	Private Property Animate.Repeat(Value As Integer)
		FRepeat = Value
	End Property
	
	Private Property Animate.AutoPlay As Boolean
		Return FAutoPlay
	End Property
	
	Private Property Animate.AutoPlay(Value As Boolean)
		If FAutoPlay <> Value Then
			FAutoPlay = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Private Property Animate.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Private Property Animate.AutoSize(Value As Boolean)
		FAutoSize = Value
		#ifndef __USE_GTK__
			If CInt(FAutoSize) AndAlso CInt(FHandle) AndAlso CInt(Not FDesignMode) Then
				This.Width = FFrameWidth
				This.Height = FFrameHeight
			End If
		#endif
	End Property
	
	Private Property Animate.CommonAvi As CommonAVIs
		Return FCommonAvi
	End Property
	
	Private Property Animate.CommonAvi(Value As CommonAVIs)
		FCommonAvi = Value
		#ifndef __USE_GTK__
			If Handle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle("Shell32"))
				Open
			End If
		#endif
	End Property
	
	Private Property Animate.StartFrame As Integer
		Return FStartFrame
	End Property
	
	Private Property Animate.StartFrame(Value As Integer)
		FstartFrame = Value
		If FStartFrame < 0 Then FStartFrame = 0
		If FPlay Then This.Stop
		Play
	End Property
	
	Private Property Animate.StopFrame As Integer
		Return FStopFrame
	End Property
	
	Private Property Animate.StopFrame(Value As Integer)
		FStopFrame = Value
		If FStopFrame > FFrameCount Then FStopFrame = FFrameCount
		If FPlay Then This.Stop
		Play
	End Property
	
	Private Function Animate.FrameCount As Integer
		GetAnimateInfo
		Return FFrameCount
	End Function
	
	Private Function Animate.FrameHeight As Integer
		GetAnimateInfo
		Return FFrameHeight
	End Function
	
	Private Function Animate.FrameWidth As Integer
		GetAnimateInfo
		Return FFrameWidth
	End Function
	
	#ifndef __USE_GTK__
		Private Sub Animate.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QAnimate(Sender.Child)
					SetClassLongPtr(.Handle, GCLP_HBRBACKGROUND, 0)
					If .FOpen Then .Open
					If .FPlay Then .Play
				End With
			End If
		End Sub
		
		Private Sub Animate.WndProc(ByRef Message As Message)
			If Message.Sender Then
			End If
		End Sub
	#endif
		
	Private Sub Animate.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case ACN_START
					If OnStart Then OnStart(This)
				Case ACN_STOP
					If OnStop Then OnStop(This)
				End Select
			Case WM_NCHITTEST
				Message.Result = HTCLIENT
			Case WM_ERASEBKGND
				Dim As ..Rect R
				GetClientRect Handle, @R
				FillRect Cast(HDC, Message.wParam),@R, Brush.Handle
				Message.Result = -1
			Case WM_NCPAINT
				Dim As HDC Dc
				Dc = GetDCEx(Handle, 0, DCX_WINDOW Or DCX_CACHE Or DCX_CLIPSIBLINGS)
				'Future utilisation
				ReleaseDC Handle,Dc
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Sub Animate.Open
		#ifdef __USE_GTK__
			If OnOpen Then OnOpen(This)
			If FAutoPlay Then
				Play
			Else
'				If pixbuf_animation <> 0 Then
'					gtk_image_set_from_pixbuf(gtk_image(widget), gdk_pixbuf_animation_get_static_image(pixbuf_animation))
'				End If
			End If
		#else
			If Handle Then
				If OnOpen Then OnOpen(This)
				If CommonAVI = 0 Then
					If *FFile <> "" Then
						If FindResource(GetModuleHandle(NULL), *FFile, "AVI") Then
							GetAnimateInfo
							Animate_Open(FHandle, CInt(MakeIntResource(*FFile)))
							FOpen = 1
						Else
							GetAnimateInfo
							If Perform(ACM_OPENW, 0, CInt(FFile)) = 0 Then
								If pGraph = 0 Then
									Dim As WString Ptr wFile
									WLet wFile, Replace(*FFile, "/", "\")
									If StartsWith(*wFile, "./") OrElse StartsWith(*wFile, ".\") Then
										WLetEx wFile, ExePath & Mid(*wFile, 2), True
									End If
									Error_HR(CoInitialize(0), "CoInitialize")
									Error_HR(CoCreateInstance(@CLSID_FilterGraph, NULL, CLSCTX_INPROC_SERVER, @IID_IGraphBuilder, @pGraph), "CoCreateInstance")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IMediaControl, @pControl  ), "IMediaControl")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IMediaEvent  , @pEvent    ), "IMediaEvent")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IVideoWindow , @vidwindow ), "IVideoWindow")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IMediaSeeking, @medseek   ), "IMediaSeeking")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IBasicVideo  , @basvideo  ), "IBasicVideo")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IBasicAudio  , @basAudio  ), "IBasicAudio")
									IGraphBuilder_RenderFile(pGraph, wFile, NULL)
									IVideoWindow_put_Owner(vidwindow, Cast(OAHWND, This.Handle))
									IVideoWindow_put_WindowStyle(vidwindow, WS_CHILD Or WS_CLIPSIBLINGS Or WS_CLIPCHILDREN)
									IBasicVideo_get_SourceWidth(basvideo, @FFrameWidth)
									IBasicVideo_get_SourceHeight(basvideo, @FFrameHeight)
									If FAutoSize Then
										This.Width = FFrameWidth
										This.Height = FFrameHeight
									End If
									If FCenter Then
										IVideoWindow_SetWindowPosition(vidwindow, (This.Width - FFrameWidth) / 2, (This.Height - FFrameHeight) / 2, FFrameWidth, FFrameHeight)
									Else
										IVideoWindow_SetWindowPosition(vidwindow, 0, 0, FFrameWidth, FFrameHeight)
									End If
									WDeallocate wFile
									If FAutoPlay Then Play
								End If
							End If
							FOpen = 1
						End If
					End If
				ElseIf CommonAVI <> 0 Then
					If FindResource(GetModuleHandle("Shell32"), MakeIntResource(FCommonAvi), "AVI") Then
						GetAnimateInfo
						Perform(ACM_OPEN, CInt(GetModuleHandle("Shell32")), CInt(MakeIntResource(FCommonAvi)))
						FOpen = 1
					End If
				End If
			End If
		#endif
	End Sub

	Private Function Animate.IsPlaying As Boolean
		#ifdef __USE_GTK__
			Return FPlay
		#else
			If pControl Then
				Return FPlay
			Else
				Return Perform(ACM_ISPLAYING, 0, 0)
			End If
		#endif
	End Function
	
	Private Sub Animate.Play
		#ifdef __USE_GTK__
			If pixbuf_animation <> 0 Then
				Dim As GTimeVal gTime
				g_get_current_time(@gTime)
				
				iter = gdk_pixbuf_animation_get_iter(pixbuf_animation, @gTime)
				If OnStart Then OnStart(This)
				FPlay = True
				Timer_cb(@This)
			End If
		#else
			If Handle Then
				If pControl <> 0 Then
					If OnStart Then OnStart(This)
					Error_HR(IMediaControl_Run(pControl), "Metod IMediaControl_Run")
				Else
					Perform(ACM_PLAY, FRepeat, MakeLong(FStartFrame, FStopFrame))
				End If
				FPlay = True
			End If
		#endif
	End Sub
	
	Private Sub Animate.Stop
		#ifdef __USE_GTK__
			If OnStop Then OnStop(This)
			FPlay = False
		#else
			If Handle Then
				If pControl Then
					If OnStop Then OnStop(This)
					Error_HR(IMediaControl_Pause(pControl), "Metod IMediaControl_Pause")
				Else
					Perform(ACM_STOP, 0, 0)
				End If
				FPlay = False
			End If
		#endif
	End Sub
	
	Private Sub Animate.Close
		#ifdef __USE_GTK__
			If OnClose Then OnClose(This)
			FOpen = 0
			FPlay = False
		#else
			If Handle Then
				If OnClose Then OnClose(This)
				If pControl Then
					Dim As LongInt rtNow
					Dim As LongInt rtStop
					Dim As LongInt rtbegin
					Error_HR(IMediaSeeking_GetPositions(medseek, @rtNow, @rtStop), "Not put begin positions")
					Error_HR(IMediaSeeking_SetPositions(medseek, @rtbegin, AM_SEEKING_AbsolutePositioning, @rtStop , AM_SEEKING_AbsolutePositioning), "Not set begin positions")
					Error_HR(IMediaControl_Stop(pControl), "Metod IMediaControl_Stop")
				Else
					Perform(ACM_OPEN, 0, 0)
				End If
				FOpen = 0
				FPlay = False
			End If
		#endif
	End Sub
	
	Private Operator Animate.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Function Animate.Timer_cb(ByVal user_data As gpointer) As gboolean
			Dim As Animate Ptr anim = user_data
			If anim->FPlay Then
				Dim As GTimeVal gTime
				g_get_current_time(@gTime)
				gdk_pixbuf_animation_iter_advance(anim->iter, @gTime)
				g_timeout_add(gdk_pixbuf_animation_iter_get_delay_time(anim->iter), Cast(GSourceFunc, @Timer_cb), user_data)
				gtk_widget_queue_draw(anim->widget)
			End If
			Return False
		End Function
		
		Private Function Animate.DesignDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As Animate Ptr anim = data1
			#ifdef __USE_GTK3__
				Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
			#else
				Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
			#endif
			If anim->FDesignMode Then
				cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
				Dim As Double Ptr dashed = Allocate(SizeOf(Double) * 2)
				dashed[0] = 3.0
				dashed[1] = 3.0
				Dim As Integer len1 = SizeOf(dashed) / SizeOf(dashed[0])
				cairo_set_dash(cr, dashed, len1, 1)
				cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
				cairo_stroke(cr)
			End If
			If anim->pixbuf_animation <> 0 Then
				cairo_set_operator (cr, CAIRO_OPERATOR_SOURCE)
				
				Dim As GdkPixbuf Ptr pixbuf
				
				Dim As Integer imgw, imgh
				imgw = gdk_pixbuf_animation_get_width(anim->pixbuf_animation)
				imgh = gdk_pixbuf_animation_get_height(anim->pixbuf_animation)
					
				If anim->AutoSize Then
					If AllocatedWidth <> imgw OrElse AllocatedHeight <> imgh Then
						gtk_widget_set_size_request(anim->eventboxwidget, imgw, imgh)
					End If
				End If
				
				pixbuf = gdk_pixbuf_animation_iter_get_pixbuf(anim->iter)
				If anim->Center Then
					gdk_cairo_set_source_pixbuf(cr, pixbuf, (AllocatedWidth - imgw) / 2, (AllocatedHeight - imgh) / 2)
				Else
					gdk_cairo_set_source_pixbuf(cr, pixbuf, 0, 0)
				End If
				cairo_paint(cr)
			End If
			
			Return False
		End Function
		
		Private Function Animate.DesignExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			DesignDraw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Private Sub Animate.Screen_Changed(widget As GtkWidget Ptr, old_screen As GdkScreen Ptr, userdata As gpointer)
			Dim As Animate Ptr anim = userdata
			/' To check If the display supports Alpha channels, Get the colormap '/
			Dim As GdkScreen Ptr pScreen = gtk_widget_get_screen(widget)
			#ifdef __USE_GTK3__
				Dim As GdkVisual Ptr VisualOrColormap = gdk_screen_get_rgba_visual(pScreen)
			#else
				Dim As GdkColormap Ptr VisualOrColormap = gdk_screen_get_rgba_colormap(pScreen)
			#endif
			If (VisualOrColormap <> 0) Then
				Print "Your screen does not support alpha channels!"
				#ifdef __USE_GTK3__
					'VisualOrColormap = gdk_screen_get_rgb_visual(pScreen)
				#else
					VisualOrColormap = gdk_screen_get_rgb_colormap(pScreen)
				#endif
				anim->SupportsAlpha = False
			Else
				'Print "Your screen supports alpha channels!"
				anim->SupportsAlpha = True
			End If
			/' Now we have a colormap appropriate for the screen, use it '/
			#ifdef __USE_GTK3__
				'If VisualOrColormap <> 0 Then
					gtk_widget_set_visual(widget, VisualOrColormap)
				'End If
			#else
				gtk_widget_set_colormap(widget, VisualOrColormap)
			#endif
		End Sub
	#else
		Private Function Animate.Error_HR(ByVal hr As Integer, ByRef Inter_face As USTRING) As Integer
			If (FAILED(hr)) Then
				Var MB = MessageBox(0, "Error associated with " & *Inter_face.vptr & ". Want Continue?", "Error", MB_YESNO)
				If MB = IDNO Then
					End
				EndIf
			Else Return 1
			End If
		End Function
	#endif
	
	Private Constructor Animate
		Dim As Boolean Result
		#ifdef __USE_GTK__
			widget = gtk_image_new()
			eventboxwidget = gtk_event_box_new()
			gtk_container_add(gtk_container(eventboxwidget), widget)
			gtk_widget_set_app_paintable(widget, True)
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@DesignDraw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@DesignExposeEvent), @This)
				#endif
			#endif
			g_signal_connect(G_OBJECT(widget), "screen-changed", G_CALLBACK(@Screen_Changed), @This)
			This.RegisterClass "Animate", @This
		#else
			Dim As INITCOMMONCONTROLSEX ICC
			FFile = 0 'CAllocate_(0)
			ICC.dwSize = SizeOf(ICC)
			ICC.dwICC  = ICC_ANIMATE_CLASS
			Result = InitCommonControlsEx(@ICC)
			If Not Result Then InitCommonControls
			ACenter(0)      = 0
			ACenter(1)      = ACS_CENTER
			ATransparent(0) = 0
			ATransparent(1) = ACS_TRANSPARENT
			ATimer(0)       = 0
			ATimer(1)       = ACS_TIMER
			AAutoplay(0)    = 0
			AAutoplay(1)    = ACS_AUTOPLAY
		#endif
		FRepeat         = -1
		FStopFrame      = -1
		FStartFrame     = 0
		FTransparent    = True
		With This
			WLet(FClassName, "Animate")
			.Child             = @This
			#ifndef __USE_GTK__
				.RegisterClass "Animate", ANIMATE_CLASS
				.ChildProc         = @WndProc
				WLet(FClassAncestor, ANIMATE_CLASS)
				.ExStyle           = WS_EX_TRANSPARENT
				.Style             = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
				.BackColor             = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			.Width             = 100
			.Height            = 80
		End With
	End Constructor
	
	Private Destructor Animate
		If FFile Then Deallocate_( FFile)
		#ifndef __USE_GTK__
			If pGraph Then
				IMediaControl_Release(pControl)
				IMediaEvent_Release  (pEvent)    
				IVideoWindow_Release (vidwindow)
				IMediaSeeking_Release(medseek)
				IBasicVideo_Release  (basvideo)
				IBasicAudio_Release  (basAudio)
				IGraphBuilder_Release(pGraph)
				CoUninitialize()
			EndIf
		#endif
	End Destructor
End Namespace
