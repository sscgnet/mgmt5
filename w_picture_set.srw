HA$PBExportHeader$w_picture_set.srw
forward
global type w_picture_set from window
end type
type ddlb_pdf from dropdownlistbox within w_picture_set
end type
type cb_7 from commandbutton within w_picture_set
end type
type st_5 from statictext within w_picture_set
end type
type cb_6 from commandbutton within w_picture_set
end type
type st_4 from statictext within w_picture_set
end type
type cb_5 from commandbutton within w_picture_set
end type
type p_preview from picture within w_picture_set
end type
type lb_types from listbox within w_picture_set
end type
type cb_4 from commandbutton within w_picture_set
end type
type st_3 from statictext within w_picture_set
end type
type em_perc from editmask within w_picture_set
end type
type cb_3 from commandbutton within w_picture_set
end type
type cb_2 from commandbutton within w_picture_set
end type
type cb_1 from commandbutton within w_picture_set
end type
type em_height from editmask within w_picture_set
end type
type em_width from editmask within w_picture_set
end type
type st_2 from statictext within w_picture_set
end type
type st_1 from statictext within w_picture_set
end type
type p_test from picture within w_picture_set
end type
type gb_1 from groupbox within w_picture_set
end type
type gb_2 from groupbox within w_picture_set
end type
end forward

global type w_picture_set from window
integer width = 1925
integer height = 1640
boolean titlebar = true
string title = "Setting Picture Size...."
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
ddlb_pdf ddlb_pdf
cb_7 cb_7
st_5 st_5
cb_6 cb_6
st_4 st_4
cb_5 cb_5
p_preview p_preview
lb_types lb_types
cb_4 cb_4
st_3 st_3
em_perc em_perc
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
em_height em_height
em_width em_width
st_2 st_2
st_1 st_1
p_test p_test
gb_1 gb_1
gb_2 gb_2
end type
global w_picture_set w_picture_set

type prototypes
FUNCTION long filesize(string f) LIBRARY "FUNCky32.DLL" alias for "filesize;Ansi"
end prototypes

type variables
datawindow i_ldw
string is_field, is_fname,is_cname
integer ii_owidth, ii_oheight, ii_row, ii_tab
boolean lb_reset = FALSE
end variables

forward prototypes
public function string set_picture (datawindow ldw, integer li_row, string ls_field, string ls_fname, integer li_owidth, integer li_oheight)
public function integer ue_check_field (datawindow ldw, string ls_field)
public subroutine set_defaults (datawindow ldw, integer li_row, string ls_field, string ls_fname, integer li_owidth, integer li_oheight, integer li_tab)
end prototypes

public function string set_picture (datawindow ldw, integer li_row, string ls_field, string ls_fname, integer li_owidth, integer li_oheight);long li_awidth, li_aheight, li_height, li_width, ll_size, ll_fsize
Decimal ld_perc
string ls_field2
Boolean lb_found = FALSE
integer li

IF li_owidth = 0 OR li_oheight = 0 THEN
	Messagebox("Set Picture","Picture height/width can not be set to zero")
	RETURN ls_fname
END IF
p_test.PictureName = ls_fname

li_awidth = p_test.Width
li_aheight = p_test.Height
	
IF UPPER(ProfileString(gs_ini,"Photos","Resize","Yes")) = "YES" THEN
IF li_oheight > li_owidth THEN
	If li_aheight > li_oheight THEN
		ld_perc = li_oheight/li_aheight
		li_width = Round(li_awidth * ld_perc,0)
		IF li_width > li_owidth THEN
			ld_perc = li_owidth/li_awidth
			li_height = Round(li_aheight * ld_perc,0)
			li_width = li_owidth
		ELSE
			li_height = li_oheight
		END IF
	ELSE
		ld_perc = li_owidth/li_awidth
		li_height = Round(li_aheight * ld_perc,0)
		ls_field2 = Right(ls_field,len(ls_field) - pos(ls_field, "_"))
		IF li_width > li_owidth THEN
			//ld_perc = li_owidth/li_awidth
			li_width = Round(li_awidth * ld_perc,0)
			li_height = li_oheight
		ELSE
			li_width = li_owidth
		END IF
	END IF
ELSE
	If li_awidth > li_owidth THEN
		ld_perc = li_owidth/li_awidth
		li_height = Round(li_aheight * ld_perc,0)
		IF li_height > li_oheight THEN
			ld_perc = li_oheight/li_aheight
			li_width = Round(li_awidth * ld_perc,0)
			li_height = li_oheight
		ELSE
			li_width = li_owidth
		END IF
	ELSE
		ld_perc = li_oheight/li_aheight
		li_width = Round(li_awidth * ld_perc,0)
		ls_field2 = Right(ls_field,len(ls_field) - pos(ls_field, "_"))
		IF li_width > li_owidth THEN
			//ld_perc = li_owidth/li_awidth
			li_height = Round(li_aheight * ld_perc,0)
			li_width = li_owidth
		ELSE
			li_height = li_oheight
		END IF
	END IF
END IF

