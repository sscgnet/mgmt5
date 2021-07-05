HA$PBExportHeader$w_forms_print.srw
forward
global type w_forms_print from window
end type
type cbx_1 from checkbox within w_forms_print
end type
type cb_7 from commandbutton within w_forms_print
end type
type ddlb_pdf_types from dropdownlistbox within w_forms_print
end type
type ddlb_pdf from dropdownlistbox within w_forms_print
end type
type cbx_reset from checkbox within w_forms_print
end type
type cb_6 from commandbutton within w_forms_print
end type
type dw_report from datawindow within w_forms_print
end type
type cb_5 from commandbutton within w_forms_print
end type
type cb_4 from commandbutton within w_forms_print
end type
type cb_3 from commandbutton within w_forms_print
end type
type cb_2 from commandbutton within w_forms_print
end type
type cb_1 from commandbutton within w_forms_print
end type
type lb_list from listbox within w_forms_print
end type
end forward

global type w_forms_print from window
integer width = 1737
integer height = 940
boolean titlebar = true
string title = "Print Options"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "Form!"
boolean center = true
cbx_1 cbx_1
cb_7 cb_7
ddlb_pdf_types ddlb_pdf_types
ddlb_pdf ddlb_pdf
cbx_reset cbx_reset
cb_6 cb_6
dw_report dw_report
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
lb_list lb_list
end type
global w_forms_print w_forms_print

type variables
boolean lb_setup = TRUE, lb_perror = FALSE, lb_aimport = FALSE
end variables

on w_forms_print.create
this.cbx_1=create cbx_1
this.cb_7=create cb_7
this.ddlb_pdf_types=create ddlb_pdf_types
this.ddlb_pdf=create ddlb_pdf
this.cbx_reset=create cbx_reset
this.cb_6=create cb_6
this.dw_report=create dw_report
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.lb_list=create lb_list
this.Control[]={this.cbx_1,&
this.cb_7,&
this.ddlb_pdf_types,&
this.ddlb_pdf,&
this.cbx_reset,&
this.cb_6,&
this.dw_report,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.lb_list}
end on

on w_forms_print.destroy
destroy(this.cbx_1)
destroy(this.cb_7)
destroy(this.ddlb_pdf_types)
destroy(this.ddlb_pdf)
destroy(this.cbx_reset)
destroy(this.cb_6)
destroy(this.dw_report)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.lb_list)
end on

event close;close(w_report_screen)

end event

type cbx_1 from checkbox within w_forms_print
integer x = 1134
integer y = 768
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Test"
end type

type cb_7 from commandbutton within w_forms_print
integer x = 46
integer y = 764
integer width = 402
integer height = 60
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select by #"
end type

event clicked;integer li, li_start, li_end

openwithparm(w_ask,"Start number")
li_start = integer(message.stringparm)
openwithparm(w_ask,"End number")
li_end = integer(message.stringparm)
FOR li = 1 to lb_list.totalitems()
	IF li >= li_start AND li <= li_end THEN
		lb_list.SetSTate(li,TRUE)
	ELSE
		lb_list.SetState(li,FALSE)
	END IF
NEXT
end event

type ddlb_pdf_types from dropdownlistbox within w_forms_print
boolean visible = false
integer x = 599
integer y = 692
integer width = 411
integer height = 324
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"None"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;w_forms_main.i_active_sheet.ls_pdftype = this.text(index)
cbx_reset.checked = TRUE
end event

type ddlb_pdf from dropdownlistbox within w_forms_print
boolean visible = false
integer x = 1938
integer y = 124
integer width = 411
integer height = 324
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event constructor;integer li,lpos

this.DirList(get_dir("Templates","")+ "photo_pdf*.emp", 1)
FOR li = 1 to this.totalitems()
	lpos = pos(this.text(li),".")
	ddlb_pdf_types.additem(mid(this.text(li),7,lpos -7))
NEXT
IF ddlb_pdf_types.totalitems() > 1 THEN 
	ddlb_pdf_types.visible = TRUE
	ddlb_pdf_types.text = w_forms_main.i_active_sheet.ls_pdftype
END IF
IF ddlb_pdf_types.totalitems() > 0 THEN 
	cbx_reset.visible = TRUE
	IF w_forms_main.i_active_sheet.lb_pdfreset THEN cbx_reset.checked = TRUE
