HA$PBExportHeader$uo_locations.sru
forward
global type uo_locations from userobject
end type
type cb_6 from commandbutton within uo_locations
end type
type cb_1 from commandbutton within uo_locations
end type
type cbx_4 from checkbox within uo_locations
end type
type cbx_2 from checkbox within uo_locations
end type
type cb_2 from commandbutton within uo_locations
end type
type cb_3 from commandbutton within uo_locations
end type
type cb_4 from commandbutton within uo_locations
end type
type cb_5 from commandbutton within uo_locations
end type
type lb_building from listbox within uo_locations
end type
type st_1 from statictext within uo_locations
end type
type st_2 from statictext within uo_locations
end type
type cbx_1 from checkbox within uo_locations
end type
type lb_location from listbox within uo_locations
end type
end forward

global type uo_locations from userobject
integer width = 1339
integer height = 1148
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_6 cb_6
cb_1 cb_1
cbx_4 cbx_4
cbx_2 cbx_2
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
lb_building lb_building
st_1 st_1
st_2 st_2
cbx_1 cbx_1
lb_location lb_location
end type
global uo_locations uo_locations

forward prototypes
public function string get_name ()
public subroutine multiple (boolean lb_multiple)
public function string get_location ()
public function string get_building ()
end prototypes

public function string get_name ();string ls_locations = ""
integer li

IF cbx_4.checked THEN 	
	FOR li = 1 to lb_building.totalitems()
		IF lb_building.state(li) = 1 THEN
			ls_locations += "[" + lb_location.selecteditem() + ":" + lb_building.text(li) + "]"
		END IF
	NEXT
	RETURN ls_locations
END IF
IF cbx_2.checked THEN 
	FOR li = 1 to lb_location.totalitems()
		IF lb_location.state(li) = 1 THEN
			ls_locations += "[" + lb_location.text(li) + "]"
		END IF
	NEXT
	RETURN ls_locations
END IF
RETURN ""

end function

public subroutine multiple (boolean lb_multiple);cbx_1.enabled = lb_multiple
end subroutine

public function string get_location ();IF cbx_2.checked THEN 	RETURN lb_location.selecteditem() 
RETURN ""

end function

public function string get_building ();IF cbx_4.checked THEN RETURN lb_building.selecteditem()
RETURN ""

end function

on uo_locations.create
this.cb_6=create cb_6
this.cb_1=create cb_1
this.cbx_4=create cbx_4
this.cbx_2=create cbx_2
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.lb_building=create lb_building
this.st_1=create st_1
this.st_2=create st_2
this.cbx_1=create cbx_1
this.lb_location=create lb_location
this.Control[]={this.cb_6,&
this.cb_1,&
this.cbx_4,&
this.cbx_2,&
this.cb_2,&
this.cb_3,&
this.cb_4,&
this.cb_5,&
this.lb_building,&
this.st_1,&
this.st_2,&
this.cbx_1,&
this.lb_location}
end on

on uo_locations.destroy
destroy(this.cb_6)
destroy(this.cb_1)
destroy(this.cbx_4)
destroy(this.cbx_2)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.lb_building)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.lb_location)
end on

type cb_6 from commandbutton within uo_locations
integer x = 891
integer y = 992
integer width = 421
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Select All"
end type

event clicked;Integer li
Boolean lb_set = FALSE
IF this.text = "Select All" THEN 
	lb_set = TRUE
	this.text = "DeSelect All"
ELSE
	this.text = "Select All"
END IF
FOR li = 1 to lb_building.totalitems()
	lb_building.SetState(li,lb_set)
NEXT
end event

type cb_1 from commandbutton within uo_locations
integer x = 896
integer y = 516
integer width = 421
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Select All"
end type

event clicked;Integer li
Boolean lb_set = FALSE
IF this.text = "Select All" THEN 
	lb_set = TRUE
	this.text = "DeSelect All"
ELSE
	this.text = "Select All"
END IF
FOR li = 1 to lb_location.totalitems()
	lb_location.SetState(li,lb_set)
NEXT
end event

type cbx_4 from checkbox within uo_locations
integer x = 18
integer y = 644
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type cbx_2 from checkbox within uo_locations
integer x = 18
integer y = 24
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_2 from commandbutton within uo_locations
integer x = 896
integer y = 108
integer width = 421
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add location"
end type

event clicked;string ls_answer

openwithparm(w_ask,"Enter New Location")
ls_answer = Left(message.stringparm,20)
if ls_answer <> "" then 
	lb_location.additem(ls_answer)
	w_forms_main.i_active_sheet.ib_changed = TRUE
	w_forms_main.i_active_sheet.ls_location[upperbound(w_forms_main.i_active_sheet.ls_location) + 1] = ls_answer
	w_forms_main.i_active_sheet.ls_building[upperbound(w_forms_main.i_active_sheet.ls_building) + 1] = "<NONE>"
end if

end event

type cb_3 from commandbutton within uo_locations
integer x = 896
integer y = 228
integer width = 421
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete Location"
end type

