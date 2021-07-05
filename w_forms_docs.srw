HA$PBExportHeader$w_forms_docs.srw
forward
global type w_forms_docs from window
end type
type lb_2 from listbox within w_forms_docs
end type
type lb_1 from listbox within w_forms_docs
end type
end forward

global type w_forms_docs from window
integer width = 1280
integer height = 1160
boolean titlebar = true
string title = "Forms Documents"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
lb_2 lb_2
lb_1 lb_1
end type
global w_forms_docs w_forms_docs

type variables
string ls_templates
end variables

on w_forms_docs.create
this.lb_2=create lb_2
this.lb_1=create lb_1
this.Control[]={this.lb_2,&
this.lb_1}
end on

on w_forms_docs.destroy
destroy(this.lb_2)
destroy(this.lb_1)
end on

event open;IF Message.stringparm = "" THEN
	lb_1.DirList(get_pathname(w_forms_main.i_active_sheet.ls_filename),16)
ELSE
	ls_templates = Profilestring(gs_ini,"Main","Templates","")
	ls_templates += "\sscgforms"
	lb_2.DirList(ls_templates,0)
	lb_2.visible = TRUE
END IF
end event

type lb_2 from listbox within w_forms_docs
boolean visible = false
integer x = 32
integer y = 16
integer width = 1207
integer height = 988
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_dir, ls_exe, ls_version, ls_fname, ls_loadname

ls_dir = ls_templates + "\" +  this.text(index)
ls_fname = Left(this.text(index), len(this.text(index)) - 4)
openwithparm(w_simplezip,ls_dir)
w_simplezip.ue_unzipall(ls_dir,"")
ls_exe = get_dwsyntax(w_simplezip.ue_finddir() + "form.txt")
ls_version = get_dwsyntax(w_simplezip.ue_finddir() + "version.txt")
w_simplezip.deleteall(FALSE,TRUE)
close(w_simplezip)
SetProfileString(gs_ini,ls_fname,"Load",ls_fname)

Messagebox("Form Info","Located at " + ls_dir + "~r~nVersion#:  " + ls_version + "~r~nForm:  "  + ls_exe)

	

end event

type lb_1 from listbox within w_forms_docs
integer x = 32
integer y = 12
integer width = 1207
integer height = 992
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;string ls_item, ls_fname, ls_dpath, ls_fpos = ""
integer li_tab, li, li_stop = 4
boolean lb_load = TRUE
CHOOSE CASE UPPER(Right(this.text(index),3))
CASE "JPG","BMP",".RS","TXT"
	run_file(get_pathname(w_forms_main.i_active_sheet.ls_filename) + this.text(index))
CASE "MPF"
	IF ProfileString(gs_ini,"Utilities","FormInfo","") = "YES" THEN
		IF Messagebox("FormInfo","Do you wish to read file?",Question!, YesNo!,2) = 1 THEN
			run("notepad " + get_pathname(w_forms_main.i_active_sheet.ls_filename) + this.text(index))
			lb_load = FALSE
		END IF
	END IF
	IF lb_load THEN
		ls_item = this.text(index)
		IF ls_item = "main.mpf" THEN RETURN
		FOR LI = 1 to 3
			CHOOSE CASE mid(ls_item,li,1)
			CASE "0","1","2","3","4","5","6","7","8","9"
				ls_fpos += mid(ls_item,li,1)
			CASE ELSE
				li_stop = 3
			END CHOOSE
		NEXT
		ls_fname = Mid(ls_item,li_stop,len(ls_item) - li_stop - 3)
		w_forms_main.i_active_sheet.dw_formlist.trigger event ue_addform(ls_fname,"","","",integer(ls_fpos))
	END IF
CASE "DEF"
	IF ProfileString(gs_ini,"Utilities","FormInfo","") = "YES" THEN
		run("notepad " + get_pathname(w_forms_main.i_active_sheet.ls_filename) + this.text(index))
	END IF
CASE ELSE
	Messagebox("Load Document","This document can not be opened at this time")
END CHOOSE


end event

event rbuttondown;long jobno
Integer li
IF Messagebox("Form Docs","Do you wish to print list", Question!, YesNo!,2) = 1 THEN
jobno = PrintOpen("Form Docs")

Print(jobno, "FORM DOCS      " + String(Today()))

FOR li = 1 to this.totalitems()
	Print(jobno, this.text(li))
NEXT

PrintClose(jobno)
END IF
end event

