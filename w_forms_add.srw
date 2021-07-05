HA$PBExportHeader$w_forms_add.srw
forward
global type w_forms_add from window
end type
type cb_2 from commandbutton within w_forms_add
end type
type uo_1 from uo_locations within w_forms_add
end type
type cb_1 from commandbutton within w_forms_add
end type
type lb_3 from listbox within w_forms_add
end type
type lb_choices from listbox within w_forms_add
end type
type dw_dirlist from datawindow within w_forms_add
end type
end forward

global type w_forms_add from window
integer width = 2121
integer height = 1372
boolean titlebar = true
string title = "Forms"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "Form!"
boolean center = true
cb_2 cb_2
uo_1 uo_1
cb_1 cb_1
lb_3 lb_3
lb_choices lb_choices
dw_dirlist dw_dirlist
end type
global w_forms_add w_forms_add

type variables

end variables

on w_forms_add.create
this.cb_2=create cb_2
this.uo_1=create uo_1
this.cb_1=create cb_1
this.lb_3=create lb_3
this.lb_choices=create lb_choices
this.dw_dirlist=create dw_dirlist
this.Control[]={this.cb_2,&
this.uo_1,&
this.cb_1,&
this.lb_3,&
this.lb_choices,&
this.dw_dirlist}
end on

on w_forms_add.destroy
destroy(this.cb_2)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.lb_3)
destroy(this.lb_choices)
destroy(this.dw_dirlist)
end on

event open;Integer li,lx
String ls_name
boolean lb_find
IF Upperbound(w_forms_main.i_active_sheet.u_to_open) = 0 THEN RETURN
FOR li = 1 TO 50
	IF Upperbound(w_forms_main.i_active_sheet.u_to_open) = 0 THEN 
		ls_name = ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.u_to_open[1].ls_formname,string(li),"")
	END IF
	IF pos(ls_name,"main_") > 0 THEN
		ls_name = Upper(Mid(ls_name,6,len(ls_name) - 5))
		lb_find = FALSE
		FOR lx = 1 to lb_choices.totalitems()
			IF UPPER(lb_choices.text(lx)) = UPPER(ls_name) THEN lb_find = TRUE
		NEXT			
		IF NOT lb_find THEN 	lb_choices.additem(ls_name)
	END IF
NEXT

IF lb_choices.totalitems() = 0 THEN dw_dirlist.trigger event ue_setup()

//IF ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"Choices","YES") = "YES" THEN 

FOR li = 1 TO integer(profilestring(w_forms_main.i_active_sheet.is_formini,"Main Choices","Totalitems","50"))
	ls_name = ProfileString(w_forms_main.i_active_sheet.is_formini,"Main Choices",string(li),"")
	IF ls_name <> "" THEN
		IF pos(ls_name,"main_") > 0 THEN ls_name = Upper(Mid(ls_name,6,len(ls_name) - 5))
		lb_find = FALSE
		FOR lx = 1 to lb_choices.totalitems()
			IF UPPER(lb_choices.text(lx)) = UPPER(ls_name) THEN lb_find = TRUE
		NEXT			
		IF NOT lb_find THEN lb_choices.additem(ls_name)
	END IF
NEXT

//END IF
end event

type cb_2 from commandbutton within w_forms_add
integer x = 37
integer y = 1136
integer width = 649
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Form"
end type

event clicked;IF lb_choices.selecteditem() = "" THEN RETURN
w_forms_main.i_active_sheet.ib_changed = TRUE

string ls_tabname, ls_formref , ls_ref
ls_ref = lb_choices.selecteditem()
//ls_tabname = text(lb_choices.seleteditem()) +  uo_1.get_name()

ls_formref = ProfileString(w_forms_main.i_active_sheet.is_formini,"FormRef",lb_choices.selecteditem(),"")
IF ls_formref  = "" THEN 
	ls_formref = "main_" + lb_choices.selecteditem()
ELSE
	IF pos(ls_formref,".mpf") > 0 THEN ls_formref = Left(ls_formref,len(ls_formref) - 4)
END IF

IF uo_1.cbx_2.checked AND uo_1.cbx_4.checked THEN
	w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,uo_1.lb_location.selecteditem(), uo_1.lb_building.selecteditem(), ls_ref,0)
ELSE
	IF uo_1.cbx_2.checked THEN
		w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,uo_1.lb_location.selecteditem(), "", ls_ref,0)
	ELSE
		w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,"","", ls_ref,0)
	END IF
END IF

//w_forms_add.visible = FALSE
end event

type uo_1 from uo_locations within w_forms_add
event destroy ( )
integer x = 722
integer y = 8
integer taborder = 20
end type

on uo_1.destroy
call uo_locations::destroy
end on

type cb_1 from commandbutton within w_forms_add
integer x = 1303
integer y = 1156
integer width = 741
integer height = 116
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Load Additional Forms >>"
end type

event clicked;lb_3.trigger event ue_load_mfz()
//lb_3.trigger event ue_load_forms()
end event

