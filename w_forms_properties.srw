HA$PBExportHeader$w_forms_properties.srw
forward
global type w_forms_properties from window
end type
type lb_restore from listbox within w_forms_properties
end type
type cb_4 from commandbutton within w_forms_properties
end type
type cbx_web from checkbox within w_forms_properties
end type
type cbx_3 from checkbox within w_forms_properties
end type
type cbx_2 from checkbox within w_forms_properties
end type
type cb_3 from commandbutton within w_forms_properties
end type
type cb_2 from commandbutton within w_forms_properties
end type
type ddlb_building from dropdownlistbox within w_forms_properties
end type
type ddlb_location from dropdownlistbox within w_forms_properties
end type
type st_12 from statictext within w_forms_properties
end type
type st_11 from statictext within w_forms_properties
end type
type cbx_1 from checkbox within w_forms_properties
end type
type st_10 from multilineedit within w_forms_properties
end type
type st_9 from statictext within w_forms_properties
end type
type st_8 from statictext within w_forms_properties
end type
type st_7 from statictext within w_forms_properties
end type
type cb_1 from commandbutton within w_forms_properties
end type
type sle_4 from singlelineedit within w_forms_properties
end type
type sle_3 from singlelineedit within w_forms_properties
end type
type sle_2 from singlelineedit within w_forms_properties
end type
type sle_1 from singlelineedit within w_forms_properties
end type
type st_5 from statictext within w_forms_properties
end type
type st_4 from statictext within w_forms_properties
end type
type st_3 from statictext within w_forms_properties
end type
type st_2 from statictext within w_forms_properties
end type
type st_1 from statictext within w_forms_properties
end type
end forward

global type w_forms_properties from window
integer width = 1522
integer height = 1344
boolean titlebar = true
string title = "Forms Properties"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 15780518
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
lb_restore lb_restore
cb_4 cb_4
cbx_web cbx_web
cbx_3 cbx_3
cbx_2 cbx_2
cb_3 cb_3
cb_2 cb_2
ddlb_building ddlb_building
ddlb_location ddlb_location
st_12 st_12
st_11 st_11
cbx_1 cbx_1
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
cb_1 cb_1
sle_4 sle_4
sle_3 sle_3
sle_2 sle_2
sle_1 sle_1
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_forms_properties w_forms_properties

type variables
integer ii_ftab
string is_fname, is_pname
end variables

on w_forms_properties.create
this.lb_restore=create lb_restore
this.cb_4=create cb_4
this.cbx_web=create cbx_web
this.cbx_3=create cbx_3
this.cbx_2=create cbx_2
this.cb_3=create cb_3
this.cb_2=create cb_2
this.ddlb_building=create ddlb_building
this.ddlb_location=create ddlb_location
this.st_12=create st_12
this.st_11=create st_11
this.cbx_1=create cbx_1
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.cb_1=create cb_1
this.sle_4=create sle_4
this.sle_3=create sle_3
this.sle_2=create sle_2
this.sle_1=create sle_1
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.lb_restore,&
this.cb_4,&
this.cbx_web,&
this.cbx_3,&
this.cbx_2,&
this.cb_3,&
this.cb_2,&
this.ddlb_building,&
this.ddlb_location,&
this.st_12,&
this.st_11,&
this.cbx_1,&
this.st_10,&
this.st_9,&
this.st_8,&
this.st_7,&
this.cb_1,&
this.sle_4,&
this.sle_3,&
this.sle_2,&
this.sle_1,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_forms_properties.destroy
destroy(this.lb_restore)
destroy(this.cb_4)
destroy(this.cbx_web)
destroy(this.cbx_3)
destroy(this.cbx_2)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.ddlb_building)
destroy(this.ddlb_location)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.cbx_1)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.cb_1)
destroy(this.sle_4)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;integer li_formrow

ii_ftab = integer(message.stringparm)
is_pname = w_forms_main.i_active_sheet.u_to_open[ii_ftab].ls_formname
is_fname = ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.u_to_open[ii_ftab].ls_formname,"Load",w_forms_main.i_active_sheet.u_to_open[ii_ftab].ls_formname)
sle_1.text = w_forms_main.i_active_sheet.u_to_open[ii_ftab].ls_formname
sle_2.text = Profilestring(w_forms_main.i_active_sheet.is_formini,is_fname,"Form","")
sle_3.text = w_forms_main.i_active_sheet.u_to_open[ii_ftab].is_cversion
sle_4.text = w_forms_main.i_active_sheet.u_to_open[ii_ftab].is_version
li_formrow = w_forms_main.i_active_sheet.u_to_open[ii_ftab].ii_formrow
IF ProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"Update","NO") = "Yes" THEN cbx_2.checked = TRUE
IF Upper(ProfileString(w_forms_main.i_active_sheet.is_formini,is_pname,"PUpdate","NO")) = "YES" THEN cbx_3.checked = TRUE
IF ProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"WebUpdate","NO") = "Yes" THEN cbx_web.checked = TRUE