ls_field2 = Right(ls_field,len(ls_field) - pos(ls_field, "_"))
IF ue_check_field(ldw,"w_" + ls_field2) > 0 THEN
	IF lb_reset THEN
		em_width.text = string(li_width)
	ELSE
		ldw.setitem(li_row,"w_" + ls_field2,li_width)
		ldw.Modify(ls_field + ".Width = '" + string(li_width) + "'")
	END IF
END IF
IF ue_check_field(ldw,"h_" + ls_field2) > 0 THEN
	IF lb_reset THEN
		em_height.text = string(li_height)
	ELSE
		ldw.setitem(li_row,"h_" + ls_field2,li_height)
		ldw.Modify(ls_field + ".Height = '" + string(li_height) + "'")
	END IF
END IF
END IF
//ldw.setitem(li_row,ls_field,uo_pict.st_desc.text)

//st_status.text = "Ready"
RETURN ls_fname
end function

public function integer ue_check_field (datawindow ldw, string ls_field);string ls_bfield
integer li, li_found, li_count

IF ls_field = "?" THEN 
	Messagebox("Field Error","Problem loading field")
	RETURN 0
END IF
//IF ldw.rowcount() = 0 THEN RETURN 0
FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
	ls_bfield = ldw.Describe("#" + string(li) + ".Name")
	IF ls_field = ls_bfield THEN li_found = li
NEXT

IF li_found = 0 AND ProfileString(gs_ini,"Utilities","FormError","NO") = "YES" THEN
	Messagebox("Field Error","Problem checking field " + ls_field)
END IF


RETURN li_found
end function

public subroutine set_defaults (datawindow ldw, integer li_row, string ls_field, string ls_fname, integer li_owidth, integer li_oheight, integer li_tab);string ls_field2
integer li_field

i_ldw = ldw
is_field = ls_field
is_fname = ls_fname
ii_owidth = li_owidth
ii_tab = li_tab

ii_oheight = li_oheight
w_picture_set.title = "Set Picture Size " + string(ii_owidth) + "x" + string(ii_oheight) 
ii_row = li_row
lb_reset = TRUE
ls_field2 = Right(is_field,len(is_field) - pos(is_field, "_"))

li_field = ue_check_field(ldw,"w_" + ls_field2)
IF li_field > 0 THEN
	cb_1.visible = TRUE
	cb_2.visible = TRUE
	em_width.text = string(ldw.object.data[li_row,li_field])
	li_field = ue_check_field(ldw,"h_" + ls_field2)
	IF li_field > 0 THEN
		em_height.text = string(ldw.object.data[li_row,li_field])
	END IF
END IF
cb_3.visible = TRUE

end subroutine

on w_picture_set.create
this.ddlb_pdf=create ddlb_pdf
this.cb_7=create cb_7
this.st_5=create st_5
this.cb_6=create cb_6
this.st_4=create st_4
this.cb_5=create cb_5
this.p_preview=create p_preview
this.lb_types=create lb_types
this.cb_4=create cb_4
this.st_3=create st_3
this.em_perc=create em_perc
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_height=create em_height
this.em_width=create em_width
this.st_2=create st_2
this.st_1=create st_1
this.p_test=create p_test
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.ddlb_pdf,&
this.cb_7,&
this.st_5,&
this.cb_6,&
this.st_4,&
this.cb_5,&
this.p_preview,&
this.lb_types,&
this.cb_4,&
this.st_3,&
this.em_perc,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.em_height,&
this.em_width,&
this.st_2,&
this.st_1,&
this.p_test,&
this.gb_1,&
this.gb_2}
end on

on w_picture_set.destroy
destroy(this.ddlb_pdf)
destroy(this.cb_7)
destroy(this.st_5)
destroy(this.cb_6)
destroy(this.st_4)
destroy(this.cb_5)
destroy(this.p_preview)
destroy(this.lb_types)
destroy(this.cb_4)
destroy(this.st_3)
destroy(this.em_perc)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_height)
destroy(this.em_width)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_test)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type ddlb_pdf from dropdownlistbox within w_picture_set
boolean visible = false
integer x = 2158
integer y = 572
integer width = 411
integer height = 324
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event constructor;integer li,lpos

this.DirList(get_dir("Templates","")+ "photo_*.emp", 1)
FOR li = 1 to this.totalitems()
	IF pos(this.text(li),"pdf") > 0 THEN
	ELSE
		lpos = pos(this.text(li),".")
		lb_types.additem(mid(this.text(li),7,lpos -7))
	END IF
NEXT

end event

type cb_7 from commandbutton within w_picture_set
integer x = 1413
integer y = 1404
integer width = 407
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Picture"
end type

event clicked;string pathname, filename
GetFileOpenName ( "New File Name", pathname, filename)

IF FileExists(pathname) THEN
	cb_6.visible = TRUE			
	IF get_pathname(is_fname) = get_pathname(pathname) THEN
		is_fname = pathname
	ELSE
		IF Messagebox("File Copy","Do you wish to overwrite " + is_Fname,Question!,YesNo!,2) = 1 THEN
			FileCopy(pathname,is_fname,TRUE)
		END IF
	END IF