END IF
end event

type cbx_reset from checkbox within w_forms_print
boolean visible = false
integer x = 1115
integer y = 692
integer width = 571
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reset PDF Pictures"
end type

event clicked;IF this.checked THEN
	w_forms_main.i_active_sheet.lb_pdfreset = TRUE
ELSE
	w_forms_main.i_active_sheet.lb_pdfreset = FALSE
END IF
end event

type cb_6 from commandbutton within w_forms_print
boolean visible = false
integer x = 1573
integer y = 52
integer width = 123
integer height = 60
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "*"
end type

event clicked;string ls_aname
open(w_waiting)
ls_aname = Left(w_forms_main.i_active_sheet.ls_zipfile,len(w_forms_main.i_active_sheet.ls_zipfile) - 4)
dw_report.trigger event ue_print_pdf(ls_aname)
close(w_waiting)

IF FileExists(ls_aname + ".pdf") THEN
	run_file(ls_aname + ".pdf")
ELSE
	Messagebox("PDF Not Created",ls_aname + ".pdf not found")
END IF
end event

event constructor;IF ProfileString(gs_ini,"Utilities","PDF","YES") = "YES" THEN this.visible = TRUE
end event

type dw_report from datawindow within w_forms_print
event type boolean ue_setup ( datawindow ldw )
event type string ue_setup_dw ( string ls_formname,  string ls_mainname )
event type integer ue_print_pdf ( string ls_pdfname )
event type boolean test_datawindow ( datawindow ldw )
boolean visible = false
integer x = 137
integer y = 136
integer width = 795
integer height = 456
integer taborder = 80
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type boolean ue_setup(datawindow ldw);String dwsyntax, ErrorBuffer, ls_dname, ls_all[], ls_new, ls_mainform
integer rtncode, li, li_count = 0 , lx, li_all[], li_letter_count, li_tab
long li_y = 20
String ls_letter_options = "abcdefghijklmnopqrstuvwxyz"

datawindowchild ldw_a
open(w_waiting)
w_waiting.title = "Setting Up...."
IF ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FORMHEADER","NO") = "NO" THEN RETURN FALSE
//openwithparm(w_waiting,"Loading.....")

ls_dname = this.trigger event ue_setup_dw("pw_" + w_forms_main.i_active_sheet.ls_form + "_header","")
dwsyntax = "release 10.5;~r~n"
dwsyntax += "datawindow(units=0 timer_interval=0 color=1090519039 processing=5 HTMLDW=no print.printername=~"~" print.documentname=~"~" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 0 print.margin.bottom = 0 print.paper.source = 0 print.paper.size = 0 print.canusedefaultprinter=yes print.prompt=no print.buttons=no print.preview.buttons=no print.cliptext=no print.overrideprintjob=no print.collate=yes hidegrayline=no )~r~n"
IF ls_dname <> "" THEN
	dwsyntax += "header(height=152 color=~"536870912~" height.autosize=yes)~r~n"
ELSE
	dwsyntax += "header(height=0 color=~"536870912~" height.autosize=yes)~r~n"
END IF
dwsyntax += "summary(height=0 color=~"536870912~" height.autosize=yes)~r~n"
dwsyntax += "footer(height=156 color=~"536870912~" height.autosize=yes)~r~n"
dwsyntax += "detail(height=460 color=~"536870912~" height.autosize=yes)~r~n"
dwsyntax += "table(column=(type=char(10) updatewhereclause=yes name=a dbname=~"a~" )~r~n"
dwsyntax +=  " unbound = ~"yes~")~r~n"
//dwsyntax += "report(band=detail dataobject=~"pw_ho_elec_heat~" x=~"46~" y=~"20~" height=~"120~" width=~"3474~" border=~"0~"  height.autosize=yes criteria=~"~" trail_footer = yes  name=pw_ho_elec_heat visible=~"1~"  slideup=directlyabove )~r~n"

