﻿'###############################################################################
'#  Grid.bi                                                                    #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "Grid.bi"
#ifdef __USE_WINAPI__
	#include once "win\tmschema.bi"
#endif

Namespace My.Sys.Forms
	Private Function GridRow.Index As Integer
		If Parent Then
			Return Cast(Grid Ptr, Parent)->Rows.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Private Sub GridCell.SelectItem
		With *Cast(Grid Ptr, Parent)
			.SelectedColumn = Column
			.SelectedRow = Row
		End With
	End Sub
	
	Private Sub GridRow.SelectItem
		#ifdef __USE_GTK__
			If Parent Then
				If gtk_tree_view_get_selection(GTK_TREE_VIEW(Parent->Handle)) Then
					gtk_tree_selection_select_iter(gtk_tree_view_get_selection(GTK_TREE_VIEW(Parent->Handle)), @TreeIter)
				End If
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Dim lvi As LVITEM
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.state    = LVIS_SELECTED Or LVIS_FOCUSED
				lvi.stateMask = LVIF_STATE
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Sub
	
	#ifndef GridRow_Item_Off
		Private Function GridRow.Item(ColumnIndex As Integer) As GridCell Ptr
			Dim ic As Integer = FColumns.Count
			Dim cc As Integer = Cast(Grid Ptr, Parent)->Columns.Count
			If ic < cc Then
				For i As Integer = ic + 1 To cc
					FColumns.Add ""
				Next i
			End If
			If ColumnIndex < FColumns.Count Then
				Dim As GridCell Ptr Cell = FColumns.Object(ColumnIndex)
				If Cell = 0 Then
					Cell = New_(GridCell)
					Cell->Column = Cast(Grid Ptr, Parent)->Columns.Column(ColumnIndex)
					Cell->Row = Cast(Grid Ptr, Parent)->Rows.Item(Index)
					Cell->Parent = Parent
				End If
				Return Cell
			Else
				Return 0
			End If
		End Function
	#endif
	
	Private Property GridCell.Text ByRef As WString
		Return Row->Text(Column->Index)
	End Property
	
	Private Property GridCell.Text(ByRef Value As WString)
		Row->Text(Column->Index) = Value
	End Property
	
	Private Property GridRow.Text(iColumn As Integer) ByRef As WString
		#ifdef __USE_GTK__
			If FColumns.Count > iColumn Then
				Return FColumns.Item(iColumn)
			Else
				Return WStr("")
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				WReAllocate(FText, 255)
				lvi.mask = LVIF_TEXT
				lvi.iItem = Index
				lvi.iSubItem   = iColumn
				lvi.pszText    = FText
				lvi.cchTextMax = 255
				ListView_GetItem(Parent->Handle, @lvi)
				FColumns.Item(iColumn) = *FText
				Return FColumns.Item(iColumn)
			Else
				If FColumns.Count > iColumn Then
					Return FColumns.Item(iColumn)
				Else
					Return WStr("")
				End If
			End If
		#endif
	End Property
	
	#ifdef __USE_GTK__
		Private Function GridGetModel(widget As GtkWidget Ptr) As GtkTreeModel Ptr
			If GTK_IS_WIDGET(widget) Then
				Return gtk_tree_view_get_model(GTK_TREE_VIEW(widget))
			End If
		End Function
	#endif
	
	Private Property GridRow.Text(iColumn As Integer, ByRef Value As WString)
		WLet(FText, Value)
		If Parent Then
			Dim ic As Integer = FColumns.Count
			Dim cc As Integer = Cast(Grid Ptr, Parent)->Columns.Count
			If ic < cc Then
				For i As Integer = ic + 1 To cc
					FColumns.Add ""
				Next i
			End If
			If iColumn < cc Then FColumns.Item(iColumn) = Value
			#ifdef __USE_GTK__
				If GridGetModel(Parent->Handle) Then
					gtk_list_store_set(GTK_LIST_STORE(GridGetModel(Parent->Handle)), @TreeIter, iColumn + 3, ToUtf8(Value), -1)
				End If
			#else
				If Parent->Handle Then
					lvi.mask = LVIF_TEXT
					lvi.iItem = Index
					lvi.iSubItem   = iColumn
					lvi.pszText    = FText
					lvi.cchTextMax = Len(*FText)
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
		End If
	End Property
	
	Private Property GridRow.State As Integer
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FState = lvi.state
			End If
		#endif
		Return FState
	End Property
	
	#ifndef GridRow_State_Set_Off
		Private Property GridRow.State(Value As Integer)
			FState = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					lvi.mask = LVIF_STATE
					lvi.iItem = Index
					lvi.iSubItem   = 0
					lvi.state    = Value
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
		End Property
	#endif
	
	Private Property GridRow.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property GridRow.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	
	Private Property GridRow.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	#ifndef GridRow_ImageIndex_Set_Off
		Private Property GridRow.ImageIndex(Value As Integer)
			If Value <> FImageIndex Then
				FImageIndex = Value
				#ifndef __USE_GTK__
					If Parent AndAlso Parent->Handle Then
						lvi.mask = LVIF_IMAGE
						lvi.iItem = Index
						lvi.iSubItem   = 0
						lvi.iImage     = Value
						ListView_SetItem(Parent->Handle, @lvi)
					End If
				#endif
			End If
		End Property
	#endif
	
	Private Property GridRow.Indent As Integer
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_INDENT
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FIndent = lvi.iIndent
			End If
		#endif
		Return FIndent
	End Property
	
	#ifndef GridRow_Indent_Set_Off
		Private Property GridRow.Indent(Value As Integer)
			FIndent = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					lvi.mask = LVIF_INDENT
					lvi.iItem = Index
					lvi.iSubItem   = 0
					lvi.iIndent    = Value
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
		End Property
	#endif
	
	Private Property GridRow.SelectedImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property GridRow.SelectedImageIndex(Value As Integer)
		If Value <> FSelectedImageIndex Then
			FSelectedImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property GridRow.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	#ifndef GridRow_ImageKey_Set_Off
		Private Property GridRow.ImageKey(ByRef Value As WString)
			'If Value <> *FImageKey Then
			WLet(FImageKey, Value)
			#ifdef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim As GError Ptr gerr
					If Value <> "" Then
						gtk_list_store_set(GTK_LIST_STORE(GridGetModel(Parent->Handle)), @TreeIter, 1, gtk_icon_theme_load_icon(gtk_icon_theme_get_default(), ToUtf8(Value), 16, GTK_ICON_LOOKUP_USE_BUILTIN, @gerr), -1)
						gtk_list_store_set(GTK_LIST_STORE(GridGetModel(Parent->Handle)), @TreeIter, 2, ToUtf8(Value), -1)
					End If
				End If
			#else
				If Parent AndAlso Parent->Handle AndAlso Cast(Grid Ptr, Parent)->Images Then
					FImageIndex = Cast(Grid Ptr, Parent)->Images->IndexOf(Value)
					lvi.mask = LVIF_IMAGE
					lvi.iItem = Index
					lvi.iSubItem   = 0
					lvi.iImage     = FImageIndex
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
			'End If
		End Property
	#endif
	
	Private Property GridRow.SelectedImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property GridRow.SelectedImageKey(ByRef Value As WString)
		'If Value <> *FSelectedImageKey Then
		WLet(FSelectedImageKey, Value)
		If Parent Then
			With QControl(Parent)
				'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
			End With
		End If
		'End If
	End Property
	
	Private Property GridRow.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property GridRow.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
				End With
			End If
		End If
	End Property
	
	Private Operator GridRow.[](ColumnIndex As Integer) ByRef As GridCell
		Return *Item(ColumnIndex)
	End Operator
	
	Private Operator GridRow.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridRow
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		FVisible    = 1
		Text(0)    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
		FSmallImageIndex = -1
	End Constructor
	
	Private Destructor GridRow
		For i As Integer = 0 To FColumns.Count - 1
			If FColumns.Object(i) <> 0 Then Delete_(Cast(GridCell Ptr, FColumns.Object(i)))
		Next
		If FHint Then Deallocate_( FHint)
		If FText Then Deallocate_( FText)
	End Destructor
	
	Private Sub GridColumn.SelectItem
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
		#endif
	End Sub
	
	Private Property GridColumn.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Private Property GridColumn.Text(ByRef Value As WString)
		WLet(FText, Value)
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = TVIF_TEXT
				lvc.iSubItem = Index
				lvc.pszText = FText
				lvc.cchTextMax = Len(*FText)
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Property
	
	Private Property GridColumn.Width As Integer
		#ifdef __USE_GTK__
			If This.Column Then FWidth = gtk_tree_view_column_get_width(This.Column)
		#else
			Dim lvc As LVCOLUMN
			lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
			lvc.iSubItem = Index
			If Parent AndAlso Parent->Handle AndAlso ListView_GetColumn(Parent->Handle, Index, @lvc) Then
				FWidth = UnScaleX(lvc.cx)
			End If
		#endif
		Return FWidth
	End Property
	
	#ifndef GridColumn_Width_Set_Off
		Private Property GridColumn.Width(Value As Integer)
			FWidth = Value
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(-1, Value))
				#else
					If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(1, Value))
				#endif
			#else
				If Parent AndAlso Parent->Handle Then
					Dim lvc As LVCOLUMN
					lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
					lvc.iSubItem = Index
					ListView_SetColumn(Parent->Handle, Index, @lvc)
				End If
			#endif
		End Property
	#endif
	
	Private Property GridColumn.Format As GridColumnFormat
		Return FFormat
	End Property
	
	#ifndef GridColumn_Format_Set_Off
		Private Property GridColumn.Format(Value As GridColumnFormat)
			FFormat = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim lvc As LVCOLUMN
					lvc.mask = LVCF_FMT Or LVCF_SUBITEM
					lvc.iSubItem = Index
					lvc.fmt = Value
					ListView_SetColumn(Parent->Handle, Index, @lvc)
				End If
			#endif
		End Property
	#endif
	
	Private Property GridColumn.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property GridColumn.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	Private Property GridColumn.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	#ifndef GridColumn_ImageIndex_Set_Off
		Private Property GridColumn.ImageIndex(Value As Integer)
			If Value <> FImageIndex Then
				FImageIndex = Value
				If Parent Then
					With QControl(Parent)
						'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
					End With
				End If
			End If
		End Property
	#endif
	
	Private Property GridColumn.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property GridColumn.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
				End With
			End If
		End If
	End Property
	
	Private Property GridColumn.Editable As Boolean
		Return FEditable
	End Property
	
	Private Property GridColumn.Editable(Value As Boolean)
		If Value <> FEditable Then
			FEditable = Value
		End If
	End Property
	
	Private Operator GridColumn.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridColumn
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		FVisible    = 1
		Text    = ""
		Hint       = ""
		FImageIndex = -1
	End Constructor
	
	Private Destructor GridColumn
		If FHint Then Deallocate_( FHint)
		If FText Then Deallocate_( FText)
	End Destructor
	
	Private Property GridRows.Count As Integer
		Return FItems.Count
	End Property
	
	Private Property GridRows.Count(Value As Integer)
	End Property
	
	Private Property GridRows.Item(Index As Integer) As GridRow Ptr
		If Index >= 0 AndAlso Index < FItems.Count Then
			Return FItems.Items[Index]
		End If
	End Property
	
	Private Property GridRows.Item(Index As Integer, Value As GridRow Ptr)
		If Index >= 0 AndAlso Index < FItems.Count Then
			FItems.Items[Index] = Value
		End If
	End Property
	
	#ifdef __USE_GTK__
		Private Function GridRows.FindByIterUser_Data(User_Data As Any Ptr) As GridRow Ptr
			For i As Integer = 0 To Count - 1
				If Item(i)->TreeIter.user_data = User_Data Then Return Item(i)
			Next i
			Return 0
		End Function
	#endif
	
	#ifndef GridRows_Add_Integer_Off
		Private Function GridRows.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As GridRow Ptr
			PItem = New_(GridRow)
			Dim i As Integer = Index
			Dim As GridSortStyle iSortStyle = Cast(Grid Ptr, Parent)->Sort
			If iSortStyle <> GridSortStyle.ssNone Then
				For i = 0 To FItems.Count - 1
					If iSortStyle = GridSortStyle.ssSortAscending Then
						If Cast(GridRow Ptr, FItems.Item(i))->Text(0) > FCaption Then Exit For
					Else
						If Cast(GridRow Ptr, FItems.Item(i))->Text(0) < FCaption Then Exit For
					End If
				Next
				FItems.Insert i, PItem
			ElseIf Index = -1 Then
				FItems.Add PItem
			Else
				FItems.Insert i, PItem
			End If
			With *PItem
				.ImageIndex     = FImageIndex
				.Text(0)        = FCaption
				.State        = State
				.Indent        = Indent
			End With
			#ifdef __USE_GTK__
				Cast(Grid Ptr, Parent)->Init
				If iSortStyle <> GridSortStyle.ssNone OrElse Index <> -1 Then
					gtk_list_store_insert(GTK_LIST_STORE(GridGetModel(Parent->Handle)), @PItem->TreeIter, i)
				Else
					gtk_list_store_append(GTK_LIST_STORE(GridGetModel(Parent->Handle)), @PItem->TreeIter)
				End If
				gtk_list_store_set (GTK_LIST_STORE(GridGetModel(Parent->Handle)), @PItem->TreeIter, 3, ToUtf8(FCaption), -1)
			#else
				lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
				lvi.pszText  = @FCaption
				lvi.cchTextMax = Len(FCaption)
				lvi.iItem = IIf(Index = -1, FItems.Count - 1, Index)
				lvi.iSubItem = 0
				lvi.iImage   = FImageIndex
				lvi.state   = INDEXTOSTATEIMAGEMASK(State)
				lvi.stateMask = LVIS_STATEIMAGEMASK
				lvi.iIndent   = Indent
				lvi.lParam    = Cast(LPARAM, PItem)
			#endif
			If Parent Then
				PItem->Parent = Parent
				PItem->Text(0) = FCaption
				#ifndef __USE_GTK__
					If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
				#endif
			End If
			Return PItem
		End Function
	#endif
	
	Private Function GridRows.Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As GridRow Ptr
		If Parent AndAlso Cast(Grid Ptr, Parent)->Images Then
			PItem = Add(FCaption, Cast(Grid Ptr, Parent)->Images->IndexOf(FImageKey), State, Indent, Index)
		Else
			PItem = Add(FCaption, -1, State, Indent, Index)
		End If
		If PItem Then PItem->ImageKey = FImageKey
		Return PItem
	End Function
	
	Private Function GridRows.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As GridRow Ptr
		Dim As GridRow Ptr PItem
		#ifndef __USE_GTK__
			Dim As LVITEM lvi
		#endif
		PItem = New_(GridRow)
		FItems.Insert Index, PItem
		With *PItem
			.ImageIndex     = FImageIndex
			.Text(0)        = FCaption
			.State          = State
			.Indent         = Indent
		End With
		#ifndef __USE_GTK__
			lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
			lvi.pszText  = @FCaption
			lvi.cchTextMax = Len(FCaption)
			lvi.iItem = Index
			lvi.iImage   = FImageIndex
			lvi.state   = INDEXTOSTATEIMAGEMASK(State)
			lvi.stateMask = LVIS_STATEIMAGEMASK
			lvi.iIndent   = Indent
			lvi.lParam    = Cast(LPARAM, PItem)
			If Parent Then
				PItem->Parent = Parent
				If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
			End If
		#endif
		Return PItem
	End Function
	
	Private Sub GridRows.Remove(Index As Integer)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_list_store_remove(GTK_LIST_STORE(GridGetModel(Parent->Handle)), @This.Item(Index)->TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				ListView_DeleteItem(Parent->Handle, Index)
			End If
		#endif
		FItems.Remove Index
	End Sub
	
	#ifndef __USE_GTK__
		#ifndef GridRows_CompareFunc_Off
			Private Function GridRows.CompareFunc(ByVal lParam1 As LPARAM, ByVal lParam2 As LPARAM, ByVal lParamSort As LPARAM) As Long
				Dim As GridRow Ptr FirstItem = Cast(GridRow Ptr, lParam1), SecondItem = Cast(GridRow Ptr, lParam2)
				If FirstItem <> 0 AndAlso SecondItem <> 0 Then
					Select Case FirstItem->Text(0)
					Case Is < SecondItem->Text(0): Return -1
					Case Is > SecondItem->Text(0): Return 1
					Case Else: Return 0
					End Select
				End If
				Return 0
			End Function
		#endif
	#endif
	
	Private Sub GridRows.Sort
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				SendMessage Parent->Handle, LVM_SORTITEMS, 0, Cast(WPARAM, @CompareFunc)
				'ListView_SortItems Parent->Handle, @CompareFunc, 0
			End If
		#endif
	End Sub
	
	Private Function GridRows.IndexOf(ByRef FItem As GridRow Ptr) As Integer
		Return FItems.IndexOf(FItem)
	End Function
	
	Private Sub GridRows.Clear
		#ifdef __USE_GTK__
			If Parent AndAlso GTK_LIST_STORE(GridGetModel(Parent->Handle)) Then gtk_list_store_clear(GTK_LIST_STORE(GridGetModel(Parent->Handle)))
		#else
			If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, LVM_DELETEALLITEMS, 0, 0
		#endif
		For i As Integer = Count -1 To 0 Step -1
			Delete_( @QGridRow(FItems.Items[i]))
		Next i
		FItems.Clear
	End Sub
	
	Private Operator GridRows.[](Index As Integer) ByRef As GridRow
		Return *Item(Index)
	End Operator
	
	Private Operator GridRows.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridRows
		This.Clear
	End Constructor
	
	Private Destructor GridRows
		This.Clear
	End Destructor
	
	Private Property GridColumns.Count As Integer
		Return FColumns.Count
	End Property
	
	Private Property GridColumns.Count(Value As Integer)
	End Property
	
	Private Property GridColumns.Column(Index As Integer) As GridColumn Ptr
		Return QGridColumn(FColumns.Items[Index])
	End Property
	
	Private Property GridColumns.Column(Index As Integer, Value As GridColumn Ptr)
		FColumns.Items[Index] = Value
	End Property
	
	#ifdef __USE_GTK__
		Private Sub GridColumns.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As GridColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As Grid Ptr lv = Cast(Grid Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			If lv->OnCellEdited Then lv->OnCellEdited(*lv, Val(*path), PColumn->Index, *new_text)
		End Sub
		
		Private Sub GridColumns.Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, user_data As Any Ptr)
			Dim As Grid Ptr lv = user_data
			Dim As GtkListStore Ptr model = GTK_LIST_STORE(GridGetModel(lv->Handle))
			Dim As GtkTreeIter iter
			Dim As gboolean active
			
			active = gtk_cell_renderer_toggle_get_active (cell)
			
			gtk_tree_model_get_iter_from_string (GTK_TREE_MODEL (model), @iter, path)
			
			If (active) Then
				'gtk_cell_renderer_set_alignment(GTK_CELL_RENDERER(cell), 0, 0)
				gtk_list_store_set (GTK_LIST_STORE (model), @iter, 0, False, -1)
			Else
				'gtk_cell_renderer_set_alignment(GTK_CELL_RENDERER(cell), 0.5, 0.5)
				gtk_list_store_set (GTK_LIST_STORE (model), @iter, 0, True, -1)
			End If
		End Sub
	#endif
	
	Private Function GridColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer, Format As GridColumnFormat = gcfLeft, ColEditable As Boolean = False) As GridColumn Ptr
		Dim As GridColumn Ptr PColumn
		Dim As Integer Index
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
		#endif
		PColumn = New_(GridColumn)
		FColumns.Add PColumn
		Index = FColumns.Count - 1
		With *PColumn
			.ImageIndex     = FImageIndex
			.Text        = FCaption
			.Index = Index
			.Width     = iWidth
			.Format = Format
		End With
		#ifdef __USE_GTK__
			If Parent Then
				PColumn->Column = gtk_tree_view_column_new()
				gtk_tree_view_column_set_reorderable(PColumn->Column, Cast(Grid Ptr, Parent)->AllowColumnReorder)
				Dim As GtkCellRenderer Ptr rendertext = gtk_cell_renderer_text_new()
				If ColEditable Then
					Dim As GValue bValue '= G_VALUE_INIT
					g_value_init_(@bValue, G_TYPE_BOOLEAN)
					g_value_set_boolean(@bValue, True)
					g_object_set_property(G_OBJECT(rendertext), "editable", @bValue)
					g_value_unset(@bValue)
					'Dim bTrue As gboolean = True
					'g_object_set(rendertext, "mode", GTK_CELL_RENDERER_MODE_EDITABLE, NULL)
					'g_object_set(gtk_cell_renderer_text(rendertext), "editable-set", true, NULL)
					'g_object_set(rendertext, "editable", bTrue, NULL)
				End If
				If Index = 0 Then
					Dim As GtkCellRenderer Ptr renderpixbuf = gtk_cell_renderer_pixbuf_new()
					gtk_tree_view_column_pack_start(PColumn->Column, renderpixbuf, False)
					gtk_tree_view_column_add_attribute(PColumn->Column, renderpixbuf, ToUtf8("icon_name"), 2)
				End If
				g_signal_connect(G_OBJECT(rendertext), "edited", G_CALLBACK (@Cell_Edited), PColumn)
				gtk_tree_view_column_pack_start(PColumn->Column, rendertext, True)
				gtk_tree_view_column_add_attribute(PColumn->Column, rendertext, ToUtf8("text"), Index + 3)
				gtk_tree_view_column_set_resizable(PColumn->Column, True)
				gtk_tree_view_column_set_title(PColumn->Column, ToUtf8(FCaption))
				If GTK_IS_TREE_VIEW(Parent->Handle) Then
					gtk_tree_view_append_column(GTK_TREE_VIEW(Parent->Handle), PColumn->Column)
				Else
					gtk_tree_view_append_column(GTK_TREE_VIEW(g_object_get_data(G_OBJECT(Parent->Handle), "@@@TreeView")), PColumn->Column)
				End If
				#ifdef __USE_GTK3__
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(-1, iWidth))
				#else
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(1, iWidth))
				#endif
			End If
		#else
			lvc.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
			lvc.fmt       =  Format
			lvc.cx		  = ScaleX(IIf(iWidth = -1, 50, iWidth))
			lvc.iImage   = PColumn->ImageIndex
			lvc.iSubItem = PColumn->Index
			lvc.pszText  = @FCaption
			lvc.cchTextMax = Len(FCaption)
		#endif
		If Parent Then
			PColumn->Parent = Parent
			#ifdef __USE_GTK__
				
			#else
				If Parent->Handle Then
					ListView_InsertColumn(Parent->Handle, PColumn->Index, @lvc)
				End If
			#endif
		End If
		Return PColumn
	End Function
	
	Private Sub GridColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer, Format As GridColumnFormat = gcfLeft)
		Dim As GridColumn Ptr PColumn
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
			PColumn = New_( GridColumn)
			FColumns.Insert Index, PColumn
			With *PColumn
				.ImageIndex     = FImageIndex
				.Text        = FCaption
				.Index        = FColumns.Count - 1
				.Width     = iWidth
				.Format = Format
			End With
			lvc.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
			lvc.fmt       =  Format
			lvc.cx=0
			lvc.iImage   = PColumn->ImageIndex
			lvc.iSubItem = PColumn->Index
			lvc.pszText  = @FCaption
			lvc.cchTextMax = Len(FCaption)
			If Parent Then
				PColumn->Parent = Parent
				If Parent->Handle Then
					ListView_InsertColumn(Parent->Handle, Index, @lvc)
					ListView_SetColumnWidth(Parent->Handle, Index, iWidth)
				End If
			End If
		#endif
	End Sub
	
	Private Sub GridColumns.Remove(Index As Integer)
		FColumns.Remove Index
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				SendMessage Parent->Handle, LVM_DELETECOLUMN, Cast(WPARAM, Index), 0
			End If
		#endif
	End Sub
	
	Private Function GridColumns.IndexOf(ByRef FColumn As GridColumn Ptr) As Integer
		Return FColumns.IndexOf(FColumn)
	End Function
	
	Private Sub GridColumns.Clear
		For i As Integer = Count -1 To 0 Step -1
			Delete_( @QGridColumn(FColumns.Items[i]))
			Remove i
		Next i
		FColumns.Clear
	End Sub
	
	Private Operator GridColumns.[](Index As Integer) ByRef As GridColumn
		Return *Column(Index)
	End Operator
	
	Private Operator GridColumns.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridColumns
		This.Clear
	End Constructor
	
	Private Destructor GridColumns
		This.Clear
	End Destructor
	
	#ifndef ReadProperty_Off
		Private Function Grid.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "allowcolumnreorder": Return @FAllowColumnReorder
			Case "columnheaderhidden": Return @FColumnHeaderHidden
			Case "fullrowselect": Return @FFullRowSelect
			Case "hovertime": Return @FHoverTime
			Case "gridlines": Return @FGridLines
			Case "images": Return Images
			Case "stateimages": Return StateImages
			Case "smallimages": Return SmallImages
			Case "singleclickactivate": Return @FSingleClickActivate
			Case "sort": Return @FSortStyle
			Case "tabindex": Return @FTabIndex
			Case "hoverselection": Return @FHoverSelection
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Grid.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "allowcolumnreorder": AllowColumnReorder = QBoolean(Value)
				Case "columnheaderhidden": ColumnHeaderHidden = QBoolean(Value)
				Case "fullrowselect": FullRowSelect = QBoolean(Value)
				Case "hovertime": HoverTime = QInteger(Value)
				Case "gridlines": GridLines = QBoolean(Value)
				Case "images": Images = Cast(ImageList Ptr, Value)
				Case "stateimages": StateImages = Cast(ImageList Ptr, Value)
				Case "smallimages": SmallImages = Cast(ImageList Ptr, Value)
				Case "singleclickactivate": SingleClickActivate = QBoolean(Value)
				Case "sort": Sort = *Cast(GridSortStyle Ptr, Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "hoverselection": HoverSelection = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property Grid.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property Grid.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property Grid.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property Grid.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Sub Grid.Init()
		#ifdef __USE_GTK__
			If gtk_tree_view_get_model(GTK_TREE_VIEW(widget)) = NULL Then
				With This
					If .ColumnTypes Then Delete_SquareBrackets( .ColumnTypes)
					.ColumnTypes = New_(GType[Columns.Count + 4])
					.ColumnTypes[0] = G_TYPE_BOOLEAN
					.ColumnTypes[1] = GDK_TYPE_PIXBUF
					.ColumnTypes[2] = G_TYPE_STRING
					For i As Integer = 3 To Columns.Count + 3
						.ColumnTypes[i] = G_TYPE_STRING
					Next i
				End With
				gtk_list_store_set_column_types(ListStore, Columns.Count + 3, ColumnTypes)
				gtk_tree_view_set_model(GTK_TREE_VIEW(widget), GTK_TREE_MODEL(ListStore))
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			End If
		#else
			FCol = 0: FRow = 0
			Columns.Clear
			GridEditText.Visible= False
		#endif
	End Sub
	
	Private Property Grid.ColumnHeaderHidden As Boolean
		Return FColumnHeaderHidden
	End Property
	
	Private Property Grid.ColumnHeaderHidden(Value As Boolean)
		FColumnHeaderHidden = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), Not Value)
		#else
			ChangeStyle LVS_NOCOLUMNHEADER, Value
		#endif
	End Property
	
	Private Function Grid.Cell(RowIndex As Integer, ColumnIndex As Integer) As GridCell Ptr
		Return Rows.Item(RowIndex)->Item(ColumnIndex)
	End Function
	
	#ifndef Grid_ChangeLVExStyle_Off
		Private Sub Grid.ChangeLVExStyle(iStyle As Integer, Value As Boolean)
			#ifndef __USE_GTK__
				If FHandle Then FLVExStyle = SendMessage(FHandle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
				If Value Then
					If ((FLVExStyle And iStyle) <> iStyle) Then FLVExStyle = FLVExStyle Or iStyle
				ElseIf ((FLVExStyle And iStyle) = iStyle) Then
					FLVExStyle = FLVExStyle And Not iStyle
				End If
				If FHandle Then SendMessage(FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal FLVExStyle)
			#endif
		End Sub
	#endif
	
	Private Property Grid.SingleClickActivate As Boolean
		Return FSingleClickActivate
	End Property
	
	Private Property Grid.SingleClickActivate(Value As Boolean)
		FSingleClickActivate = Value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				gtk_tree_view_set_activate_on_single_click(GTK_TREE_VIEW(widget), Value)
			#else
				
			#endif
		#else
			ChangeLVExStyle LVS_EX_ONECLICKACTIVATE, Value
		#endif
	End Property
	
	Private Property Grid.HoverSelection As Boolean
		Return FHoverSelection
	End Property
	
	Private Property Grid.HoverSelection(Value As Boolean)
		FHoverSelection = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_hover_selection(GTK_TREE_VIEW(widget), Value)
		#else
			ChangeLVExStyle LVS_EX_TRACKSELECT, Value
		#endif
	End Property
	
	Private Property Grid.HoverTime As Integer
		Return FHoverTime
	End Property
	
	Private Property Grid.HoverTime(Value As Integer)
		FHoverTime = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(LVM_SETHOVERTIME, 0, Value)
		#endif
	End Property
	
	Private Property Grid.AllowEdit As Boolean
		Return FAllowEdit
	End Property
	
	Private Property Grid.AllowEdit(Value As Boolean)
		FAllowEdit = Value
	End Property
	Private Property Grid.AllowColumnReorder As Boolean
		Return FAllowColumnReorder
	End Property
	
	Private Property Grid.AllowColumnReorder(Value As Boolean)
		FAllowColumnReorder = Value
		#ifdef __USE_GTK__
			For i As Integer = 0 To Columns.Count - 1
				gtk_tree_view_column_set_reorderable(Columns.Column(i)->Column, Value)
			Next
		#else
			ChangeLVExStyle LVS_EX_HEADERDRAGDROP, Value
		#endif
	End Property
	
	Private Property Grid.GridLines As Boolean
		Return FGridLines
	End Property
	
	Private Property Grid.GridLines(Value As Boolean)
		FGridLines = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), IIf(Value, GTK_TREE_VIEW_GRID_LINES_BOTH, GTK_TREE_VIEW_GRID_LINES_NONE))
		#else
			ChangeLVExStyle LVS_EX_GRIDLINES, Value
		#endif
	End Property
	
	Private Property Grid.FullRowSelect As Boolean
		Return FFullRowSelect
	End Property
	
	Private Property Grid.FullRowSelect(Value As Boolean)
		FFullRowSelect = Value
		#ifndef __USE_GTK__
			ChangeLVExStyle LVS_EX_FULLROWSELECT, Value
		#endif
	End Property
	
	Private Property Grid.SelectedRowIndex As Integer
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Dim As Integer i
				Dim As GtkTreePath Ptr path
				
				path = gtk_tree_model_get_path(GTK_TREE_MODEL(ListStore), @iter)
				i = gtk_tree_path_get_indices(path)[0]
				gtk_tree_path_free(path)
				'				Dim As ListViewItem Ptr lvi = ListItems.FindByIterUser_Data(iter.User_Data)
				'				If lvi <> 0 Then Return lvi->Index
				Return i
			End If
		#else
			If Handle Then
				Return ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
			End If
		#endif
		Return -1
	End Property
	
	Private Property Grid.SelectedRowIndex(Value As Integer)
		#ifdef __USE_GTK__
			If TreeSelection Then
				If Value = -1 Then
					gtk_tree_selection_unselect_all(TreeSelection)
				ElseIf Value > -1 AndAlso Value < Rows.Count Then
					Dim As GtkTreeIter iter
					gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Value)))
					gtk_tree_selection_select_iter(TreeSelection, @iter)
					gtk_tree_view_scroll_to_cell(GTK_TREE_VIEW(widget), gtk_tree_model_get_path(GTK_TREE_MODEL(ListStore), @iter), NULL, False, 0, 0)
				End If
			End If
		#else
			If Handle Then
				ListView_SetItemState(Handle, Value, LVIS_FOCUSED Or LVIS_SELECTED, LVNI_SELECTED Or LVNI_FOCUSED)
			End If
		#endif
	End Property
	
	Private Property Grid.SelectedRow As GridRow Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return Rows.FindByIterUser_Data(iter.user_data)
			End If
		#else
			If Handle Then
				Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
				If item <> -1 Then Return Rows.Item(item)
			End If
		#endif
		Return 0
	End Property
	
	#ifndef Grid_SelectedRow_Off
		Private Property Grid.SelectedRow(Value As GridRow Ptr)
			Value->SelectItem
		End Property
	#endif
	
	Private Property Grid.SelectedColumn As GridColumn Ptr
		Return Columns.Column(FCol)
	End Property
	
	#ifndef Grid_SelectedColumn_Off
		Private Property Grid.SelectedColumn(Value As GridColumn Ptr)
			FCol = Value->Index
		End Property
	#endif
	
	Private Property Grid.SelectedColumnIndex As Integer
		Return FCol
	End Property
	
	Private Property Grid.SelectedColumnIndex(Value As Integer)
		FCol = Value
	End Property
	
	Private Property Grid.Sort As GridSortStyle
		Return FSortStyle
	End Property
	
	Private Property Grid.Sort(Value As GridSortStyle)
		FSortStyle = Value
		#ifndef __USE_GTK__
			Select Case FSortStyle
			Case GridSortStyle.ssNone
				ChangeStyle LVS_SORTASCENDING, False
				ChangeStyle LVS_SORTDESCENDING, False
			Case GridSortStyle.ssSortAscending
				ChangeStyle LVS_SORTDESCENDING, False
				ChangeStyle LVS_SORTASCENDING, True
			Case GridSortStyle.ssSortDescending
				ChangeStyle LVS_SORTASCENDING, False
				ChangeStyle LVS_SORTDESCENDING, True
			End Select
		#endif
	End Property
	
	Private Property Grid.ShowHint As Boolean
		Return FShowHint
	End Property
	
	Private Property Grid.ShowHint(Value As Boolean)
		FShowHint = Value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub Grid.SetDark(Value As Boolean)
			Base.SetDark Value
			If Value Then
				hHeader = ListView_GetHeader(FHandle)
				SetWindowTheme(hHeader, "DarkMode_ItemsView", nullptr) ' DarkMode
				SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr) ' DarkMode
				AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
				AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
			Else
				hHeader = ListView_GetHeader(FHandle)
				SetWindowTheme(hHeader, NULL, NULL) ' DarkMode
				SetWindowTheme(FHandle, NULL, NULL) ' DarkMode
				AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
				AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
			End If
			'SendMessage FHandle, WM_THEMECHANGED, 0, 0
		End Sub
	#endif
	
	Private Sub Grid.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.Event
			Select Case Message.Event->type
			Case GDK_MAP
				Init
			Case GDK_BUTTON_RELEASE
				If SelectedRowIndex <> -1 Then
					If OnRowClick Then OnRowClick(This, SelectedRowIndex)
				End If
				#ifdef __USE_GTK3__
				Case GDK_2BUTTON_PRESS, GDK_DOUBLE_BUTTON_PRESS
				#else
				Case GDK_2BUTTON_PRESS
				#endif
				If SelectedRowIndex <> -1 Then
					If OnRowDblClick Then OnRowDblClick(This, SelectedRowIndex)
				End If
			Case GDK_KEY_PRESS
				If SelectedRowIndex <> -1 Then
					If OnRowKeyDown Then OnRowKeyDown(This, SelectedRowIndex, Message.Event->key.keyval, Message.Event->key.state)
				End If
			End Select
		#else
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case WM_DESTROY
				If Images Then ListView_SetImageList(FHandle, 0, LVSIL_NORMAL)
				If StateImages Then ListView_SetImageList(FHandle, 0, LVSIL_STATE)
				If SmallImages Then ListView_SetImageList(FHandle, 0, LVSIL_SMALL)
				If GroupHeaderImages Then ListView_SetImageList(FHandle, 0, LVSIL_GROUPHEADER)
			Case WM_SIZE
			Case WM_KEYUP
				Select Case Message.wParam
				Case VK_DOWN
					FRow += 1
					If FRow > Rows.Count - 1 Then FRow = Rows.Count - 1
					Repaint
				Case VK_UP
					FRow -= 1
					If FRow < 0 Then FRow = 0
					Repaint
				Case VK_HOME, VK_END, VK_NEXT, VK_PRIOR
					Dim As Integer tItemSelel = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
					If tItemSelel <> -1 Then GridEditText.Visible= False
					Repaint
				Case VK_SPACE
					If FSorting = False Then EditControlShow(FRow, FCol)
				Case VK_LEFT
					FCol -= 1
					If FCol < 0 Then FCol = Columns.Count - 1
					Repaint
				Case VK_RIGHT, VK_RETURN
					FCol += 1
					If FCol > Columns.Count - 1 Then FCol = 1
					GridEditText.Visible= False
					Repaint
				Case VK_ESCAPE
					GridEditText.Visible= False
					'Repaint
				End Select
			Case WM_LBUTTONDOWN
				Dim lvhti As LVHITTESTINFO
				lvhti.pt.X = Message.lParamLo
				lvhti.pt.Y = Message.lParamHi
				ListView_SubItemHitTest(Handle, @lvhti)
				If lvhti.iItem >= 0 Then
					FRow = lvhti.iItem
					FCol = lvhti.iSubItem
				End If
			'Case 78 'Adjust the width of columns
			'	GridEditText.Visible = False  
			Case WM_THEMECHANGED
				If (g_darkModeSupported) Then
					Dim As HWND hHeader = ListView_GetHeader(Message.hWnd)
					
					AllowDarkModeForWindow(Message.hWnd, g_darkModeEnabled)
					AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
					
					Dim As HTHEME hTheme '= OpenThemeData(nullptr, "ItemsView")
					'If (hTheme) Then
					'	Dim As COLORREF Color1
					'	If (SUCCEEDED(GetThemeColor(hTheme, 0, 0, TMT_TEXTCOLOR, @Color1))) Then
					If g_darkModeEnabled Then
						ListView_SetTextColor(Message.hWnd, darkTextColor) 'Color1)
					Else
						ListView_SetTextColor(Message.hWnd, Font.Color) 'Color1)
					End If
					'	End If
					'	If (SUCCEEDED(GetThemeColor(hTheme, 0, 0, TMT_FILLCOLOR, @Color1))) Then
					If g_darkModeEnabled Then
						ListView_SetTextBkColor(Message.hWnd, darkBkColor) 'Color1)
						ListView_SetBkColor(Message.hWnd, darkBkColor) 'Color1)
					Else
						ListView_SetTextBkColor(Message.hWnd, GetSysColor(COLOR_WINDOW)) 'Color1)
						ListView_SetBkColor(Message.hWnd, GetSysColor(COLOR_WINDOW)) 'Color1)
					End If
					'	End If
					'	CloseThemeData(hTheme)
					'End If
					
					hTheme = OpenThemeData(hHeader, "Header")
					If (hTheme) Then
						'Var info = reinterpret_cast<SubclassInfo*>(dwRefData);
						GetThemeColor(hTheme, HP_HEADERITEM, 0, TMT_TEXTCOLOR, @headerTextColor)
						CloseThemeData(hTheme)
					End If
					
					SendMessageW(hHeader, WM_THEMECHANGED, Message.wParam, Message.lParam)
					
					RedrawWindow(Message.hWnd, nullptr, nullptr, RDW_FRAME Or RDW_INVALIDATE)
				End If
			Case CM_NOTIFY
				Dim lvp As NMLISTVIEW Ptr = Cast(NMLISTVIEW Ptr, Message.lParam)
				Select Case lvp->hdr.code
				Case NM_CLICK
					If GridEditText.Visible= True Then Rows.Item(FRow)->Item(FCol) = GridEditText.Text
					If lvp->iItem >= 0 Then
						FCol = lvp->iSubItem
						FRow = lvp->iItem
						If OnRowClick Then OnRowClick(This, lvp->iItem)
						'Repaint
					End If
					GridEditText.Visible= False
				Case NM_DBLCLK
					If FSorting = False AndAlso lvp->iItem >= 0 Then
						If OnRowDblClick Then OnRowDblClick(This, lvp->iItem)
						EditControlShow(lvp->iItem, lvp->iSubItem)
					End If
				Case NM_KEYDOWN:
					Dim As LPNMKEY lpnmk = Cast(LPNMKEY, Message.lParam)
					If OnRowKeyDown Then OnRowKeyDown(This, lvp->iItem, lpnmk->nVKey, lpnmk->uFlags And &HFFFF)
				Case LVN_ITEMACTIVATE
					If OnRowActivate Then OnRowActivate(This, lvp->iItem)
				Case LVN_BEGINSCROLL
					GridEditText.Visible= False
					If OnBeginScroll Then OnBeginScroll(This)
				Case LVN_ENDSCROLL
					If OnEndScroll Then OnEndScroll(This)
				Case LVN_COLUMNCLICK
					GridEditText.Visible= False
					If OnColumnClick Then OnColumnClick(This, lvp->iSubItem)
				Case LVN_ITEMCHANGING
					GridEditText.Visible= False
					Dim bCancel As Boolean
					If OnSelectedRowChanging Then OnSelectedRowChanging(This, lvp->iItem, bCancel)
					If bCancel Then Message.Result = -1: Exit Sub
				Case LVN_ITEMCHANGED: If OnSelectedRowChanged Then OnSelectedRowChanged(This, lvp->iItem)
				Case HDN_BEGINTRACK
					GridEditText.Visible = False ' Force refesh windows
				Case HDN_ITEMCHANGED
					GridEditText.Visible = False
				Case NM_CUSTOMDRAW
					Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, Message.lParam)
					Select Case nmcd->dwDrawStage
					Case CDDS_PREPAINT
						Message.Result = CDRF_NOTIFYITEMDRAW Or CDRF_NOTIFYPOSTPAINT
						Return
					Case CDDS_ITEMPREPAINT
						SetBkMode nmcd->hdc, TRANSPARENT
						'FillRect nmcd->hdc, @nmcd->rc, hbrBkgnd
						Message.Result = CDRF_DODEFAULT
						Return
					Case CDDS_POSTPAINT
						Dim As ..Rect rc, rc_
						Dim As Integer SelectedItem = ListView_GetNextItem(nmcd->hdr.hwndFrom, -1, LVNI_SELECTED), frmt
						Dim zTxt As WString * 64
						Dim lvi As LVITEM
						For i As Integer = 0 To Columns.Count - 1
							ListView_GetSubItemRect(nmcd->hdr.hwndFrom, SelectedItem, i, LVIR_LABEL, @rc)
							lvi.mask = LVIF_TEXT
							lvi.iItem = SelectedItem
							lvi.iSubItem   = i
							lvi.pszText    = @zTxt
							lvi.cchTextMax = 64
							ListView_GetItem(nmcd->hdr.hwndFrom, @lvi)
							If i = FCol OrElse FFullRowSelect Then
								'FillRect nmcd->hdc, @rc, hbrBkgnd
								FillRect nmcd->hdc, @rc, GetSysColorBrush(COLOR_HIGHLIGHT)
								'SelectObject nmcd->hdc, GetSysColorBrush(COLOR_HIGHLIGHTTEXT)
								rc_.Left = rc.Left
								rc_.Top = rc.Top
								rc_.Right = rc.Right
								rc_.Bottom = rc.Bottom - 1
								If i > 0 Then rc_.Left += 1
								If i = FCol Then
									DrawFocusRect nmcd->hdc, @rc_ 'draw focus rectangle
								End If
							Else
								If g_darkModeEnabled Then
									FillRect nmcd->hdc, @rc, hbrBkgnd
								Else
									FillRect nmcd->hdc, @rc, GetSysColorBrush(COLOR_WINDOW)
								End If
							End If
							'SetBkMode nmcd->hdc, TRANSPARENT
							SetTextColor nmcd->hdc, darkTextColor
							If i = 0 Then
								rc.Left += 2
								rc.Top += 2
								rc.Right -= 6
							Else
								rc.Left += 6
								rc.Top += 2
								rc.Right -= 6
							End If
							If i <> 0 Then
								Select Case Columns.Column(i)->Format
								Case GridColumnFormat.gcfLeft: frmt = DT_LEFT
								Case GridColumnFormat.gcfCenter: frmt = DT_CENTER
								Case GridColumnFormat.gcfRight: frmt = DT_RIGHT
								End Select
							End If
							DrawText nmcd->hdc, @zTxt, Len(zTxt), @rc, DT_END_ELLIPSIS Or frmt 'Draw text
						Next i
						If g_darkModeEnabled Then
							Dim As HPEN GridLinesPen = CreatePen(PS_SOLID, 1, darkHlBkColor)
							Dim As HPEN PrevPen = SelectObject(nmcd->hdc, GridLinesPen)
							Dim As Integer Widths, Heights
							Dim As SCROLLINFO sif
							sif.cbSize = SizeOf(sif)
							sif.fMask  = SIF_POS
							GetScrollInfo(FHandle, SB_HORZ, @sif)
							Widths -= sif.nPos
							Dim lvc As LVCOLUMN
							For i As Integer = 0 To Columns.Count - 1
								lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
								lvc.iSubItem = i
								ListView_GetColumn(FHandle, i, @lvc)
								Widths += lvc.cx
								MoveToEx nmcd->hdc, Widths, 0, 0
								LineTo nmcd->hdc, Widths, ScaleY(This.Height)
							Next i
							Dim As HWND hHeader = ListView_GetHeader(FHandle)
							Dim As ..Rect R
							GetWindowRect(hHeader, @R)
							Heights = R.Bottom - R.Top - 1
							Dim rc As ..Rect
							If ListView_GetItemCount(FHandle) = 0 Then
								If FItemHeight = 0 Then
									Dim As LVITEM lvi
									lvi.mask = LVIF_PARAM
									lvi.lParam = 0
									ListView_InsertItem(FHandle, @lvi)
									ListView_GetItemRect FHandle, 0, @rc, LVIR_BOUNDS
									ListView_DeleteItem(FHandle, 0)
									FItemHeight = rc.Bottom - rc.Top
								End If
							Else
								ListView_GetItemRect FHandle, 0, @rc, LVIR_BOUNDS
								FItemHeight = rc.Bottom - rc.Top
							End If
							For i As Integer = 0 To ListView_GetCountPerPage(FHandle)
								Heights += FItemHeight
								MoveToEx nmcd->hdc, 0, Heights, 0
								LineTo nmcd->hdc, ScaleX(This.Width), Heights
							Next i
							SelectObject(nmcd->hdc, PrevPen)
							DeleteObject GridLinesPen
						End If
						Message.Result = CDRF_SKIPPOSTPAINT Or CDRF_SKIPDEFAULT
						Return
					End Select
				End Select
			Case WM_NOTIFY
				If (Cast(LPNMHDR, Message.lParam)->code = NM_CUSTOMDRAW) Then
					Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, Message.lParam)
					Select Case nmcd->dwDrawStage
					Case CDDS_PREPAINT
						Message.Result = CDRF_NOTIFYITEMDRAW
						Return
					Case CDDS_ITEMPREPAINT
						'Var info = Cast(SubclassInfo Ptr, dwRefData)
						If g_darkModeEnabled Then
							SetTextColor(nmcd->hdc, headerTextColor)
						End If
						Message.Result = CDRF_DODEFAULT
						Return
					End Select
				End If
				Select Case Message.wParam
				Case LVN_ENDSCROLL
				Case LVN_ENDSCROLL
				End Select
			Case CM_COMMAND
				Select Case Message.wParam
				Case LVN_ITEMACTIVATE
				Case LVN_KEYDOWN
				Case LVN_ITEMCHANGING
				Case LVN_ITEMCHANGED
				Case LVN_INSERTITEM
				Case LVN_DELETEITEM
				Case LVN_DELETEALLITEMS
				Case LVN_BEGINLABELEDIT
				Case LVN_ENDLABELEDIT
				Case LVN_BEGINDRAG
				Case LVN_BEGINRDRAG
				Case LVN_ODCACHEHINT
				Case LVN_ODFINDITEM
				Case LVN_ODSTATECHANGED
				Case LVN_HOTTRACK
				Case LVN_GETDISPINFO
				Case LVN_SETDISPINFO
					'Case LVN_COLUMNDROPDOWN
				Case LVN_GETINFOTIP
					'Case LVN_COLUMNOVERFLOWCLICK
				Case LVN_INCREMENTALSEARCH
				Case LVN_BEGINSCROLL
				Case LVN_ENDSCROLL
					'Case LVN_LINKCLICK
					'Case LVN_GETEMPTYMARKUP
				Case VK_DOWN
					GridEditText.Visible= False
				Case VK_UP
					GridEditText.Visible= False
				Case VK_ESCAPE
					GridEditText.Visible= False
				Case VK_RETURN, VK_TAB
					Print  "Now you can input RETURN Keycode" 
					'If GridEditText.Multiline = False Then
						Rows[FRow][FCol].Text = GridEditText.Text
						GridEditText.Visible=False ' Force refesh windows
					'End If
					
				End Select
				'            Dim As TBNOTIFY PTR Tbn
				'            Dim As TBBUTTON TB
				'            Dim As RECT R
				'            Dim As Integer i
				'            Tbn = Cast(TBNOTIFY PTR,Message.lParam)
				'            Select Case Tbn->hdr.Code
				'            Case TBN_DROPDOWN
				'                 If Tbn->iItem <> -1 Then
				'                     SendMessage(Tbn->hdr.hwndFrom,TB_GETRECT,Tbn->iItem,CInt(@R))
				'                     MapWindowPoints(Tbn->hdr.hwndFrom,0,Cast(Point Ptr,@R),2)
				'                     i = SendMessage(Tbn->hdr.hwndFrom,TB_COMMANDTOINDEX,Tbn->iItem,0)
				'                     If SendMessage(Tbn->hdr.hwndFrom,TB_GETBUTTON,i,CInt(@TB)) Then
				'                         TrackPopupMenu(Buttons.Button(i)->DropDownMenu.Handle,0,R.Left,R.Bottom,0,Tbn->hdr.hwndFrom,NULL)
				'                     End If
				'                 End If
				'            End Select
			Case CM_NEEDTEXT
				'            Dim As LPTOOLTIPTEXT TTX
				'            TTX = Cast(LPTOOLTIPTEXT,Message.lParam)
				'            TTX->hInst = GetModuleHandle(NULL)
				'            If TTX->hdr.idFrom Then
				'                Dim As TBButton TB
				'                Dim As Integer Index
				'                Index = Perform(TB_COMMANDTOINDEX,TTX->hdr.idFrom,0)
				'                If Perform(TB_GETBUTTON,Index,CInt(@TB)) Then
				'                   If Buttons.Button(Index)->ShowHint Then
				'                      If Buttons.Button(Index)->Hint <> "" Then
				'                          'Dim As UString s
				'                          's = Buttons.Button(Index).Hint
				'                          TTX->lpszText = @(Buttons.Button(Index)->Hint)
				'                      End If
				'                   End If
				'                End If
				'            End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub Grid.EditControlShow(ByVal tRow As Integer, ByVal tCol As Integer)
			If FAllowEdit = False OrElse tCol = 0 Then Exit Sub
			If GridEditText.Visible = True Then Rows.Item(FRow)->Item(FCol) = GridEditText.Text
			Dim As Rect RectCell
			Dim As WString Ptr sText
			'Move to new position
			If tRow >= 0 AndAlso tCol >= 0 Then
				FRow = tRow: FCol = tCol
				WLet(sText, Rows.Item(FRow)->Text(FCol))
				ListView_GetSubItemRect(Handle, FRow, FCol, LVIR_BOUNDS, @RectCell)
				GridEditText.Visible =True
				GridEditText.BackColor = FGridEditTextBackColor
				GridEditText.Font.Color = FGridEditTextForeColor
				GridEditText.SetBounds UnScaleX(RectCell.Left), UnScaleY(RectCell.Top), UnScaleX(RectCell.Right - RectCell.Left) - 1, UnScaleY(RectCell.Bottom - RectCell.Top) - 1
				GridEditText.Text = *sText
				GridEditText.SetFocus
				GridEditText.SetSel Len(*sText),Len(*sText)
			Else
				GridEditText.Visible= False
			End If
			'InvalidateRect(Handle,@RectCell,False)
			'UpdateWindow Handle
			Deallocate_(sText)
		End Sub
		
		Private Sub Grid.WndProc(ByRef Message As Message)
		End Sub
		
		Private Sub Grid.HandleIsDestroyed(ByRef Sender As Control)
		End Sub
		
		Private Sub Grid.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QGrid(Sender.Child)
					If .Images Then
						.Images->ParentWindow = @Sender
						If .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
					End If
					If .SelectedImages Then .SelectedImages->ParentWindow = @Sender
					If .SmallImages Then .SmallImages->ParentWindow = @Sender
					If .GroupHeaderImages Then .GroupHeaderImages->ParentWindow = @Sender
					If .Images AndAlso .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
					If .SelectedImages AndAlso .SelectedImages->Handle Then ListView_SetImageList(.FHandle, CInt(.SelectedImages->Handle), LVSIL_STATE)
					If .SmallImages AndAlso .SmallImages->Handle Then ListView_SetImageList(.FHandle, CInt(.SmallImages->Handle), LVSIL_SMALL)
					If .GroupHeaderImages AndAlso .GroupHeaderImages->Handle Then ListView_SetImageList(.FHandle, CInt(.GroupHeaderImages->Handle), LVSIL_GROUPHEADER)
					Dim lvStyle As Integer
					lvStyle = SendMessage(.FHandle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
					lvStyle = lvStyle Or .FLVExStyle
					SendMessage(.FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal lvStyle)
					.GridEditText.ParentHandle= .Handle
					.GridEditText.Visible= False
					For i As Integer = 0 To .Columns.Count -1
						Dim lvc As LVCOLUMN
						lvc.mask            = LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
						lvc.fmt             = .Columns.Column(i)->Format
						lvc.cx              = 0
						lvc.pszText         = @.Columns.Column(i)->Text
						lvc.cchTextMax      = Len(.Columns.Column(i)->Text)
						lvc.iImage          = .Columns.Column(i)->ImageIndex
						lvc.iSubItem        = i
						Var iWidth = .Columns.Column(i)->Width
						ListView_InsertColumn(.FHandle, i, @lvc)
						ListView_SetColumnWidth(.FHandle, i, ScaleX(iWidth))
					Next i
					Var TempHandle = .FHandle
					For i As Integer = 0 To .Rows.Count - 1
						For j As Integer = 0 To .Columns.Count - 1
							.FHandle = 0
							Dim lvi As LVITEM
							lvi.pszText         = @.Rows.Item(i)->Text(j)
							lvi.cchTextMax      = Len(.Rows.Item(i)->Text(j))
							lvi.iItem           = i
							lvi.iSubItem        = j
							If j = 0 Then
								lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
								lvi.iImage          = .Rows.Item(i)->ImageIndex
								lvi.state   = INDEXTOSTATEIMAGEMASK(.Rows.Item(i)->State)
								lvi.stateMask = LVIS_STATEIMAGEMASK
								lvi.iIndent   = .Rows.Item(i)->Indent
								lvi.lParam   =  Cast(LPARAM, .Rows.Item(i))
								.FHandle = TempHandle
								ListView_InsertItem(.FHandle, @lvi)
							Else
								.FHandle = TempHandle
								lvi.mask = LVIF_TEXT
								ListView_SetItem(.FHandle, @lvi)
							End If
						Next j
					Next i
					.SelectedRowIndex = 0
				End With
			End If
		End Sub
	#else
		Private Sub Grid.Grid_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As Grid Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If lv->OnRowActivate Then lv->OnRowActivate(*lv, Val(*gtk_tree_model_get_string_from_iter(model, @iter)))
				End If
			End If
		End Sub
		
		Private Sub Grid.Grid_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As Grid Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If gtk_tree_selection_get_selected(selection, @model, @iter) Then
					Dim As Integer SelectedIndex = Val(*gtk_tree_model_get_string_from_iter(model, @iter))
					If lv->PrevIndex <> SelectedIndex AndAlso lv->PrevIndex <> -1 Then
						Dim bCancel As Boolean
						If lv->OnSelectedRowChanging Then lv->OnSelectedRowChanging(*lv, lv->PrevIndex, bCancel)
						If bCancel Then
							lv->SelectedRowIndex = lv->PrevIndex
							Exit Sub
						End If
					End If
					If lv->OnSelectedRowChanged Then lv->OnSelectedRowChanged(*lv, SelectedIndex)
					lv->PrevIndex = SelectedIndex
				End If
			End If
		End Sub
		
		Private Sub Grid.Grid_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As Grid Ptr lv = user_data
			lv->Init
		End Sub
		
		Private Function Grid.Grid_Scroll(self As GtkAdjustment Ptr, user_data As Any Ptr) As Boolean
			Dim As Grid Ptr lv = user_data
			If lv->OnEndScroll Then lv->OnEndScroll(*lv)
			Return True
		End Function
	#endif
	
	Private Operator Grid.[](RowIndex As Integer) ByRef As GridRow
		Return *Rows.Item(RowIndex)
	End Operator
	
	Private Operator Grid.Cast As Control Ptr
		Return @This
	End Operator
	
	Private Constructor Grid
		#ifdef __USE_GTK__
			ListStore = gtk_list_store_new(3, G_TYPE_BOOLEAN, GDK_TYPE_PIXBUF, G_TYPE_STRING)
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'widget = gtk_tree_view_new_with_model(gtk_tree_model(ListStore))
			widget = gtk_tree_view_new()
			gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
			TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
			#ifdef __USE_GTK3__
				g_signal_connect(gtk_scrollable_get_hadjustment(GTK_SCROLLABLE(widget)), "value-changed", G_CALLBACK(@Grid_Scroll), @This)
				g_signal_connect(gtk_scrollable_get_vadjustment(GTK_SCROLLABLE(widget)), "value-changed", G_CALLBACK(@Grid_Scroll), @This)
			#else
				g_signal_connect(gtk_tree_view_get_hadjustment(GTK_TREE_VIEW(widget)), "value-changed", G_CALLBACK(@Grid_Scroll), @This)
				g_signal_connect(gtk_tree_view_get_vadjustment(GTK_TREE_VIEW(widget)), "value-changed", G_CALLBACK(@Grid_Scroll), @This)
			#endif
			g_signal_connect(GTK_TREE_VIEW(widget), "map", G_CALLBACK(@Grid_Map), @This)
			g_signal_connect(GTK_TREE_VIEW(widget), "row-activated", G_CALLBACK(@Grid_RowActivated), @This)
			g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@Grid_SelectionChanged), @This)
			gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), GTK_TREE_VIEW_GRID_LINES_BOTH)
			ColumnTypes = New_( GType[3])
			ColumnTypes[0] = G_TYPE_BOOLEAN
			ColumnTypes[1] = GDK_TYPE_PIXBUF
			ColumnTypes[2] = G_TYPE_STRING
			This.RegisterClass "Grid", @This
		#endif
		BorderStyle = BorderStyles.bsClient
		Rows.Parent = @This
		Columns.Parent = @This
		DoubleBuffered = True
		FEnabled = True
		FGridLines = True
		FFullRowSelect = True
		FVisible = True
		FTabIndex          = -1
		FTabStop           = True
		With GridEditText
			.Parent = @This
			.Multiline= False
			.BringToFront
		End With
		FGridEditTextForeColor = clBlack
		With This
			#ifndef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.ChildProc         = @WndProc
				.ExStyle           = WS_EX_CLIENTEDGE
				.FLVExStyle        = LVS_EX_FULLROWSELECT Or LVS_EX_GRIDLINES Or LVS_EX_DOUBLEBUFFER
				.Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
				.DoubleBuffered = True
				.RegisterClass "Grid", WC_LISTVIEW
				WLet(FClassAncestor, WC_LISTVIEW)
			#endif
			.Child             = @This
			WLet(FClassName, "Grid")
			.Width             = 121
			.Height            = 121
		End With
	End Constructor
	
	Private Destructor Grid
		#ifndef __USE_GTK__
			UnregisterClass "Grid", GetModuleHandle(NULL)
		#else
			If ColumnTypes Then Delete_SquareBrackets( ColumnTypes)
		#endif
	End Destructor
End Namespace
