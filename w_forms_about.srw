HA$PBExportHeader$w_forms_about.srw
forward
global type w_forms_about from window
end type
type cbx_4 from checkbox within w_forms_about
end type
type cbx_3 from checkbox within w_forms_about
end type
type cbx_2 from checkbox within w_forms_about
end type
type mle_1 from multilineedit within w_forms_about
end type
type cbx_1 from checkbox within w_forms_about
end type
type cb_1 from commandbutton within w_forms_about
end type
type st_4 from statictext within w_forms_about
end type
type st_3 from statictext within w_forms_about
end type
type st_2 from statictext within w_forms_about
end type
type st_1 from statictext within w_forms_about
end type
type p_1 from picture within w_forms_about
end type
end forward

global type w_forms_about from window
integer width = 2405
integer height = 1724
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_4 cbx_4
cbx_3 cbx_3
cbx_2 cbx_2
mle_1 mle_1
cbx_1 cbx_1
cb_1 cb_1
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
p_1 p_1
end type
global w_forms_about w_forms_about

on w_forms_about.create
this.cbx_4=create cbx_4
this.cbx_3=create cbx_3
this.cbx_2=create cbx_2
this.mle_1=create mle_1
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.p_1=create p_1
this.Control[]={this.cbx_4,&
this.cbx_3,&
this.cbx_2,&
this.mle_1,&
this.cbx_1,&
this.cb_1,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.p_1}
end on

on w_forms_about.destroy
destroy(this.cbx_4)
destroy(this.cbx_3)
destroy(this.cbx_2)
destroy(this.mle_1)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_1)
end on

event open;mle_1.text = w_forms_main.i_active_sheet.ls_form + "~r~n" + w_forms_main.i_active_sheet.ls_library + "~r~nPDFTYPE:  " + w_forms_main.i_active_sheet.ls_pdftype + &
	"~r~nFormsINI:  " + w_forms_main.i_active_sheet.is_formini
end event

type cbx_4 from checkbox within w_forms_about
integer x = 73
integer y = 1312
integer width = 352
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "All"
end type

event clicked;IF this.checked THEN
	SetProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FORMALL","YES")
ELSE
	SetProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FORMALL","NO")
END IF

end event

event constructor;IF ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FormAll","NO") = "YES" THEN
	this.checked = TRUE
ELSE
	this.checked = FALSE
END IF

end event

type cbx_3 from checkbox within w_forms_about
integer x = 78
integer y = 1416
integer width = 352
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Combine"
end type

event clicked;IF this.checked THEN
	SetProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FORMHEADER","YES")
ELSE
	SetProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FORMHEADER","NO")
END IF

end event

event constructor;IF ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FormHeader","NO") = "YES" THEN
	this.checked = TRUE
ELSE
	this.checked = FALSE
END IF

end event

type cbx_2 from checkbox within w_forms_about
integer x = 78
integer y = 1516
integer width = 352
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Choices"
end type

event clicked;IF this.checked THEN
	SetProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"Choices","YES")
//	w_forms_main.i_active_sheet.lb_update_mfz = TRUE
ELSE
	SetProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"Choices","NO")
//	w_forms_main.i_active_sheet.lb_update_mfz = FALSE
END IF

end event

event constructor;IF ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"Choices","YES") = "YES" THEN
	this.checked = TRUE
ELSE
	this.checked = FALSE
END IF

end event

type mle_1 from multilineedit within w_forms_about
integer x = 677
integer y = 944
integer width = 1147
integer height = 328
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean enabled = false
boolean border = false
alignment alignment = center!
end type

type cbx_1 from checkbox within w_forms_about
integer x = 1792
integer y = 68
integer width = 498
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16776960
string text = "Update Form"
end type

event clicked;IF this.checked THEN
	SetProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form,"Update","Yes")
	SetProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form,"PUpdate","YES")
//	Integer li
//	FOR li = 1 to 5
//		IF ProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form + string(li),"Form","") <> "" THEN
//			SetProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form + string(li),"Form","")
//			SetProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form + string(li),"CVersion5","")
//			SetProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form + string(li),"Version","")
//		END IF
//	NEXT
//	w_forms_main.i_active_sheet.lb_update_mfz = TRUE
ELSE
	SetProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form,"Update","No")
	SetProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form,"PUpdate","No")
//	w_forms_main.i_active_sheet.lb_update_mfz = FALSE
END IF

end event

event constructor;IF ProfileString(gs_ini,w_forms_main.i_active_sheet.ls_form,"Update","No") = "Yes" THEN
	this.checked = TRUE
ELSE
	this.checked = FALSE
END IF

end event

type cb_1 from commandbutton within w_forms_about
integer x = 1033
integer y = 756
integer width = 311
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;close(w_forms_about)
end event

type st_4 from statictext within w_forms_about
integer x = 777
integer y = 584
integer width = 649
integer height = 72
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Version:"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;this.text = "Version:  " + gi_version

end event

type st_3 from statictext within w_forms_about
integer x = 677
integer y = 1432
integer width = 1147
integer height = 68
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = script!
string facename = "Script MT Bold"
long textcolor = 33554432
long backcolor = 134217752
string text = "@2006 SSCG.Net by Sue Brown"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_forms_about
integer x = 393
integer y = 288
integer width = 800
integer height = 128
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Form Generator"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_forms_about
integer x = 128
integer y = 124
integer width = 576
integer height = 120
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "SSCG.Net"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type p_1 from picture within w_forms_about
integer x = 5
integer y = 24
integer width = 2350
integer height = 1624
string picturename = "C:\Documents and Settings\All Users\Documents\My Pictures\Sample Pictures\Blue hills.jpg"
boolean focusrectangle = false
end type

