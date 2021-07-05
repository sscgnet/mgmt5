HA$PBExportHeader$w_load_picture.srw
forward
global type w_load_picture from window
end type
type cb_3 from commandbutton within w_load_picture
end type
type rb_lock from radiobutton within w_load_picture
end type
type st_2 from statictext within w_load_picture
end type
type em_height from editmask within w_load_picture
end type
type em_width from editmask within w_load_picture
end type
type st_1 from statictext within w_load_picture
end type
type st_name from statictext within w_load_picture
end type
type p_picture from picture within w_load_picture
end type
type cb_2 from commandbutton within w_load_picture
end type
type cb_1 from commandbutton within w_load_picture
end type
end forward

global type w_load_picture from window
integer width = 2633
integer height = 2008
boolean titlebar = true
string title = "Picture Loading"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_setup ( string ls_name )
cb_3 cb_3
rb_lock rb_lock
st_2 st_2
em_height em_height
em_width em_width
st_1 st_1
st_name st_name
p_picture p_picture
cb_2 cb_2
cb_1 cb_1
end type
global w_load_picture w_load_picture

type variables
uo_datawindow ldw
String ls_cname, ls_field
Integer li_row, li_awidth, li_aheight, li_owidth, li_oheight
Decimal ld_perc = 1


end variables

event ue_setup(string ls_name);st_name.text = ls_name
p_picture.PictureName = ls_name




end event

on w_load_picture.create
this.cb_3=create cb_3
this.rb_lock=create rb_lock
this.st_2=create st_2
this.em_height=create em_height
this.em_width=create em_width
this.st_1=create st_1
this.st_name=create st_name
this.p_picture=create p_picture
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.cb_3,&
this.rb_lock,&
this.st_2,&
this.em_height,&
this.em_width,&
this.st_1,&
this.st_name,&
this.p_picture,&
this.cb_2,&
this.cb_1}
end on

on w_load_picture.destroy
destroy(this.cb_3)
destroy(this.rb_lock)
destroy(this.st_2)
destroy(this.em_height)
destroy(this.em_width)
destroy(this.st_1)
destroy(this.st_name)
destroy(this.p_picture)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;st_name.text = message.stringparm
p_picture.PictureName = message.stringparm
end event

type cb_3 from commandbutton within w_load_picture
integer x = 2263
integer y = 28
integer width = 293
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Restore"
end type

event clicked;integer li_height

ld_perc = li_owidth/li_awidth
li_height = Round(li_aheight * ld_perc,0)

p_picture.Width = li_owidth
p_picture.Height = li_height

em_width.text = string(li_owidth)
em_height.text = string(li_height)

end event

type rb_lock from radiobutton within w_load_picture
integer x = 2235
integer y = 136
integer width = 366
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lock Ratio"
boolean checked = true
end type

type st_2 from statictext within w_load_picture
integer x = 1728
integer y = 132
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

type em_height from editmask within w_load_picture
integer x = 1943
integer y = 140
integer width = 283
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
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
end type

event modified;integer li_width, li_height
li_height = integer(this.text)
p_picture.height = integer(this.text)
IF rb_lock.checked THEN
	ld_perc = li_height/li_aheight
	li_width = Round(li_awidth * ld_perc,0)
	em_width.text = string(li_width)
	p_picture.width = li_width
END IF
end event

type em_width from editmask within w_load_picture
integer x = 1943
integer y = 32
integer width = 283
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
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
end type

event modified;integer li_width, li_height
li_width = integer(this.text)
p_picture.width = integer(this.text)
IF rb_lock.checked THEN
	ld_perc = li_width/li_awidth
	li_height = Round(li_aheight * ld_perc,0)
	em_height.text = string(li_height)
	p_picture.height = li_height
END IF
end event

type st_1 from statictext within w_load_picture
integer x = 1728
integer y = 44
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

type st_name from statictext within w_load_picture
integer x = 457
integer y = 44
integer width = 1262
integer height = 160
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

type p_picture from picture within w_load_picture
integer x = 23
integer y = 240
integer width = 2528
integer height = 1588
boolean originalsize = true
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_load_picture
integer x = 14
integer y = 132
integer width = 402
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save Picture"
end type

event clicked;//ls_photo = this.trigger event ue_copypicture("",ls_new)
	//IF filesize(ls_photo) > ll_size THEN
			//Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
	//ELSEs
string pathname, filename
integer li_width, li_height
IF Integer(em_height.text) > li_oheight THEN	
	Messagebox("Picture","The height of this picture has been adjusted.")
	em_height.text = string(li_oheight)
END IF
IF Integer(em_width.text) > li_owidth THEN 
	Messagebox("Picture","The width of this picture has been adjusted.")
	em_width.text = string(li_owidth)
END IF

pathname = st_name.text
filename = get_filename(pathname)
IF FileExists(pathname) THEN
	ls_cname += Right(filename, 4)
	FileCopy(pathname, ls_cname,TRUE)
	//Messagebox(pathname, ls_cname)
	ldw.setitem(li_row,ls_field,ls_cname)
	//li_width = Integer(ldw.Describe(ls_field + ".Width"))
	//If li_awidth > li_width THEN
		//ld_perc = li_width/li_awidth
		//li_height = Round(li_aheight * ld_perc,0)
		ldw.Modify(ls_field + ".Height = '" + em_height.text + "'")
		ldw.Modify(ls_field + ".Width = '" + em_width.text + "'")
	//END IF
	//this.accepttext()
END IF


end event

type cb_1 from commandbutton within w_load_picture
integer x = 14
integer y = 36
integer width = 402
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get Picture"
end type

event clicked;string ls_photo, ls_new, ls_path
long ll_size
integer li_width, li_height

ll_size = long(ProfileString(gs_ini,"MAIN","PhotoSize","100")) * 1000
li_owidth = Integer(ldw.Describe(ls_field + ".Width"))
li_oheight = Integer(ldw.Describe(ls_field + ".Height"))

String pathname,filename

GetFileOpenName ( "Location of Picture", pathname, filename, "JPG", &
	"JPEG files (*.JPG), *.JPG, *.BMP, Bitmap files (*.RLE), *.RLE," + &
	"Windows Metafiles (*.WMF), *.WMF, Bitmap files (*.BMP), *.BMP," + &
	"GIF Files (*.gif), *.gif",ls_path)

IF FileExists(pathname) THEN
	st_name.text = pathname
	p_picture.PictureName = pathname
	li_awidth = p_picture.Width
	li_aheight = p_picture.Height
	
	If li_awidth > 2418 THEN
		li_width = li_owidth
		ld_perc = li_width/li_awidth
		li_height = Round(li_aheight * ld_perc,0)
		//li_width = 2418
		p_picture.OriginalSize = FALSE
		p_picture.Width = li_width
		p_picture.Height = li_height
		li_oheight = li_height
	ELSE
		li_width = li_awidth
		li_height = li_aheight
	END IF
	em_width.text = String(li_width)
	em_height.text = String(li_height)
END IF


end event