END IF
end event

type st_5 from statictext within w_picture_set
integer x = 1413
integer y = 636
integer width = 402
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421376
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_6 from commandbutton within w_picture_set
boolean visible = false
integer x = 398
integer y = 1396
integer width = 581
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Replace Picture"
end type

event clicked;integer li_field

li_field = ue_check_field(i_ldw,is_field)
IF li_field > 0 THEN
	i_ldw.setitem(ii_row,li_field,is_fname)
	w_forms_main.i_active_sheet.u_to_open[ii_tab].lb_changed = TRUE
	this.enabled = FALSE
END IF


end event

type st_4 from statictext within w_picture_set
integer x = 37
integer y = 40
integer width = 1312
integer height = 232
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_5 from commandbutton within w_picture_set
integer x = 165
integer y = 1308
integer width = 521
integer height = 76
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get Preview"
end type

event clicked;p_preview.PictureName = is_fname
st_4.text = is_fname
st_5.text = String(FileSize(is_fname))
end event

type p_preview from picture within w_picture_set
integer x = 46
integer y = 304
integer width = 1294
integer height = 940
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type lb_types from listbox within w_picture_set
integer x = 1454
integer y = 872
integer width = 320
integer height = 332
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {""}
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_pfile, ls_key, ls_dir
this.enabled = FALSE
ls_key = this.text(index)
ls_pfile = compress_photo("photo_" + ls_key,"!" + ls_key + "_",is_fname,TRUE)
Yield()
IF FileExists(ls_pfile) THEN
	is_fname = ls_pfile
	//p_preview.PictureName = ls_pfile
	st_4.text = ls_pfile
	cb_6.visible = TRUE
	st_5.text = String(FileSize(is_fname))
	this.enabled = TRUE
END IF
end event

type cb_4 from commandbutton within w_picture_set
integer x = 1413
integer y = 1312
integer width = 407
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear Picture"
end type

event clicked;string ls_null
integer li_no
SetNull(ls_null)
i_ldw.setitem(ii_row,is_field,ls_null)
li_no = ue_check_field(i_ldw,"tabsketch")
IF li_no > 0 THEN i_ldw.setitem(ii_row,"tabsketch",ls_null)

	


end event

type st_3 from statictext within w_picture_set
integer x = 1413
integer y = 328
integer width = 69
integer height = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "%:"
boolean focusrectangle = false
end type

type em_perc from editmask within w_picture_set
integer x = 1591
integer y = 320
integer width = 146
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "100"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

event modified;decimal ll_perc
ll_perc = dec(this.text)

IF ll_perc > 10 THEN
	em_width.text = string(Round(ii_owidth * (ll_perc / 100),0))
	em_height.text = string(Round(ii_oheight * (ll_perc / 100),0))
END IF
end event

type cb_3 from commandbutton within w_picture_set
boolean visible = false
integer x = 750
integer y = 1308
integer width = 288
integer height = 76
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;close(w_picture_set)
end event

type cb_2 from commandbutton within w_picture_set
boolean visible = false
integer x = 1504
integer y = 516
integer width = 242
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Accept"
end type

event clicked;integer li_width, li_height, li_field
string ls_field2

ls_field2 = Right(is_field,len(is_field) - pos(is_field, "_"))
li_width = integer(em_width.text)
li_height = integer(em_height.text)

li_field = ue_check_field(i_ldw,"w_" + ls_field2)
IF li_field > 0 THEN
	i_ldw.setitem(ii_row,li_field,li_width)
	i_ldw.Modify(is_field + ".Width = '" + string(li_width) + "'")
	li_field = ue_check_field(i_ldw,"h_" + ls_field2)
	IF li_field > 0 THEN
		i_ldw.setitem(ii_row,li_field,li_height)
		i_ldw.Modify(is_field + ".Height = '" + string(li_height) + "'")
	END IF
END IF


end event

type cb_1 from commandbutton within w_picture_set
boolean visible = false
integer x = 1504
integer y = 436
integer width = 242
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset"
end type

event clicked;set_picture(i_ldw, ii_row, is_field, is_fname, ii_owidth, ii_oheight)

end event

type em_height from editmask within w_picture_set
integer x = 1591
integer y = 212
integer width = 210
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_width from editmask within w_picture_set
integer x = 1591
integer y = 100
integer width = 210
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_2 from statictext within w_picture_set
integer x = 1413
integer y = 216
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Height:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_picture_set
integer x = 1413
integer y = 104
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Width:"
boolean focusrectangle = false
end type

type p_test from picture within w_picture_set
boolean visible = false
integer x = 151
integer y = 1492
integer width = 987
integer height = 940
boolean enabled = false
boolean originalsize = true
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_picture_set
integer x = 1390
integer y = 20
integer width = 462
integer height = 744
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Size Options"
end type

type gb_2 from groupbox within w_picture_set
integer x = 1390
integer y = 800
integer width = 462
integer height = 712
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Other:"
end type