ddlb_location.text = w_forms_main.i_active_sheet.u_to_open[ii_Ftab].is_location
ddlb_building.text = w_forms_main.i_active_sheet.u_to_open[ii_Ftab].is_building

st_8.text = ProfileString(gs_ini,"MAIN","sscg_dyn.pbl","N/A") 
string ls_mfz
ls_mfz = w_forms_main.i_active_sheet.ii_templates + "sscgforms\" + is_fname + ".mfz"
IF FIleExists(ls_mfz) THEN
	st_10.text = ls_mfz
END IF

IF 	ProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"SRD","No") = "Yes" THEN cbx_1.checked = TRUE

lb_restore.DirList(get_pathname(w_forms_main.i_active_sheet.ls_filename) + string(li_formrow,"00") + is_pname + "*.*" ,0)

end event

type lb_restore from listbox within w_forms_properties
integer x = 247
integer y = 960
integer width = 960
integer height = 128
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 15780518
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;IF Messagebox("Restore File","Do you wish to restore this file",Question!, YesNo!,2) = 1 THEN
	open(w_waiting)
	w_forms_main.i_active_sheet.trigger event ue_import_zip(this.text(index), ii_ftab)
	w_forms_main.i_active_sheet.u_to_open[ii_ftab].lb_changed = TRUE
	close(w_waiting)
END IF
end event

type cb_4 from commandbutton within w_forms_properties
integer x = 1193
integer y = 328
integer width = 265
integer height = 68
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
end type

event clicked;w_forms_main.i_active_sheet.trigger event ue_unzip_mfz(is_fname)
end event

type cbx_web from checkbox within w_forms_properties
integer x = 955
integer y = 324
integer width = 233
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Web"
end type

event clicked;IF this.checked THEN
	SetProfileString(w_forms_main.i_active_sheet.is_formini,is_pname,"WebUpdate","Yes")
	SetProfileString(w_forms_main.i_active_sheet.is_formini,is_pname,"Web","Yes")
	SetProfileString(w_forms_main.i_active_sheet.is_formini,"Web Options",is_pname,"1.00")
ELSE
	SetProfileString(w_forms_main.i_active_sheet.is_formini,is_pname,"WebUpdate","No")
END IF
end event

type cbx_3 from checkbox within w_forms_properties
integer x = 645
integer y = 324
integer width = 283
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Print"
end type

event clicked;string ls_options = "abcdefghijklmnopqrstuvwxyz", ls_answer
integer lx

IF this.checked THEN
	ls_answer = "Yes"
ELSE
	ls_answer = "No"
END IF
SetProfileString(w_forms_main.i_active_sheet.is_formini,is_pname,"PUpdate",ls_answer)
FOR lx = 1 to len(ls_options)
	IF ProfileString(w_forms_main.i_active_sheet.is_formini,is_pname + mid(ls_options,lx,1),"PUpdate","") <> "" THEN
		SetProfileString(w_forms_main.i_active_sheet.is_formini,is_pname + mid(ls_options,lx,1),"PUpdate",ls_answer)
	END IF
NExT
		

end event

type cbx_2 from checkbox within w_forms_properties
integer x = 343
integer y = 324
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Form"
end type

event clicked;IF this.checked THEN
	SetProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"Update","Yes")
	//w_forms_main.i_active_sheet.trigger event ue_load_zip(is_fname,"",ii_ftab)
ELSE
	SetProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"Update","No")
END IF
end event

type cb_3 from commandbutton within w_forms_properties
integer x = 1381
integer y = 684
integer width = 78
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "*"
end type

event clicked;set_ini("!SSCG Dyn file","Main","sscg_dyn.pbl","sscg_dyn.pbd",TRUE)
st_8.text = ProfileString(gs_ini,"MAIN","sscg_dyn.pbl","N/A") 
end event

type cb_2 from commandbutton within w_forms_properties
integer x = 1390
integer y = 840
integer width = 78
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "*"
end type

