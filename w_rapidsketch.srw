HA$PBExportHeader$w_rapidsketch.srw
forward
global type w_rapidsketch from window
end type
type cb_2 from commandbutton within w_rapidsketch
end type
type cb_1 from commandbutton within w_rapidsketch
end type
end forward

global type w_rapidsketch from window
integer width = 832
integer height = 624
boolean titlebar = true
string title = "Rapid Sketch."
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
cb_2 cb_2
cb_1 cb_1
end type
global w_rapidsketch w_rapidsketch

type prototypes
Function integer RapidSketch() library "RSIntegration.DLL"
end prototypes

type variables
string ls_filename 
uo_rapidsketch uo_test
end variables

on w_rapidsketch.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.cb_2,&
this.cb_1}
end on

on w_rapidsketch.destroy
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;ls_filename = message.stringparm


end event

type cb_2 from commandbutton within w_rapidsketch
integer x = 64
integer y = 216
integer width = 558
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Save Rapid Sketch"
end type

event clicked;//Integer li
//any li_pages[]
//String ls_rfile
//li_pages = oRapidSk
//osketch oRapidSketch.Pages 
//li_pages[] = CREATE USING oRapidSketch.Sketch
//oSketch = oRapidSketch.Sketch
//oSketch = CREATE OleObject
//li_pages = oRapidSketch.Pages
//
//
//FOR li = LowerBound(li_pages) TO Upperbound(li_pages)
//	Messagebox("Save JPEG",ls_filename + string(li) + ".jpg")
//	ls_rfile =  
//	oSketch = oRapidSketch.Pages[li]
//	IF NOT oRapidSketch.Pages[li].SaveImage(ls_filename + string(li) + ".jpg") THEN
//		Messagebox("Rapid Sketch",ls_filename + string(li) + ".jpg can not be saved")
//	END IF
//NEXT
//
//
//		
//cb_1.enabled = TRUE
//cb_2.enabled = FALSE
//ole_sketch = CREATE OleObject
//ole_sketch = this.Object.GetFolderContents(ls_ftp_path + "*",0)
//
//FOR li = LowerBound(oRapidSketch.Pages) TO Upperbound(oRapidSketch.Pages)
//	Messagebox("",string(li))
//NEXT
//inv_ftp.ls_files[li] = ole_folderItems.Item[li].itemname

uo_test.trigger event ue_complete()
cb_1.enabled = TRUE
cb_2.enabled = FALSE
DESTROY uo_test
close(w_rapidsketch)

end event

type cb_1 from commandbutton within w_rapidsketch
integer x = 64
integer y = 76
integer width = 558
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Start Rapid Sketch"
end type

event clicked;uo_test = CREATE uo_rapidsketch
IF uo_test.trigger event ue_start(ls_filename) THEN
	this.enabled = FALSE
	cb_2.enabled = TRUE
END IF
//string ls_printer, ls_pfile, ls_ini, ls_pdffile
//integer result
//
//oRapidSketch = CREATE OLEObject
//
//result = oRapidSketch.ConnectToNewObject("RSIntegration.RapidSketchIntegration.1")
//
//	IF result < 0 THEN
//		Messagebox("RapidSketch","Error loading object-Error#" + string(result))
//	ELSE
//		oRapidSketch.Data = ""
//		oRapidSketch.ApplicationName = "SSCG Software"
//		IF oRapidSketch.OpenRapidSketch THEN
//			this.enabled = FALSE
//			cb_2.enabled = TRUE
//		END IF
//	END IF
//
//



end event