IF ls_dname <> "" THEN
	li_count += 1
	ls_all[li_count] = ls_dname + string(li_count)
	li_all[li_count] = 1
	dwsyntax += "report(band=header dataobject=~"" + ls_dname + "~" x=~"0~" y=~"24~" height=~"120~" width=~"3474~" border=~"0~"  height.autosize=yes criteria=~"~"  trail_footer = yes  name=" + ls_dname + string(li_count) + " visible=~"1~"  slideup=allabove )"
	//dwsyntax += "report(band=header dataobject=~"" + ls_dname + "~" x=~"0~" y=~"20~" height=~"120~" width=~"3500~" border=~"0~"  height.autosize=yes criteria=~"~" trail_footer = yes  name=pw_formheader visible=~"1~" slideup=directlyabove )"
END IF

w_waiting.title = "Please wait...."
FOR li = 1 to lb_list.totalitems()
	IF lb_list.state(li) = 1 THEN
		w_waiting.trigger event ue_step()
		//IF w_forms_main.i_active_sheet.dw_formlist.trigger event ue_check_print(li) > 0 THEN
		li_tab = w_forms_main.i_active_sheet.dw_formlist.trigger event ue_setup_form(li,TRUE)
		IF li_tab > 0 THEN
			IF w_forms_main.i_active_sheet.ls_pdftype <> "None" THEN
				w_waiting.title = "Please wait...compressing photos..."
				w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_compress_photos(w_forms_main.i_active_sheet.ls_pdftype, &
					w_forms_main.i_active_sheet.lb_pdfreset)
			END IF
		END IF
		li_letter_count = len(ls_letter_options)
		ls_dname = this.trigger event ue_setup_dw("pw_" + w_forms_main.i_active_sheet.ls_form + "_all","")
		IF ls_dname <> "" AND ProfileString(w_forms_main.i_active_sheet.is_formini,w_forms_main.i_active_sheet.ls_form,"FormAll","NO") = "YES" THEN
			li_letter_count = 0
			li_count += 1
			ls_all[li_count] = ls_dname + string(li_count)
			li_all[li_count] = li_tab
			dwsyntax += "~r~nreport(band=detail dataobject=~"" + ls_dname + "~" x=~"0~" y=~"" + string(li_y) + "~" height=~"120~" width=~"3474~" border=~"0~"  height.autosize=yes criteria=~"~" " + ls_new + " trail_footer = yes  name=" + ls_dname + string(li_count) + " visible=~"1~"  slideup=directlyabove )"
			li_y += 144
		END IF
		FOR lx = 1 to li_letter_count
			IF lx = 1 THEN
				IF NOT lb_perror THEN
					ls_dname = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_get_dwname("")
					ls_mainform = ls_dname
					//ls_new = "newpage = yes"
					ls_new = ""
				END IF
				//ls_new = ""
			ELSE
				IF NOT lb_perror THEN
					ls_dname = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_get_dwname(mid(ls_letter_options,lx - 1,1))
					ls_new = ""
					IF ls_dname = "" THEN li_letter_count = lx
				END IF
			END IF
			IF ls_dname <> "" THEN
				IF NOT lb_perror THEN
					this.trigger event ue_setup_dw(ls_dname,ls_mainform)
					li_count += 1
					ls_all[li_count] = ls_dname + string(li_count)
					li_all[li_count] = li_tab
				//ls_all[1] = "dw_1"
					dwsyntax += "~r~nreport(band=detail dataobject=~"" + ls_dname + "~" x=~"0~" y=~"" + string(li_y) + "~" height=~"120~" width=~"3500~" border=~"0~"  height.autosize=yes criteria=~"~" " + ls_new + " trail_footer = yes  name=" + ls_dname + string(li_count) + " visible=~"1~"  slideup=directlyabove )"
					li_y += 160
				END IF
			END IF
		NEXT
		//END IF
	END IF
NEXT
ls_dname = this.trigger event ue_setup_dw("pw_" + w_forms_main.i_active_sheet.ls_form + "_footer","")
IF ls_dname <> "" THEN
	li_count += 1
	ls_all[li_count] = ls_dname + string(li_count)
	li_all[li_count] = 1
	dwsyntax += "~r~nreport(band=footer dataobject=~"" + ls_dname + "~" x=~"0~" y=~"24~" height=~"120~" width=~"3474~" border=~"0~"  height.autosize=yes criteria=~"~" " + ls_new + " trail_footer = yes  name=" + ls_dname + string(li_count) + " visible=~"1~"  slideup=directlyabove )"
END IF