event clicked;string ls_dir, ls_exe, ls_version
ls_dir = st_10.text
IF FileExists(ls_dir) THEN
	openwithparm(w_simplezip,ls_dir)
	w_simplezip.ue_unzipall(ls_dir,"")
	ls_exe = get_dwsyntax(w_simplezip.ue_finddir() + "form.txt")
	ls_version = get_dwsyntax(w_simplezip.ue_finddir() + "version.txt")
	Messagebox("Form " +ls_dir, "Version#:  " + ls_version + " Form:  "  + ls_exe)				
	w_simplezip.deleteall(FALSE,TRUE)
	close(w_simplezip)
END IF
end event

type ddlb_building from dropdownlistbox within w_forms_properties
integer x = 311
integer y = 516
integer width = 722
integer height = 400
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = true
boolean vscrollbar = true
string item[] = {"Yes","No"}
borderstyle borderstyle = stylelowered!
end type

event constructor;Integer lx
FOR lx = 1 to Upperbound(w_forms_main.i_active_sheet.ls_building)
	IF w_forms_main.i_active_sheet.ls_location[lx]  <> "<DELETED>" THEN
		this.additem(w_forms_main.i_active_sheet.ls_building[lx])
	END IF
NEXT

end event

event modified;w_forms_main.i_active_sheet.u_to_open[ii_Ftab].is_building = this.text
end event

type ddlb_location from dropdownlistbox within w_forms_properties
integer x = 311
integer y = 412
integer width = 727
integer height = 400
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = true
boolean vscrollbar = true
string item[] = {"",""}
borderstyle borderstyle = stylelowered!
end type

event constructor;integer li, lx
Boolean lb_found 
FOR li = 1 to Upperbound(w_forms_main.i_active_sheet.ls_location)
	lb_found = FALSE
	FOR lx = 1 to this.totalitems()
		IF this.text(lx) = w_forms_main.i_active_sheet.ls_location[li] THEN lb_found = TRUE
	NEXT
	IF NOT lb_found THEN this.additem(w_forms_main.i_active_sheet.ls_location[li])
NEXT


end event

event selectionchanged;w_forms_main.i_active_sheet.u_to_open[ii_Ftab].is_location = this.text
end event

type st_12 from statictext within w_forms_properties
integer x = 41
integer y = 520
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Building:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_forms_properties
integer x = 41
integer y = 424
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Location:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_forms_properties
integer x = 1221
integer y = 136
integer width = 219
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "SRD"
boolean lefttext = true
end type

event clicked;IF this.checked THEN
	SetProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"SRD","Yes")
ELSE
	SetProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"SRD","No")
END IF

end event

type st_10 from multilineedit within w_forms_properties
event doubleclick pbm_cbndblclk
integer x = 37
integer y = 844
integer width = 1312
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 15780518
boolean border = false
boolean displayonly = true
end type

type st_9 from statictext within w_forms_properties
integer x = 41
integer y = 776
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "MFZ Location:"
boolean focusrectangle = false
end type

type st_8 from statictext within w_forms_properties
integer x = 37
integer y = 680
integer width = 1317
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 15780518
boolean focusrectangle = false
end type

type st_7 from statictext within w_forms_properties
integer x = 41
integer y = 616
integer width = 521
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Combine Print Location:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_forms_properties
integer x = 425
integer y = 1136
integer width = 517
integer height = 64
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(w_forms_properties)
end event

type sle_4 from singlelineedit within w_forms_properties
integer x = 1152
integer y = 232
integer width = 302
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_3 from singlelineedit within w_forms_properties
integer x = 521
integer y = 228
integer width = 265
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;SetProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"Version5",this.text)
end event

type sle_2 from singlelineedit within w_forms_properties
integer x = 311
integer y = 128
integer width = 882
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;SetProfileString(w_forms_main.i_active_sheet.is_formini,is_fname,"Form",this.text)
w_forms_main.i_active_sheet.u_to_open[ii_ftab].ls_formlibrary = this.text

end event

type sle_1 from singlelineedit within w_forms_properties
integer x = 311
integer y = 28
integer width = 1138
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_forms_properties
integer x = 41
integer y = 324
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Update:"
boolean focusrectangle = false
end type

event doubleclicked;w_forms_main.i_active_sheet.trigger event ue_load_zip(is_fname,"",ii_ftab)
end event

type st_4 from statictext within w_forms_properties
integer x = 827
integer y = 232
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Created In:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_forms_properties
integer x = 302
integer y = 228
integer width = 206
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Version:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_forms_properties
integer x = 41
integer y = 128
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "PBL:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_forms_properties
integer x = 41
integer y = 28
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15780518
string text = "Form Name:"
boolean focusrectangle = false
end type

