﻿'################################################################################
'#  CanvasDraw.frm                                                              #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

#ifdef __FB_WIN32__
	#cmdline "CanvasDraw.rc"
#endif
'#Region "Form"
	#include once "mff/Form.bi"
	#include once "mff/Label.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Picture.bi"
	#include once "mff/Textbox.bi"
	#include once "mff/Pen.bi"
	#include once "mff/ListControl.bi"
	#include once "mff/Panel.bi"
	#include once "mff/NumericUpDown.bi"
	Using My.Sys.Forms
	Using My.Sys.Drawing
	
	Dim Shared As Integer cmdSelection
	Dim Shared As Point Ms                  ' 记录鼠标按下时的坐标
	Type Form1Type Extends Form
		Declare Static Sub _cmdDrawButterfly_Click(ByRef Sender As Control)
		Declare Sub cmdDrawButterfly_Click(ByRef Sender As Control)
		Declare Static Sub _PictureBK_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub PictureBK_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Static Sub _Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Static Sub _cmdGDIDraw_Click(ByRef Sender As Control)
		Declare Sub cmdGDIDraw_Click(ByRef Sender As Control)
		Declare Static Sub _cmdGDICls_Click(ByRef Sender As Control)
		Declare Sub cmdGDICls_Click(ByRef Sender As Control)
		Declare Static Sub _CommandButton2_Click(ByRef Sender As Control)
		Declare Sub CommandButton2_Click(ByRef Sender As Control)
		Declare Static Sub _cmdGDIDraw1_Click(ByRef Sender As Control)
		Declare Sub cmdGDIDraw1_Click(ByRef Sender As Control)
		Declare Static Sub _Form_Click(ByRef Sender As Control)
		Declare Sub Form_Click(ByRef Sender As Control)
		Declare Static Sub _PictureBK_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub PictureBK_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Static Sub _Panel1_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Panel1_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Panel1_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Panel1_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Panel1_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub Panel1_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Static Sub _Panel1_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub Panel1_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Static Sub _Panel1_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub Panel1_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Static Sub _Panel1_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Panel1_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Panel1_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Panel1_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Picture2_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub Picture2_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Static Sub _Picture2_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub Picture2_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Static Sub _Picture2_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Picture2_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Picture2_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Picture2_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Picture2_Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub Picture2_Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Static Sub _Picture2_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub Picture2_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Static Sub _Picture2_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Picture2_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Picture2_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Picture2_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Form_Show(ByRef Sender As Form)
		Declare Sub Form_Show(ByRef Sender As Form)
		Declare Static Sub _PictureBK_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub PictureBK_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _PictureBK_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub PictureBK_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _PictureBK_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub PictureBK_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Static Sub _Form_Create(ByRef Sender As Control)
		Declare Sub Form_Create(ByRef Sender As Control)
		Declare Constructor
		
		Dim As CommandButton cmdDrawButterfly, cmdGDIDraw, cmdGDICls
		Dim As Picture PictureBK, Picture2_Picture(1), Picture2_Form(1)
		
		Dim As NumericUpDown Text1(1), Text2(1), Text3(1), Text4(1), Text5(1)
		Dim As Panel Panel1_Picture(1), Panel1_Form(1)
		Dim As TextBox txtControlName
	End Type
	
	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.OnResize = @_Form_Resize
			.OnClick = @_Form_Click
			.OnShow = @_Form_Show
			.OnCreate = @_Form_Create
			.SetBounds 0, 0, 370, 300
		End With
		' cmdDrawButterfly
		With cmdDrawButterfly
			.Name = "cmdDrawButterfly"
			.Text = "Start Draw"  '"开始绘画"
			.TabIndex = 1
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asNone
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asNone
			.SetBounds 13, 230, 71, 30
			.Designer = @This
			.OnClick = @_cmdDrawButterfly_Click
			.Parent = @This
		End With
		' PictureBK
		With PictureBK
			.Name = "PictureBK"
			.Text = "PictureBK"
			.TabIndex = 1
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.BackColor = 128
			.Transparent = True
			.CenterImage = True
			'.StretchImage= StretchMode.smStretchProportional
			.StretchImage= StretchMode.smStretch
			'.Graphic.Bitmap.LoadFromFile(ExePath & "/Wheel.png")
			.SetBounds 22, 56, 260, 160
			.Designer = @This
			.OnPaint = @_PictureBK_Paint
			.OnResize = @_PictureBK_Resize
			.OnMouseMove = @_PictureBK_MouseMove
			.OnMouseDown = @_PictureBK_MouseDown
			.OnMouseUp = @_PictureBK_MouseUp
			.Parent = @This
		End With
		' Text1(0)
		With Text1(0)
			.Name = "Text1(0)"
			.Text = "1"
			.TabIndex = 2
			.SetBounds 20, 0, 40, 20
			.Parent = @This
		End With
		' Text2(0)
		With Text2(0)
			.Name = "Text2(0)"
			.Text = "2"
			.TabIndex = 3
			.SetBounds 80, 0, 40, 20
			.Parent = @This
		End With
		' Text3(0)
		With Text3(0)
			.Name = "Text3(0)"
			.Text = "4"
			.TabIndex = 4
			.SetBounds 150, 0, 40, 20
			.Parent = @This
		End With
		' Text4(0)
		With Text4(0)
			.Name = "Text4(0)"
			.Text = "12"
			.TabIndex = 5
			.SetBounds 210, 0, 40, 20
			.Parent = @This
		End With
		' Text5(0)
		With Text5(0)
			.Name = "Text5(0)"
			.Text = "5"
			.TabIndex = 6
			.SetBounds 260, 0, 40, 20
			.Parent = @This
		End With
		' Text1(1)
		With Text1(1)
			.Name = "Text1(1)"
			.Text = "1"
			.TabIndex = 7
			.SetBounds 20, 30, 40, 20
			.Parent = @This
		End With
		' Text2(1)
		With Text2(1)
			.Name = "Text2(1)"
			.Text = "2"
			.TabIndex = 8
			.SetBounds 80, 30, 40, 20
			.Parent = @This
		End With
		' Text3(1)
		With Text3(1)
			.Name = "Text3(1)"
			.Text = "4"
			.TabIndex = 9
			.SetBounds 150, 30, 40, 20
			.Parent = @This
		End With
		' Text4(1)
		With Text4(1)
			.Name = "Text4(1)"
			.Text = "12"
			.TabIndex = 10
			.SetBounds 210, 30, 40, 20
			.Parent = @This
		End With
		' Text5(1)
		With Text5(1)
			.Name = "Text5(1)"
			.Text = "5"
			.TabIndex = 11
			.SetBounds 260, 30, 40, 20
			.Parent = @This
		End With
		' txtControlName
		With txtControlName
			.Name = "txtControlName"
			.Text = ""
			.TabIndex = 12
			.SetBounds 300, 0, 100, 20
			.Designer = @This
			.Parent = @This
		End With
		' cmdGDIDraw
		With cmdGDIDraw
			.Name = "cmdGDIDraw"
			.Text = "Scale"
			.TabIndex = 25
			.Anchor.Top = AnchorStyle.asNone
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asNone
			.Anchor.Left = AnchorStyle.asAnchor
			.SetBounds 86, 231, 79, 30
			.Designer = @This
			.OnClick = @_cmdGDIDraw_Click
			.Parent = @This
		End With
		' cmdGDICls
		With cmdGDICls
			.Name = "cmdGDICls"
			.Text = "Cls"
			.TabIndex = 13
			.Caption = "Cls"
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.SetBounds 170, 232, 79, 30
			.Designer = @This
			.OnClick = @_cmdGDICls_Click
			.Parent = @This
		End With
		' Panel1_Picture(0)
		With Panel1_Picture(0)
			.Name = "Panel1_Picture(0)"
			.Text = "Panel1"
			.TabIndex = 14
			.BackColor = 33023
			.Transparent = True
			.Graphic.Bitmap.LoadFromFile(ExePath & "/wheel.png")
			.Anchor.Top = AnchorStyle.asAnchorProportional
			.Anchor.Right = AnchorStyle.asNone
			.Anchor.Left = AnchorStyle.asAnchorProportional
			.SetBounds 98, 34, 35, 35
			.Designer = @This
			.OnPaint = @_Panel1_Picture_Paint
			.OnResize = @_Panel1_Picture_Resize
			.OnMouseDown = @_Panel1_Picture_MouseDown
			.OnMouseMove = @_Panel1_Picture_MouseMove
			.Parent = @PictureBK
		End With
		' Panel1_Picture(1)
		With Panel1_Picture(1)
			.Name = "Panel1_Picture(1)"
			.Text = "Panel1_Picture(1)"
			.TabIndex = 21
			.BackColor = 33023
			.ControlIndex = 0
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 98, 84, 35, 35
			.OnPaint = @_Panel1_Picture_Paint
			.OnResize = @_Panel1_Picture_Resize
			.OnMouseDown = @_Panel1_Picture_MouseDown
			.OnMouseMove = @_Panel1_Picture_MouseMove
			.Designer = @This
			.Parent = @PictureBK
		End With
		' Picture2_Picture(0)
		With Picture2_Picture(0)
			.Name = "Picture2_Picture(0)"
			.Text = "Picture2"
			.TabIndex = 15
			.BackColor = 12615808
			.Transparent = True
			.Graphic.Bitmap.LoadFromFile(ExePath & "/wheel.png")
			.Anchor.Top = AnchorStyle.asAnchorProportional
			.Anchor.Right = AnchorStyle.asNone
			.Anchor.Left = AnchorStyle.asAnchorProportional
			.Anchor.Bottom = AnchorStyle.asNone
			.SetBounds 148, 34, 35, 35
			.Designer = @This
			.OnResize = @_Picture2_Picture_Resize
			.OnPaint = @_Picture2_Picture_Paint
			.OnMouseMove = @_Picture2_Picture_MouseMove
			.OnMouseDown = @_Picture2_Picture_MouseDown
			.Parent = @PictureBK
		End With
			' Picture2_Picture(1)
		With Picture2_Picture(1)
			.Name = "Picture2_Picture(1)"
			.Text = "Picture2_Picture(1)"
			.TabIndex = 20
			.BackColor = 12615808
			.ControlIndex = 1
			.Anchor.Top = AnchorStyle.asAnchorProportional
			.Anchor.Right = AnchorStyle.asNone
			.Anchor.Left = AnchorStyle.asAnchorProportional
			.Anchor.Bottom = AnchorStyle.asNone
			.SetBounds 148, 84, 35, 35
			.OnResize = @_Picture2_Picture_Resize
			.OnPaint = @_Picture2_Picture_Paint
			.OnMouseMove = @_Picture2_Picture_MouseMove
			.OnMouseDown = @_Picture2_Picture_MouseDown
			.Designer = @This
			.Parent = @PictureBK
		End With
		
		' Panel1_Form(0)
		With Panel1_Form(0)
			.Name = "Panel1_Form(0)"
			.Text = "Panel1_Form(0)"
			.TabIndex = 16
			.ControlIndex = 0
			.BackColor = 65280
			.Transparent = True
			.Graphic.Bitmap.LoadFromFile(ExePath & "/wheel.png")
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 298, 54, 45, 45
			.Designer = @This
			.OnMouseDown = @_Panel1_Form_MouseDown
			.OnMouseMove = @_Panel1_Form_MouseMove
			.OnPaint = @_Panel1_Form_Paint
			.Parent = @This
		End With
		' Picture2_Form(0)
		With Picture2_Form(0)
			.Name = "Picture2_Form(0)"
			.Text = "Picture2"
			.TabIndex = 17
			.ControlIndex = 1
			.BackColor = 32768
			.Transparent = True
			.Graphic.Bitmap.LoadFromFile(ExePath & "/wheel.png")
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 298, 104, 45, 45
			.Designer = @This
			.OnResize = @_Picture2_Form_Resize
			.OnPaint = @_Picture2_Form_Paint
			.OnMouseDown = @_Picture2_Form_MouseDown
			.OnMouseMove = @_Picture2_Form_MouseMove
			.Parent = @This
		End With
		' Picture2_Form(1)
		With Picture2_Form(1)
			.Name = "Picture2_Form(1)"
			.Text = "Picture2_Form(1)"
			.TabIndex = 18
			.BackColor = 32768
			.ControlIndex = 15
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 298, 204, 45, 45
			.OnResize = @_Picture2_Form_Resize
			.OnPaint = @_Picture2_Form_Paint
			.OnMouseDown = @_Picture2_Form_MouseDown
			.OnMouseMove = @_Picture2_Form_MouseMove
			.Designer = @This
			.Parent = @This
		End With
		' Panel1_Form(1)
		With Panel1_Form(1)
			.Name = "Panel1_Form(1)"
			.Text = "Panel1_Form(1)"
			.TabIndex = 19
			.BackColor = 65280
			.ControlIndex = 14
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 298, 154, 45, 45
			.OnMouseDown = @_Panel1_Form_MouseDown
			.OnMouseMove = @_Panel1_Form_MouseMove
			.OnPaint = @_Panel1_Form_Paint
			.Designer = @This
			.Parent = @This
		End With
	End Constructor
	
	Private Sub Form1Type._Form_Create(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).Form_Create(Sender)
	End Sub
	
	Private Sub Form1Type._PictureBK_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).PictureBK_MouseUp(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._PictureBK_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).PictureBK_MouseDown(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._PictureBK_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).PictureBK_MouseMove(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Form_Show(ByRef Sender As Form)
		(*Cast(Form1Type Ptr, Sender.Designer)).Form_Show(Sender)
	End Sub
	
	Private Sub Form1Type._Picture2_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Form_MouseMove(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Picture2_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Form_MouseDown(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Picture2_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Form_Paint(Sender, Canvas)
	End Sub
	
	Private Sub Form1Type._Picture2_Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Form_Resize(Sender, NewWidth, NewHeight)
	End Sub
	
	Private Sub Form1Type._Picture2_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Picture_MouseDown(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Picture2_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Picture_MouseMove(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Picture2_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Picture_Paint(Sender, Canvas)
	End Sub
	
	Private Sub Form1Type._Picture2_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Picture2_Picture_Resize(Sender, NewWidth, NewHeight)
	End Sub
	
	Private Sub Form1Type._Panel1_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Panel1_Picture_MouseMove(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Panel1_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Panel1_Picture_MouseDown(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Panel1_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Panel1_Picture_Resize(Sender, NewWidth, NewHeight)
	End Sub
	
	Private Sub Form1Type._Panel1_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		(*Cast(Form1Type Ptr, Sender.Designer)).Panel1_Picture_Paint(Sender, Canvas)
	End Sub
	
	Private Sub Form1Type._Panel1_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		(*Cast(Form1Type Ptr, Sender.Designer)).Panel1_Form_Paint(Sender, Canvas)
	End Sub
	
	Private Sub Form1Type._Panel1_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Panel1_Form_MouseMove(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._Panel1_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Panel1_Form_MouseDown(Sender, MouseButton, x, y, Shift)
	End Sub
	
	Private Sub Form1Type._PictureBK_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).PictureBK_Resize(Sender, NewWidth, NewHeight)
	End Sub
	
	Private Sub Form1Type._PictureBK_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		(*Cast(Form1Type Ptr, Sender.Designer)).PictureBK_Paint(Sender, Canvas)
	End Sub
	Private Sub Form1Type._Form_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).Form_Click(Sender)
	End Sub
	
	Private Sub Form1Type._CommandButton2_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).CommandButton2_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdGDICls_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdGDICls_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdGDIDraw_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdGDIDraw_Click(Sender)
	End Sub
	
	Private Sub Form1Type._Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Form_Resize(Sender, NewWidth, NewHeight)
	End Sub
	
	Private Sub Form1Type._cmdDrawButterfly_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdDrawButterfly_Click(Sender)
	End Sub
	
	Dim Shared Form1 As Form1Type
	
	#ifndef _NOT_AUTORUN_FORMS_
		App.DarkMode= True
		#define _NOT_AUTORUN_FORMS_
		Form1.Show
		App.Run
	#endif
'#End Region

Private Sub Form1Type.cmdDrawButterfly_Click(ByRef Sender As Control)
	Dim As Double A(1), B(1), C(1), D(1), E(1), X, Y
	Dim T As Double = Timer
	cmdSelection = 0
	' Coordination  坐标系统
	cmdDrawButterfly.Caption = "Waiting......Drawing"  '"稍等，正在绘画"     '"Waiting......Drawing" '
	'PictureBK.Style = PictureStyle.ssOwnerDraw
	Picture2_Picture(0).Visible= False 
	Panel1_Picture(0).Visible= False 
	Picture2_Picture(1).Visible= False 
	Panel1_Picture(1).Visible= False 
	PictureBK.Transparent = True 
	With PictureBK.Canvas
		.CreateDoubleBuffer
		.Scale(-10, -10, 10, 10)
		.Pen.Color = clGreen
		.Pen.Size = 2
		.Pen.Style = 3 'PenStyle.psDashDot
		'.Pen.Mode = PenMode.pmMerge
		' draw across  画十字线条
		'.FillMode = BrushFillMode.bmOpaque
		'.Brush.Style = BrushStyles.bsSolid
		'.Rectangle -10 , -10 , 10 , 10
		'.Line -10 , -10 , 10 , 10, clblue, "BF"
		.Line -10 , 0 , 10 , 00
		.Line 0 , -10 , 0 , 10
		.TextOut 10 , 0, "1", clGreen , -1
		.TextOut 10, 20 - 2, "2", clGreen , -1
		.TextOut 00 , 10, "3", clGreen , -1
		.TextOut 20 - 3 , 1000, "4", clGreen , -1
		.TextOut 1 , 1, "0", clGreen , -1
		
		' drawing arrow  化箭头
		'    .Line 0 , 1000 , -125 , 950
		'    .Line 0 , 1000 , 125 , 950
		'    .Line 1000 , 0 , 950 , 125
		'    .Line 1000 , 0 , 950 , -125
		'
		A(0) = Val(Text1(0).Text): A(1) = Val(Text1(1).Text)
		B(0) = Val(Text2(0).Text): B(1) = Val(Text2(1).Text)
		C(0) = Val(Text3(0).Text): C(1) = Val(Text3(1).Text)
		D(0) = Val(Text4(0).Text): D(1) = Val(Text4(1).Text)
		E(0) = Val(Text5(0).Text): E(1) = Val(Text5(1).Text)
		'
		If A(0) < 1 Then A(0) = 1: If A(1) < 1 Then A(1) = 1
		If D(0) < 1 Then D(0) = 1: If D(1) < 1 Then D(1) = 1
		If E(0) < 1 Then E(0) = 1: If E(1) < 1 Then E(1) = 1
		
		For i As Long = -72000 To 72000 'Step  0.1
			X = (Sin(i * A(0)) * (Exp(Cos(i)) - B(0) * Cos(C(0) * i) - Sin(i / D(0)) ^ E(0)))
			Y = (Cos(i * A(1)) * (Exp(Cos(i)) - B(1) * Cos(C(1) * i) - Sin(i / D(1)) ^ E(1)))
			.SetPixel X, Y, clRed
			'.TextOut 20, 20, Str(i), clYellow, -1
		Next
		.TextOut - 9, -9, "Elapsed Time: " & Timer - T & "ms", clGreen , -1 '"用时 " & GetTickCount - t & "毫秒", clGreen , -1
		.TransferDoubleBuffer
	End With
	Picture2_Picture(0).Visible= True
	Panel1_Picture(0).Visible= True
	Picture2_Picture(1).Visible= True
	Panel1_Picture(1).Visible= True
	Picture2_Picture(0).BringToFront
	Panel1_Picture(0).BringToFront
	Picture2_Picture(1).BringToFront
	Panel1_Picture(1).BringToFront
	PictureBK.SendToBack
	cmdDrawButterfly.Caption = "Start Draw" '"开始绘画"    '"Start Draw"
End Sub

Private Sub Form1Type.PictureBK_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	'If cmdSelection = 1 Then cmdGDIDraw_Click(Sender) Else cmdDrawButterfly_Click(Sender)
End Sub

Private Sub Form1Type.Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	'cmdDrawButterfly_Click(Sender)
	'Debug.Print "NewWidth=" & NewWidth & " NewHeight=" & NewHeight
	PictureBK.Repaint
	Picture2_Picture(0).Repaint
	Panel1_Picture(0).Repaint
	Picture2_Form(0).Repaint
	Panel1_Form(0).Repaint
	
	Picture2_Picture(1).Repaint
	Panel1_Picture(1).Repaint
	Picture2_Form(1).Repaint
	Panel1_Form(1).Repaint
End Sub

Sub Taijitu(x As Integer, y As Integer, r As Integer)
	'With PictureBK.Canvas
	'	.Circle x, y, 2 * r, 0, , , , F
	'	.Line x, y - 2 * r, x, y + 2 * r, 7, B
	'	.Paint x - r, y, 15, 7
	'	.Circle x, y - r, r - 1, 15, , , , F
	'	.Circle x, y + r, r - 1,  0, , , , F
	'	.Circle x, y - r, r / 3,  0, , , , F
	'	.Circle x, y + r, r / 3, 15, , , , F
	'End With
End Sub

Private Sub Form1Type.cmdGDIDraw_Click(ByRef Sender As Control)
	cmdSelection = 1
	Picture2_Picture(0).Visible= False 
	Panel1_Picture(0).Visible= False 
	Picture2_Picture(1).Visible= False 
	Panel1_Picture(1).Visible= False 
	With PictureBK.Canvas
		.CreateDoubleBuffer(True, True)
		.Scale(-100, 100, 100, -100)
		.Pen.Color = clGreen
		.Pen.Size = 2
		.Pen.Style = 3 'PenStyle.psDashDot
		'Print PictureBK.BackColor
		.FillMode = BrushFillMode.bmTransparent
		.Line (-100, 0, 100, 0) '画X轴
		.Line (0, 100, 0, -100) '画Y轴
		
		.Brush.Style = BrushStyles.bsSolid
		.Circle (0, 0, 5) '绘制红色圆心
		.Brush.Style = BrushStyles.bsClear
		
		.TextOut 0,  0, "(0,0)" , clGreen, -1 '原点坐标
		.TextOut 90, 10, "X", clGreen, -1    '标记X轴
		.TextOut 5, 95,  "Y", clGreen, -1     '标记Y轴
		
		For i As Integer = 10 To 50 Step 4
			.SetPixel(i, 10, clRed) '绘制像素点
		Next
		
		'绘制不同模式的直线
		.DrawWidth = 1 '设置画笔宽度
		.Pen.Style = PenStyle.psSolid
		.Line(-10, -10, -100, -10)
		
		.Pen.Style = PenStyle.psDash
		.Line(-10, -20, -100, -20)
		
		.Pen.Style = PenStyle.psDashDot
		.Line -10, -30, -100, -30
		
		.Pen.Style = PenStyle.psDashDotDot
		.Line -10, -40, -100, -40
		
		.Brush.Style = BrushStyles.bsSolid
		.Line 40, 20, 80, 40, , "F"
		.Line 140, 70, 80, 90, clBlue, "F"
		
		.DrawWidth = 2 '设置画笔宽度
		.Pen.Style = 0
		'绘制弧线、弦割线、饼图
		.Arc(30, 50, 70, 80, 70, 60, 30, 60)
		.Chord(10, 60, 40, 80, 40, 60, 10, 70)
		.Pie(20, 70, 40, 50, 60, 80, 40, 60)
		
		Dim As Point pt(4) = {(-60, + 20), (-90, + 110), (-10, 0), (-30, 70)}
		'{{90, 130}, {60, 40}, {140, 150}, {160, 80}}
		'//绘制椭圆、矩形
		.Ellipse(pt(0).X, pt(0).Y, pt(1).X, pt(0).Y)
		.Rectangle(pt(2).X, pt(2).Y, pt(3).X, pt(3).Y)
		
		'绘制贝塞尔曲线
		.Pen.Color = clRed
		.DrawWidth = 2  'DrawWidth
		'.PolyBeizer(pt(), 4)
		'标出贝塞尔曲线的四个锚点
		.Circle(pt(0).X, pt(0).Y, 4)
		.Circle(pt(1).X, pt(1).Y, 4)
		.Circle(pt(2).X, pt(2).Y, 4)
		.Circle(pt(3).X, pt(3).Y, 4)
		
		'绘制圆
		.Circle(50, 40, 30, clYellow)
		
		'绘制不同填充模式的矩形
		.Pen.Size = 1
		.Pen.Color = clGreen
		.Brush.Color = clRed
		.Brush.Style = BrushStyles.bsClear
		.FillColor = clBlue
		.Rectangle(20, -20, 60, -30) ' HS_BDIAGONAL, RGB(255, 0, 0))
		.Brush.Color = clRed
		.Brush.Style = BrushStyles.bsHatch
		.Brush.HatchStyle = HatchStyles.hsCross
		.Rectangle(20, -40, 60, -50) ' HS_CROSS, RGB(0, 255, 0));
		.Pen.Color = clGreen
		.FillColor = clYellow
		.Brush.HatchStyle = HatchStyles.hsDiagCross
		.FillColor = clYellow
		.Rectangle(20, -60, 60, -70) ' HS_DIAGCROSS, RGB(0, 0, 255))
		.Pen.Color = clYellow
		.Brush.HatchStyle = HatchStyles.hsVertical
		.FillColor = clGray
		.Rectangle(20, -80, 60, -90) ' HS_VERTICAL, RGB(0, 0, 0))
		
		'Draw Image   绘制位图
		'StretchDraw(10, 140, 180, 100, TEXT("chenggong.bmp"))
		Taijitu(110, 110, 45)
		Taijitu(500, 300, 138)
		
		'绘制文本
		'TextOut(20, 220, TEXT("GDI画图输出测试程序"), 11);
		.TransferDoubleBuffer
	End With
	Picture2_Picture(0).Visible= True
	Panel1_Picture(0).Visible= True
	Picture2_Picture(1).Visible= True
	Panel1_Picture(1).Visible= True
End Sub

Private Sub Form1Type.cmdGDICls_Click(ByRef Sender As Control)
	With PictureBK.Canvas
		.Cls(50, -20, 60, -40)
		Sleep(300)
		.Cls
	End With
End Sub


Private Sub Form1Type.Form_Click(ByRef Sender As Control)
	
End Sub

Private Sub Form1Type.PictureBK_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	RedrawWindow Sender.Handle, 0, 0, RDW_INVALIDATE Or RDW_ALLCHILDREN
End Sub

Private Sub Form1Type.Panel1_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	Ms.X = x
	Ms.Y = y
	txtControlName.Text = Sender.Name
End Sub

Private Sub Form1Type.Panel1_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	If MouseButton = 0 Then Sender.Location = Type<My.Sys.Drawing.Point>(Sender.Left + x - Ms.X, Sender.Top + y - Ms.Y) : Sender.Repaint
End Sub

Private Sub Form1Type.Panel1_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub

Private Sub Form1Type.Panel1_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub

Private Sub Form1Type.Panel1_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub

Private Sub Form1Type.Panel1_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	Ms.X = x
	Ms.Y = y
	txtControlName.Text = Sender.Name
End Sub

Private Sub Form1Type.Panel1_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	If MouseButton = 0 Then Sender.Location = Type<My.Sys.Drawing.Point>(Sender.Left + x - Ms.X, Sender.Top + y - Ms.Y) : Sender.Repaint
End Sub

Private Sub Form1Type.Picture2_Picture_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub

Private Sub Form1Type.Picture2_Picture_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub

Private Sub Form1Type.Picture2_Picture_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
If MouseButton = 0 Then Sender.Location = Type<My.Sys.Drawing.Point>(Sender.Left + x - Ms.X, Sender.Top + y - Ms.Y) : Sender.Repaint
End Sub

Private Sub Form1Type.Picture2_Picture_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	Ms.X = x
	Ms.Y = y
	txtControlName.Text = Sender.Name
End Sub
Private Sub Form1Type.Picture2_Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub

Private Sub Form1Type.Picture2_Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub

Private Sub Form1Type.Picture2_Form_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	Ms.X = x
	Ms.Y = y
	txtControlName.Text = Sender.Name
End Sub

Private Sub Form1Type.Picture2_Form_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	If MouseButton = 0 Then Sender.Location = Type<My.Sys.Drawing.Point>(Sender.Left + x - Ms.X, Sender.Top + y - Ms.Y) : Sender.Repaint
End Sub

Private Sub Form1Type.Form_Show(ByRef Sender As Form)
	
	PictureBK.Graphic.Bitmap.LoadFromFile("BackGround.png")
End Sub

Private Sub Form1Type.PictureBK_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	'If MouseButton = 0 Then Sender.Location = Type<My.Sys.Drawing.Point>(Sender.Left + x - Ms.X, Sender.Top + y - Ms.Y) : Sender.Repaint
End Sub

Private Sub Form1Type.PictureBK_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Ms.X = x
	Ms.Y = y
	txtControlName.Text = Sender.Name
End Sub

Private Sub Form1Type.PictureBK_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	
End Sub

Private Sub Form1Type.Form_Create(ByRef Sender As Control)
'	Dim As Rect R
	'GetClientRect GetDesktopWindow(), @R
	'If R.Right < 10 Then R = Type<Rect>(0, 0, 1920, 1080)
	'This.Graphic.Bitmap.LoadFromScreen(R.Left, R.Top, R.Right, R.Bottom)
End Sub