//dwsyntax += "text(band=footer alignment=~"0~" text=~"~" border=~"0~" color=~"33554432~" x=~"2094~" y=~"0~" height=~"52~" width=~"1390~" html.valueishtml=~"0~"  name=t_company visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" )"
//dwsyntax += "text(band=footer alignment=~"0~" text=~"Prepared By:~" border=~"0~" color=~"33554432~" x=~"1678~" y=~"0~" height=~"52~" width=~"389~" html.valueishtml=~"0~"  name=t_1 visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" )"
//dwsyntax += "text(band=footer alignment=~"0~" text=~"~" border=~"0~" color=~"33554432~" x=~"0~" y=~"4~" height=~"52~" width=~"1390~" html.valueishtml=~"0~"  name=t_worksheet visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" )"
dwsyntax += "~r~ncompute(band=header alignment=~"0~" expression=~"'Page ' + page() + ' of ' + pageCount()~"border=~"0~" color=~"0~" x=~"46~" y=~"20~" height=~"88~" width=~"891~" format=~"[general]~" html.valueishtml=~"0~"  name=page_1 visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"16777215~" )"
dwsyntax += "~r~nhtmltable(border=~"1~" )~r~n"
dwsyntax += "htmlgen(clientevents=~"1~" clientvalidation=~"1~" clientcomputedfields=~"1~" clientformatting=~"0~" clientscriptable=~"0~" generatejavascript=~"1~" encodeselflinkargs=~"1~" netscapelayers=~"0~" )~r~n"
dwsyntax += "export.xml(headgroups=~"1~" includewhitespace=~"0~" metadatatype=0 savemetadata=0 )~r~n"
dwsyntax += "import.xml()~r~n"
dwsyntax += "export.pdf(method=0 distill.custompostscript=~"0~" xslfop.print=~"0~" )"

rtncode = ldw.create(dwsyntax,ErrorBuffer)
//make_dwsyntax("c:\test_composite.srd",dwsyntax)
//Clipboard(dwsyntax)
//ldw.dataobject = "pw_gardner"

IF Len(ErrorBuffer) > 0 THEN 
	Messagebox("Error",ErrorBuffer)
ELSE
	FOR li = 1 to Upperbound(ls_all)
		IF NOT lb_perror THEN
			IF ldw.GetChild(ls_all[li],ldw_a) <> 1 THEN
				IF NOT lb_perror THEN Messagebox("Load Table","Can not load " + ls_all[li])
				lb_perror = TRUE
			ELSE
				IF NOT lb_perror THEN
					w_forms_main.i_active_sheet.u_to_open[li_all[li]].dw_report.trigger event ue_setup_dw(ldw_a)
				END IF
				w_waiting.title = "Please wait loading..."
				w_waiting.trigger event ue_step()
			END IF
		END IF
	NEXT
END IF
this.title = "Print Options"
ldw.object.DataWindow.Zoom = 97
//close(w_waiting)
w_waiting.title = "Please wait..."

RETURN TRUE
end event

event type string ue_setup_dw(string ls_formname, string ls_mainname);string dwsyntax, ls_mdir, ErrorBuffer, ls_fname, ls_plibrary
integer rtncode

open(w_waiting)
IF ls_mainname = "" THEN ls_mainname = ls_formname
IF len(ls_mainname) > 3 THEN ls_mainname = Right(ls_mainname,len(ls_mainname) - 3)
ls_Fname = ls_formname
IF len(ls_fname) > 3 THEN ls_fname = Right(ls_formname,len(ls_formname) - 3)
IF Upper(ProfileString(w_forms_main.i_active_sheet.is_formini,ls_fname,"Pupdate","")) = "N/A"  THEN RETURN ""

ls_plibrary = ProfileString(w_forms_main.i_active_sheet.is_formini,profilestring(w_forms_main.i_active_sheet.is_formini,ls_mainname,"Load",ls_mainname),"Form","")
IF ls_plibrary = "" THEN ls_plibrary = w_forms_main.i_active_sheet.ls_library
IF ls_plibrary = "" THEN RETURN ""
dwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_plibrary,ls_fname,TRUE,FALSE)
IF dwsyntax = "" THEN RETURN ""	

