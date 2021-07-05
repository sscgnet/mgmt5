HA$PBExportHeader$w_picture_set_new.srw
forward
global type w_picture_set_new from window
end type
type cb_7 from commandbutton within w_picture_set_new
end type
type cb_6 from commandbutton within w_picture_set_new
end type
type p_picture from picture within w_picture_set_new
end type
type cb_5 from commandbutton within w_picture_set_new
end type
type cb_4 from commandbutton within w_picture_set_new
end type
type st_3 from statictext within w_picture_set_new
end type
type em_perc from editmask within w_picture_set_new
end type
type cb_3 from commandbutton within w_picture_set_new
end type
type cb_2 from commandbutton within w_picture_set_new
end type
type cb_1 from commandbutton within w_picture_set_new
end type
type em_height from editmask within w_picture_set_new
end type
type em_width from editmask within w_picture_set_new
end type
type st_2 from statictext within w_picture_set_new
end type
type st_1 from statictext within w_picture_set_new
end type
type p_test from picture within w_picture_set_new
end type
end forward

global type w_picture_set_new from window
integer width = 2075
integer height = 1688
boolean titlebar = true
string title = "Setting Picture Size...."
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_7 cb_7
cb_6 cb_6
p_picture p_picture
cb_5 cb_5
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
end type
global w_picture_set_new w_picture_set_new

type variables
datawindow i_ldw
string is_field, is_fname, is_cname
integer ii_owidth, ii_oheight, ii_row
boolean lb_reset = FALSE
end variables

forward prototypes
public function string set_picture (datawindow ldw, integer li_row, string ls_field, string ls_fname, integer li_owidth, integer li_oheight)
public function integer ue_check_field (datawindow ldw, string ls_field)
public subroutine set_defaults (datawindow ldw, integer li_row, string ls_field, string ls_fname, integer li_owidth, integer li_oheight)
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

public subroutine set_defaults (datawindow ldw, integer li_row, string ls_field, string ls_fname, integer li_owidth, integer li_oheight);string ls_field2
integer li_field

i_ldw = ldw
is_field = ls_field
is_fname = ls_fname
ii_owidth = li_owidth
p_picture.PictureName = ls_fname
p_picture.Width = li_owidth
p_picture.Height = li_oheight

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

on w_picture_set_new.create
this.cb_7=create cb_7
this.cb_6=create cb_6
this.p_picture=create p_picture
this.cb_5=create cb_5
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
this.Control[]={this.cb_7,&
this.cb_6,&
this.p_picture,&
this.cb_5,&
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
this.p_test}
end on

on w_picture_set_new.destroy
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.p_picture)
destroy(this.cb_5)
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
end on

type cb_7 from commandbutton within w_picture_set_new
integer x = 64
integer y = 1392
integer width = 485
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Preview Options"
end type

event clicked;string ls_emp, ls_exe, ls_new, ls_log, ls_options, ls_message, ls_emage
integer li_fnum

ls_emage = get_dir("Temp","") + "emage\"
CreateDirectory(ls_emage)
ls_emp = ls_emage + "default.emp"
ls_new = ls_emage + "image001.jpg"

FileDelete(ls_emp)
FileDelete(ls_new)
li_fnum = FileOpen(ls_emp,LineMode!,Write!)


FileWrite(li_fnum, "emp_1.0")
FileWrite(li_fnum,"AutoSort None;")
FileWrite(li_fnum,"JPEG yuv411 90 90 20 30720;")
FileWrite(li_fnum,"GIF -dithering 256;")
FileWrite(li_fnum,"BMP -dithering 256;")
FileWrite(li_fnum, "SaveTo JPEG;")
FileWrite(li_Fnum,"Comment ~"Written by E-mage Processor~";")
FileWrite(li_fnum,"Name image:1.1.3:;")
FileWrite(li_fnum,"Rotate 90")

FileClose(li_fnum)

ls_exe = set_ini("Location of Emage Processor","EMAGE","CMD","C:\Program Files\E-Mage Processor\empc.exe",FALSE)
ls_log = set_ini("Location of Emage Log","EMAGE","LOG","c:\minipro\emagelog.txt",FALSE)

