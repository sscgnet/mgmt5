HA$PBExportHeader$w_forms_special.srw
forward
global type w_forms_special from window
end type
type st_1 from statictext within w_forms_special
end type
type uo_location from uo_locations within w_forms_special
end type
type mle_2 from multilineedit within w_forms_special
end type
type mle_1 from multilineedit within w_forms_special
end type
end forward

global type w_forms_special from window
integer width = 2825
integer height = 1376
boolean titlebar = true
string title = "Special Instructions"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
event type boolean ue_open_file ( string ls_file )
st_1 st_1
uo_location uo_location
mle_2 mle_2
mle_1 mle_1
end type
global w_forms_special w_forms_special

on w_forms_special.create
this.st_1=create st_1
this.uo_location=create uo_location
this.mle_2=create mle_2
this.mle_1=create mle_1
this.Control[]={this.st_1,&
this.uo_location,&
this.mle_2,&
this.mle_1}
end on

on w_forms_special.destroy
destroy(this.st_1)
destroy(this.uo_location)
destroy(this.mle_2)
destroy(this.mle_1)
end on

event open;integer li_file, li_length, lpos, rpos, li = 0, lx
string ls_record, ls_special = "", ls_specmain = ""

li_file = FileOpen(w_forms_main.i_active_sheet.ls_cdir + "\special.mpf")
li_length = FileRead(li_file,ls_record)

DO WHILE li_length > 0
	IF pos(ls_record,"<SPECIAL") > 0 THEN 
		ls_record = Right(ls_Record,len(ls_Record) - 9)
		li = 1
	END IF
	IF pos(ls_record,"<SPECMAIN") > 0 THEN
		ls_record = Right(ls_Record,len(ls_Record) - 10)
		li = 2
	END IF
	IF li = 1 THEN ls_special += get_memo(ls_record)
	IF li = 2 THEN ls_specmain += get_memo(ls_record)
	li_length = FileRead(li_file,ls_record)
LOOP

FileClose(li_file)
IF len(ls_special) > 0 THEN mle_1.text = ls_special
IF len(ls_specmain) > 0 THEN mle_2.text = ls_specmain

IF NOT message.stringparm = "ABOUT" THEN
	IF li = 0 THEN close(w_forms_special)
END IF
end event

type st_1 from statictext within w_forms_special
integer x = 50
integer y = 1188
integer width = 1851
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
string text = "Note:  To copy information from instructions--right click on instruction."
boolean focusrectangle = false
end type

type uo_location from uo_locations within w_forms_special
integer x = 1422
integer y = 28
integer taborder = 10
end type

on uo_location.destroy
call uo_locations::destroy
end on

type mle_2 from multilineedit within w_forms_special
integer x = 32
integer y = 660
integer width = 1353
integer height = 512
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8421504
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;openwithparm(w_memo,"Special Instructions/" + mle_2.text)
end event

type mle_1 from multilineedit within w_forms_special
integer x = 32
integer y = 32
integer width = 1353
integer height = 580
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "None"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event rbuttondown;openwithparm(w_memo,"Special Instructions/" + mle_1.text)

end event