type lb_3 from listbox within w_forms_add
event ue_load_forms ( )
event ue_load_mfz ( )
integer x = 41
integer y = 1304
integer width = 1047
integer height = 672
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_load_forms();Integer lz
string ls_file, ls_template, ls_test, ls_section
ls_template = ProfileString(gs_ini,"Main","Templates","c:\minipro\template")
ls_section = "Form Choices"
IF RIght(ls_template,1) <> "\" THEN ls_template += "\"

this.visible = TRUE
FOR lz = 1 to 100
	ls_file = ProfileString(w_forms_main.i_active_sheet.is_formini,ls_section,string(lz),"")
	IF ls_file <> "" THEN
		ls_test = ProfileString(w_forms_main.i_active_sheet.is_formini,"FormRef",ls_file,"")
		CHOOSE CASE Upper(Right(ls_test,3))
		CASE "MPF","DBF"
			this.additem(ls_file)
		END CHOOSE
	END IF
NEXT

end event

event ue_load_mfz();string ls_template, ls_name
integer li, lx= 0
ls_template = ProfileString(gs_ini,"Main","Templates","c:\minipro\template")
IF Right(ls_template,1) <> "\" THEN ls_template += "\"
ls_template += "sscgforms\"
lb_3.dirlist(ls_template + "*.mfz",0)

FOR li = 1 to this.totalitems()
	IF Left(this.text(li),5) = "main_" THEN
		lx += 1
		ls_name = this.text(li)
		ls_name = Left(ls_name,len(ls_name) - 4)
		SetProfileString(w_forms_main.i_active_sheet.is_formini,"Main Choices",string(lx),Right(ls_name,len(ls_name) - 5))
	END IF
NEXT
w_forms_add.height = 2060


end event

event doubleclicked;//string ls_formname 
//ls_formname = Left(text(index),len(text(index)) - 4)
//w_forms_main.i_active_sheet.trigger event ue_load_zip(ls_formname, &
//	ls_formname,Upperbound(w_forms_main.i_active_sheet.u_to_open) + 1)
//w_forms_main.i_active_sheet.trigger event ue_load_dups(ls_formname)
//w_forms_main.i_active_sheet.ib_changed = TRUE
//
IF index > 0 THEN
string ls_formref

ls_formref = Left(text(index),len(text(index)) - 4)

IF uo_1.cbx_2.checked AND uo_1.cbx_4.checked THEN
	w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,uo_1.lb_location.selecteditem(), uo_1.lb_building.selecteditem(),"",0)
ELSE
	IF uo_1.cbx_2.checked THEN
		w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,uo_1.lb_location.selecteditem(), "","",0)
	ELSE
		w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,"","","",0)
	END IF
END IF
close(w_forms_add)
END IF


end event

type lb_choices from listbox within w_forms_add
integer x = 27
integer y = 32
integer width = 631
integer height = 1060
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;w_forms_main.i_active_sheet.ib_changed = TRUE

string ls_tabname, ls_formref, ls_ref 
//ls_tabname = text(index) +  uo_1.get_name()
ls_ref = text(index)

ls_formref = ProfileString(gs_ini,"FormRef",text(index),"")
IF ls_formref  = "" THEN 
	ls_formref = "main_" + text(index)
ELSE
	IF pos(ls_formref,".mpf") > 0 THEN ls_formref = Left(ls_formref,len(ls_formref) - 4)
END IF

IF uo_1.cbx_2.checked AND uo_1.cbx_4.checked THEN
	w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,uo_1.lb_location.selecteditem(), uo_1.lb_building.selecteditem(),ls_ref,0)
ELSE
	IF uo_1.cbx_2.checked THEN
		w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,uo_1.lb_location.selecteditem(), "",ls_ref,0)
	ELSE
		w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_formref,"","", ls_ref,0)
	END IF
END IF
		
w_forms_add.visible = FALSE

end event

type dw_dirlist from datawindow within w_forms_add
event ue_setup ( )
boolean visible = false
integer x = 27
integer y = 28
integer width = 640
integer height = 668
integer taborder = 50
string title = "none"
string dataobject = "dw_library_directory"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_setup();String ls_entries, ls_datawindow, ls_pbl
Integer li

string ls_template
ls_template = ProfileString(gs_ini,"Main","Templates","c:\minipro\template")
IF Right(ls_template,1) = "\" THEN ls_template += "\"

ls_pbl = ProfileString(gs_ini,"Main","Mainpbl","")
IF ls_pbl = "" THEN	
	ls_pbl = w_forms_main.i_active_sheet.ls_library
ELSE
	ls_pbl = ls_template + ls_pbl
END IF
ls_entries = LibraryDirectory(ls_pbl, DirDataWindow!)

lb_choices.reset()
this.SetRedraw(FALSE)
this.Reset( )
this.ImportString(ls_Entries)
this.SetRedraw(TRUE)
FOR li = 1 to this.rowcount()
	ls_datawindow = this.object.library_object[li]
	IF Upper(left(ls_datawindow,7)) = "DW_MAIN" THEN
		//SetProfileString(gs_ini,right(ls_datawindow,len(ls_datawindow) - 3),"Form",get_filename(ls_pbl))
		ls_datawindow = Upper(right(ls_datawindow,len(ls_datawindow) -8))
		lb_choices.additem(ls_datawindow)
	END IF
NEXT

end event

