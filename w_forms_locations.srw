HA$PBExportHeader$w_forms_locations.srw
forward
global type w_forms_locations from window
end type
type cb_2 from commandbutton within w_forms_locations
end type
type cb_1 from commandbutton within w_forms_locations
end type
type uo_1 from uo_locations within w_forms_locations
end type
end forward

global type w_forms_locations from window
integer width = 1454
integer height = 1456
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
cb_2 cb_2
cb_1 cb_1
uo_1 uo_1
end type
global w_forms_locations w_forms_locations

on w_forms_locations.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_1=create uo_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.uo_1}
end on

on w_forms_locations.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_1)
end on

event open;uo_1.multiple(TRUE)
end event

type cb_2 from commandbutton within w_forms_locations
integer x = 795
integer y = 1196
integer width = 434
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;close(w_forms_locations)

end event

type cb_1 from commandbutton within w_forms_locations
integer x = 183
integer y = 1196
integer width = 434
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Locations"
end type

event clicked;closewithreturn(w_forms_locations,uo_1.get_name())
end event

type uo_1 from uo_locations within w_forms_locations
integer x = 23
integer y = 16
integer taborder = 10
end type

on uo_1.destroy
call uo_locations::destroy
end on