ls_options = "-L:" + ls_log + " -Overwrite -D:"
ls_message = "~"" + ls_exe + "~" " + ls_emp + " ~"" + is_fname + "~" " + ls_options + "~"" + ls_emage + "~""

Run(ls_message,Minimized!)

DO UNTIL FileExists(ls_message)
	Yield()
LOOP
p_picture.PictureName = ls_new
//p_picture.
end event

event constructor;IF	ProfileString(gs_ini,"MAIN","JPEG","") = "EMAGE" THEN this.enabled =TRUE

end event

type cb_6 from commandbutton within w_picture_set_new
integer x = 69
integer y = 1256
integer width = 434
integer height = 64
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Flip Horizontal"
end type

type p_picture from picture within w_picture_set_new
integer x = 18
integer y = 24
integer width = 1330
integer height = 1180
boolean focusrectangle = false
end type

event constructor;//p_picture.PictureName = ls_fname
end event

type cb_5 from commandbutton within w_picture_set_new
integer x = 1381
integer y = 1312
integer width = 603
integer height = 84
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Picture"
end type

event clicked;String pathname,filename
integer li_no

IF ISNULL(is_cname) THEN 
	Messagebox("Picture Set","No new name specified")
	RETURN
END IF

GetFileOpenName ( "Location of Picture", pathname, filename, "JPG", &
	"JPEG files (*.JPG), *.JPG, *.BMP, Bitmap files (*.RLE), *.RLE," + &
	"Windows Metafiles (*.WMF), *.WMF, Bitmap files (*.BMP), *.BMP," + &
	"GIF Files (*.gif), *.gif",get_pathname(is_cname))

IF FileExists(pathname) THEN
	//IF pos(is_cname,".") = 0 THEN
	is_cname += Right(pathname,4)
	IF pathname <> is_cname THEN
		FileCopy(pathname, is_cname,TRUE)
	END IF
	i_ldw.setitem(ii_row,is_field,is_cname)
	li_no = ue_check_field(i_ldw,"tabsketch")
	IF li_no > 0 THEN i_ldw.setitem(ii_row,"tabsketch",Left(is_cname,len(is_cname) -4) + ".rs")
	//Messagebox(pathname, ls_cname)
END IF


end event

type cb_4 from commandbutton within w_picture_set_new
integer x = 1381
integer y = 1212
integer width = 603
integer height = 84
integer taborder = 40
integer textsize = -10
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

type st_3 from statictext within w_picture_set_new
integer x = 1417
integer y = 860
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

type em_perc from editmask within w_picture_set_new
integer x = 1490
integer y = 852
integer width = 146
integer height = 88
integer taborder = 30
integer textsize = -10
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

type cb_3 from commandbutton within w_picture_set_new
boolean visible = false
integer x = 1408
integer y = 1420
integer width = 562
integer height = 92
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

type cb_2 from commandbutton within w_picture_set_new
boolean visible = false
integer x = 1691
integer y = 1096
integer width = 233
integer height = 92
integer taborder = 20
integer textsize = -10
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

type cb_1 from commandbutton within w_picture_set_new
boolean visible = false
integer x = 1413
integer y = 1096
integer width = 265
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset"
end type

event clicked;set_picture(i_ldw, ii_row, is_field, is_fname, ii_owidth, ii_oheight)

end event

type em_height from editmask within w_picture_set_new
integer x = 1600
integer y = 740
integer width = 210
integer height = 88
integer taborder = 20
integer textsize = -10
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

type em_width from editmask within w_picture_set_new
integer x = 1600
integer y = 616
integer width = 210
integer height = 88
integer taborder = 10
integer textsize = -10
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

type st_2 from statictext within w_picture_set_new
integer x = 1394
integer y = 744
integer width = 210
integer height = 64
integer textsize = -10
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

type st_1 from statictext within w_picture_set_new
integer x = 1390
integer y = 624
integer width = 210
integer height = 64
integer textsize = -10
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

type p_test from picture within w_picture_set_new
integer x = 626
integer y = 616
integer width = 302
integer height = 260
boolean originalsize = true
boolean focusrectangle = false
end type