IF 	ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormSRD","NO") = "YES" THEN
	IF ProfileString(w_forms_main.i_active_sheet.is_formini,ls_fname,"FORM","") = "SRD" THEN
		Messagebox("Print form Info","FYI:  SRD files need to updated before they will work")
		SetProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormSRD","NO")
	END IF
END IF
IF Upper(ProfileString(w_forms_main.i_active_sheet.is_formini,ls_fname,"Pupdate","YES")) = "YES"  THEN
	IF w_forms_main.title = "[TESTING MODE]" THEN
		IF NOT lb_aimport THEN Messagebox("Forms","Testing mode does not allow updates to the print screens.")
		lb_aimport = TRUE
		RETURN ls_formname
	END IF		
	IF ProfileString(gs_ini,"FORMS","Allowimport","NO") = "NO" THEN 
		IF NOT lb_aimport THEN Messagebox("Forms","Allowimport is not allowed on this computer, updates on print may not be reflected.")
		lb_aimport = TRUE
		RETURN ls_formname
	END IF
	ls_mdir = set_ini("Location of sscg_dyn.pbl","MAIN","sscg_dyn.pbl","sscg_dyn.pbd",FALSE)
	LibraryDelete(ls_mdir,ls_formname,ImportDataWIndow!)
	rtncode = LibraryImport(ls_mdir, ls_formname, ImportDataWindow!, &
	  dwsyntax, ErrorBuffer )
	  w_waiting.trigger event ue_step2()
	IF rtncode = -1 THEN
		Messagebox("Error Importing ","Problem importing " +  ls_formname + " into " + ls_mdir + "~r~n" + ErrorBuffer)
		//set_ini("!Location of sscg_dyn.pbl","MAIN","sscg_dyn.pbl","",TRUE)
		RETURN ""
	END IF
	SetProfileString(w_forms_main.i_active_sheet.is_formini,ls_fname,"Pupdate","No")
END IF
RETURN ls_formname

end event

event type integer ue_print_pdf(string ls_pdfname);integer li, li_count, li_tab

n_cst_printer adobe_reader
adobe_reader = CREATE n_cst_printer

IF dw_report.trigger event ue_setup(dw_report) THEN
	adobe_reader.of_print2pdf(dw_report,ls_pdfname + ".pdf")
	//CHOOSE CASE set_ini("Choose ADOBE=Acrobat Reador or PDF=Default (Recommended)","Adobe","Default","PDF",FALSE) 
	//CASE "PDF","PDF995"
	//CASE ELSE
		//adobe_reader.ue_addfile(ls_pdfname + ".pdf",FALSE)
	//END CHOOSE
	li_count = 1
ELSE
	FOR li = 1 to lb_list.totalitems()
		li_tab = w_forms_main.i_active_sheet.dw_formlist.trigger event ue_setup_form(li,TRUE)
		w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_print_all(-2)
		adobe_reader.of_print2pdf(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report,ls_pdfname + string(li) + ".pdf")
		CHOOSE CASE set_ini("Choose ADOBE=Acrobat Reador or PDF=Default (Recommended)","Adobe","Default","PDF",FALSE) 
		CASE "PDF","PDF995"
		CASE ELSE
			adobe_reader.ue_addfile(ls_pdfname + string(li) + ".pdf",FALSE)
		END CHOOSE
		li_count += 1
	NEXT
END IF
adobe_reader.ue_combine_pdf(ls_pdfname + ".pdf")
		
DESTROY adobe_reader;

RETURN li_count


end event

event type boolean test_datawindow(datawindow ldw);integer li_tot, li, li_all[], rtncode
string ls_all[],dwsyntax, ErrorBuffer, ls_mainname, ls_plibrary, ls_fname
datawindowchild ldw_a

ls_mainname = w_forms_main.i_active_sheet.ls_form
ls_fname = w_forms_main.i_active_sheet.ls_form + "_test"

ls_plibrary = ProfileString(w_forms_main.i_active_sheet.is_formini,profilestring(w_forms_main.i_active_sheet.is_formini,ls_mainname,"Load",ls_mainname),"Form","")
IF ls_plibrary = "" THEN ls_plibrary = w_forms_main.i_active_sheet.ls_library
IF ls_plibrary = "" THEN RETURN FALSE
dwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_plibrary,ls_fname,TRUE,FALSE)
rtncode = ldw.create(dwsyntax,ErrorBuffer)


