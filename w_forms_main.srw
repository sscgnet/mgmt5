HA$PBExportHeader$w_forms_main.srw
forward
global type w_forms_main from window
end type
type mdi_1 from mdiclient within w_forms_main
end type
end forward

global type w_forms_main from window
integer width = 2533
integer height = 1752
boolean titlebar = true
string title = "Simple Forms"
string menuname = "menu_form_new"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdi!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "Form!"
boolean center = true
mdi_1 mdi_1
end type
global w_forms_main w_forms_main

type variables
w_forms_new i_active_sheet
end variables

on w_forms_main.create
if this.MenuName = "menu_form_new" then this.MenuID = create menu_form_new
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_forms_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;string docpath, docname, initdir, ls_audit
integer i, li_cnt, li_rtn, li_filenum
w_forms_new ld_sheet
ls_audit = message.stringparm
IF len(ls_audit) = 0 THEN
	initdir = ProfileString(gs_ini,"Forms","InitDir","")
	li_rtn = GetFileOpenName("Select File", docpath, docname, "MPZ","*.mpz",initdir)
	IF li_rtn = 0 THEN docpath = initdir
	SetProfileString(gs_ini,"Forms","InitDir",docpath)
	opensheetwithparm(ld_sheet,docpath,this,1,Original!)
ELSE
	opensheetwithparm(ld_sheet,ls_audit,this,1,Original!)
END IF
	
end event

type mdi_1 from mdiclient within w_forms_main
long BackColor=268435456
end type

