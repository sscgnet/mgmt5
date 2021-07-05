HA$PBExportHeader$w_forms_web.srw
forward
global type w_forms_web from window
end type
type uo_forms from uo_forms_sheet within w_forms_web
end type
end forward

global type w_forms_web from window
integer width = 2889
integer height = 2452
boolean titlebar = true
string title = "Web Forms"
string menuname = "menu_form_web"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
windowstate windowstate = minimized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_open_form ( string ls_form,  long ll_control,  long li_id,  string ls_ptype )
event type boolean ue_web_connect ( )
event ue_web_disconnect ( )
event ue_save ( boolean lb_quit )
event ue_print ( boolean lb_close )
event ue_add_user ( string ls_user,  string ls_password,  string ls_formname )
event ue_printjob ( boolean lb_close,  long ll_job )
uo_forms uo_forms
end type
global w_forms_web w_forms_web

type variables
string ls_error, is_formname
transaction source
boolean lb_aimport, lb_wconnect = FALSE
end variables

event ue_open_form(string ls_form, long ll_control, long li_id, string ls_ptype);uo_forms.ls_formname = ls_form
ls_error = uo_forms.trigger event ue_setup(ls_form,ls_ptype + "_", ll_control, 0, source) 
IF ls_error <> "SUCCESS" THEN
	Messagebox("ERROR",ls_error)
	RETURN
END IF

end event

event type boolean ue_web_connect();string ls_dsn

IF lb_wconnect THEN RETURN TRUE
ls_dsn = set_ini("Enter Web DSN Name","WEB","DSN","mini-sql",FALSE)

source = CREATE transaction
source.DBMS = "ODBC"
source.dbparm = "Connectstring='DSN=" + ls_dsn

CONNECT USING source;

IF source.sqlcode <> 0 THEN
	RETURN FALSE
END IF
lb_wconnect = TRUE
RETURN TRUE
end event

event ue_web_disconnect();IF lb_wconnect THEN 
	DISCONNECT USING source;
END IF


end event

event ue_save(boolean lb_quit);uo_forms.dw_defaultw.trigger event ue_update()
COMMIT USING source;

IF lb_quit THEN close(w_forms_web)

end event

event ue_print(boolean lb_close);long ll_job
ll_job = PrintOpen("Form " + is_formname)

uo_forms.dw_report.trigger event ue_print_web(ll_job)

PrintClose(ll_job)

IF lb_close THEN close(w_forms_web)

end event

event ue_add_user(string ls_user, string ls_password, string ls_formname);string ls_test, ls_final
  SELECT users.Password  
    INTO :ls_test  
    FROM users  
   WHERE users.Username = :ls_user   USING source;

IF source.sqlcode = 0 THEN
	  DELETE FROM users  
   WHERE users.Username = :ls_user   USING source ;
END IF

  INSERT INTO users  
         ( Username,   
           Password,   
           repid,   
           recno,   
           rights,   
           formid)  
  VALUES ( :ls_user,   
           :ls_password,   
           0,   
           0,   
           6,   
           :ls_formname) USING source ;
get_source("Insert new User",source)

long ll_control
String ls_attach, ls_form
ll_control = long(ls_password)
ls_attach = ls_password + "_" + ls_formname + "01"

ls_final = ls_formname + "_final"
SELECT cform INTO :ls_test FROM custforms WHERE cform = :ls_final;

IF sqlca.sqlcode = 0 THEN ls_formname = ls_final
ls_form = "[" + ls_formname + "]"

SELECT casedir INTO :ls_test FROM caseattach 
	WHERE control = :ll_control AND caseattach = :ls_attach USING source;

IF source.sqlcode = 100 THEN
	
  INSERT INTO caseattach  
         ( control,   
           caseattach,   
           casedir,   
           ediflag )  
  VALUES ( :ll_control,   
           :ls_attach,   
           :ls_form,   
           99 )  USING source;

    get_source("Insert attachment",source)
ELSE
	UPDATE caseattach SET casedir = :ls_form 
		WHERE control = :ll_control AND caseattach = :ls_attach USING source;
	get_source("Update attachment",source)
END IF

COMMIT USING source;
end event

event ue_printjob(boolean lb_close, long ll_job);//long ll_job
//ll_job = PrintOpen("Form " + is_formname)

uo_forms.dw_report.trigger event ue_print_web(ll_job)

//PrintClose(ll_job)

IF lb_close THEN close(w_forms_web)

end event

on w_forms_web.create
if this.MenuName = "menu_form_web" then this.MenuID = create menu_form_web
this.uo_forms=create uo_forms
this.Control[]={this.uo_forms}
end on

on w_forms_web.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_forms)
end on

event close;IF lb_wconnect THEN
	DISCONNECT USING source;
END IF
end event

event resize;uo_forms.height = &
		(this.height - uo_forms.y) - 500
uo_forms.width = &
		(this.width - uo_forms.x) - 150

uo_forms.dw_defaultw.height = &
		(this.height - uo_forms.dw_defaultw.y) - 500
uo_forms.dw_defaultw.width = &
		(this.width - uo_forms.dw_defaultw.x) - 150

end event

type uo_forms from uo_forms_sheet within w_forms_web
integer x = 73
integer y = 64
integer height = 2144
integer taborder = 40
end type

on uo_forms.destroy
call uo_forms_sheet::destroy
end on