openwithparm(w_ask,"Number of splits/20")
li_tot = integer(message.stringparm)

FOR li = 1 to li_tot
	ls_all[li] = "dw_" + string(li)
	li_all[li] = 1
NEXT
FOR li = 1 to li_tot
		IF ldw.GetChild(ls_all[li],ldw_a) <> 1 THEN
			IF NOT lb_perror THEN Messagebox("Load Table","Can not load " + ls_all[li])
			lb_perror = TRUE
		ELSE
			IF NOT lb_perror THEN
				w_forms_main.i_active_sheet.u_to_open[li_all[li]].dw_report.trigger event ue_setup_dw(ldw_a)
			END IF
			w_waiting.title = "Please wait loading..."
			w_waiting.trigger event ue_step()
		END IF
NEXT
RETURN TRUE

end event

type cb_5 from commandbutton within w_forms_print
integer x = 46
integer y = 688
integer width = 402
integer height = 60
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;boolean lb_state
integer li
IF this.text = "Select All" THEN
	lb_state = TRUE
	this.text = "DeSelect All"
ELSE
	lb_state = FALSE
	this.text = "Select All"
END IF

FOR li = 1 to lb_list.totalitems()
	lb_list.SetSTate(li,lb_state)
NEXT
end event

type cb_4 from commandbutton within w_forms_print
integer x = 1157
integer y = 164
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Preview"
end type

event clicked;Integer li, li_tab

long ll_job
this.text = "Loading..."

w_forms_main.i_active_sheet.trigger event ue_save()

open(w_waiting)
open(w_report_screen)
w_report_screen.visible = FALSE
IF cbx_1.checked THEN
	IF dw_report.trigger event test_datawindow(w_report_screen.dw_report) THEN
		w_report_screen.visible = TRUE
	END IF
	close(w_waiting)
	this.text = "Preview"
	RETURN
END IF
	
IF dw_report.trigger event ue_setup(w_report_screen.dw_report) THEN
	//dw_report.trigger event ue_setup(w_report_screen.dw_report)
	w_report_screen.visible = TRUE
ELSE
	close(w_report_screen)
	FOR li = 1 to lb_list.totalitems()
		IF lb_list.state(li) = 1 THEN
//			w_forms_main.i_active_sheet.u_to_open[li].dw_report.trigger event ue_print_job(-1)
			li_tab = w_forms_main.i_active_sheet.dw_formlist.trigger event ue_setup_form(li,TRUE)
			w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_print_all(-1)
		END IF
	NEXT
END IF

close(w_waiting)
this.text = "Preview"
end event

type cb_3 from commandbutton within w_forms_print
integer x = 1157
integer y = 300
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;Close(w_forms_print)
end event

type cb_2 from commandbutton within w_forms_print
integer x = 1161
integer y = 556
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Printer Setup"
end type

event clicked;PrintSetup()
end event

type cb_1 from commandbutton within w_forms_print
integer x = 1157
integer y = 36
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;Integer li, li_tab
Boolean lb_continue = FALSE
long ll_job
this.text = "Printing..."
w_forms_main.i_active_sheet.trigger event ue_save()
open(w_waiting)
FOR li = 1 to lb_list.totalitems()
	IF lb_list.state(li) = 1 THEN lb_continue = TRUE
NEXT

IF lb_continue THEN
	IF lb_setup THEN PrintSetup()
	
	IF dw_report.trigger event ue_setup(dw_report) THEN
		dw_report.object.DataWindow.Zoom = 98
		dw_report.print()
	ELSE
		ll_job = PrintOpen("Form " + w_forms_main.i_active_sheet.ls_filename)

		FOR li = 1 to lb_list.totalitems()
			IF lb_list.state(li) = 1 THEN
				li_tab = w_forms_main.i_active_sheet.dw_formlist.trigger event ue_setup_form(li,TRUE)
				w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_print_all(ll_job)
			END IF
		NEXT
		PrintClose(ll_job)
	END IF
ELSE
	Messagebox("Print Forms","No forms selected")
END IF
close(w_waiting)
this.text = "Print"
end event

type lb_list from listbox within w_forms_print
integer x = 32
integer y = 36
integer width = 1047
integer height = 640
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
boolean multiselect = true
borderstyle borderstyle = stylelowered!
end type