event clicked;Integer lx
FOR lx = 1 to Upperbound(w_forms_main.i_active_sheet.ls_location)
	IF w_forms_main.i_active_sheet.ls_location[lx] = lb_location.selecteditem() THEN
		w_forms_main.i_active_sheet.ls_location[lx] = "<DELETED>"
	END IF
NEXT

cbx_1.checked = FALSE
lb_location.deleteitem(lb_location.selectedindex())
cb_3.enabled = FALSE
cb_4.enabled = FALSE
cb_5.enabled = FALSE
w_forms_main.i_active_sheet.ib_changed = TRUE
cbx_2.checked = FALSE




end event

type cb_4 from commandbutton within uo_locations
integer x = 896
integer y = 752
integer width = 421
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Add Building"
end type

event clicked;string ls_answer
integer lx, li_found

openwithparm(w_ask,"Enter New Building")
ls_answer = Left(message.stringparm,20)
if ls_answer <> "" then 
	FOR lx = 1 to lb_building.totalitems()
		IF lb_building.text(lx) = "<NONE>" THEN li_found = lx
	NEXT
	IF li_found > 0 THEN 	
		lb_building.deleteitem(li_found)
		FOR lx = 1 to Upperbound(w_forms_main.i_active_sheet.ls_location)
			IF w_forms_main.i_active_sheet.ls_location[lx] = lb_location.selecteditem() AND &
				w_forms_main.i_active_sheet.ls_building[lx] = "<NONE>" THEN
					w_forms_main.i_active_sheet.ls_building[lx] = ls_answer
			END IF
		NEXT
	ELSE
		w_forms_main.i_active_sheet.ls_building[upperbound(w_forms_main.i_active_sheet.ls_building) + 1] = ls_answer
		w_forms_main.i_active_sheet.ls_location[upperbound(w_forms_main.i_active_sheet.ls_location) + 1] = lb_location.selecteditem()
	END IF
	lb_building.additem(ls_answer)
	w_forms_main.i_active_sheet.ib_changed = TRUE
end if

end event

type cb_5 from commandbutton within uo_locations
integer x = 896
integer y = 872
integer width = 421
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete Building"
end type

event clicked;//cbx_3.checked = FALSE
Integer lx
FOR lx = 1 to Upperbound(w_forms_main.i_active_sheet.ls_building)
	IF w_forms_main.i_active_sheet.ls_building[lx] = lb_building.selecteditem() THEN
		w_forms_main.i_active_sheet.ls_location[lx] = "<DELETED>"
	END IF
NEXT

this.enabled = FALSE
lb_building.deleteitem(lb_building.selectedindex())
w_forms_main.i_active_sheet.ib_changed = TRUE
cbx_4.checked = FALSE

end event

type lb_building from listbox within uo_locations
integer x = 18
integer y = 744
integer width = 832
integer height = 340
integer taborder = 20
boolean bringtotop = true
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

event selectionchanged;cb_5.enabled = TRUE
cbx_4.checked = TRUE
end event

type st_1 from statictext within uo_locations
integer x = 91
integer y = 652
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Building:"
boolean focusrectangle = false
end type

type st_2 from statictext within uo_locations
integer x = 91
integer y = 28
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Location:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within uo_locations
integer x = 1029
integer y = 16
integer width = 288
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Multiple"
boolean lefttext = true
end type

event clicked;integer li_item
IF this.checked THEN
	li_item = lb_location.selectedindex()
	cb_1.enabled = TRUE
	cb_6.enabled = TRUE
	cb_2.enabled = FALSE
	cb_3.enabled = FALSE
	cb_4.enabled = FALSE
	cb_5.enabled = FALSE
	lb_building.MultiSelect = TRUE
	lb_location.MultiSelect = TRUE
	IF li_item > 0 THEN
		cbx_2.checked = TRUE
		lb_location.SetState(li_item,TRUE)
	END IF
ELSE
	cb_1.enabled = FALSE
	cb_6.enabled = FALSE
	cb_2.enabled = TRUE
	cb_3.enabled = TRUE
	cb_4.enabled = TRUE
	cb_5.enabled = TRUE
	lb_building.MultiSelect = FALSE
	lb_location.MultiSelect = FALSE
END IF
end event

type lb_location from listbox within uo_locations
event clicked pbm_bnclicked
integer x = 18
integer y = 116
integer width = 832
integer height = 504
integer taborder = 10
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

event selectionchanged;Integer li
lb_building.reset()
IF NOT cbx_1.checked THEN
	FOR li = 1 to Upperbound(w_forms_main.i_active_sheet.ls_location)
		IF w_forms_main.i_active_sheet.ls_location[li ] = this.text(index) THEN
			IF w_forms_main.i_active_sheet.ls_building[li] <> "<DELETED>" THEN
				lb_building.additem(w_forms_main.i_active_sheet.ls_building[li])
			END IF
		END IF
	NEXT
	cb_4.enabled = TRUE
	cb_3.enabled = TRUE
END IF
cbx_2.checked = TRUE


end event

