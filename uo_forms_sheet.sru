HA$PBExportHeader$uo_forms_sheet.sru
forward
global type uo_forms_sheet from userobject
end type
type cb_crapidsketch from commandbutton within uo_forms_sheet
end type
type cb_rapidsketch from commandbutton within uo_forms_sheet
end type
type dw_info from uo_datawindow within uo_forms_sheet
end type
type dw_report from uo_datawindow within uo_forms_sheet
end type
type dw_defaultw from uo_datawindow within uo_forms_sheet
end type
end forward

global type uo_forms_sheet from userobject
integer width = 2706
integer height = 2192
boolean hscrollbar = true
boolean vscrollbar = true
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event type string ue_setup ( string ls_setupform,  string ls_ptype,  long ll_control,  integer li_formid,  transaction source )
event type integer ue_count_photos ( )
event type boolean ue_check ( string ls_setupform,  string ls_ptype )
cb_crapidsketch cb_crapidsketch
cb_rapidsketch cb_rapidsketch
dw_info dw_info
dw_report dw_report
dw_defaultw dw_defaultw
end type
global uo_forms_sheet uo_forms_sheet

type variables
boolean lb_changed, lb_multiple = FALSE, lb_ok = FALSE, lb_recs = FALSE, lb_validate = FALSE, lb_loaded = FALSE, lb_temp = FALSE
string ls_formname, ls_newname, ls_rtename, ls_pic[], ls_field_name, is_version, is_cversion, ls_formlibrary, is_footer_height = "", is_tabname
integer li_num, li_formnum, li_rsketch = 0, li_pwidth[], li_pheight[], li_rownum, ii_tab
uo_rapidsketch uo_test
string is_location = "", is_building = "", ii_files[], ls_wordini = ""
integer ii_formrow



end variables

forward prototypes
public subroutine ue_setpicture (string ls_field, integer li_wh)
public function integer search_photo (string ls_field)
public function string parse_cbx (string ls_value, integer lpos)
public function boolean ue_save_form (string ls_tform)
public function string ue_save_memo (string ls_field, string ls_item, integer li_tab, string ls_filename)
public function string ue_fix_string (string ls_item)
public function string ue_parse_cbx (string ls_value, integer lpos)
end prototypes

event type string ue_setup(string ls_setupform, string ls_ptype, long ll_control, integer li_formid, transaction source);string dwsyntax, ls_tempdir, errorbuffer
integer rtncode
boolean lb_add = FALSE
IF li_formid = 0 THEN
	li_formid = 1 
	lb_add = TRUE
END IF

ls_tempdir = get_dir("Templates","")
IF FileExists(ls_tempdir + "\sscgsrd\" + ls_ptype + ls_setupform + ".srd") THEN
	dwsyntax = get_dwsyntax(ls_tempdir + "\sscgsrd\" + ls_ptype + ls_setupform + ".srd")
	rtncode = dw_defaultw.create(dwsyntax,ErrorBuffer)
	IF rtncode = 1 THEN
		lb_ok = TRUE
		IF ls_ptype = "web_" THEN
			dw_defaultw.settransobject(source)
			dw_defaultw.retrieve(ll_control, li_formid)
			IF dw_defaultw.rowcount() > 0 THEN 
				RETURN "SUCCESS"
			ELSE
				IF lb_add THEN
					dw_defaultw.insertrow(0)
					dw_defaultw.object.caseno[1] = ll_control
					dw_defaultw.object.formid[1] = 1
					RETURN "SUCCESS"
				ELSE
					RETURN "No records found for " + string(ll_control) + "-" + string(li_Formid) + " " + ls_setupform
				END IF
			END IF
		ELSE
			RETURN "SUCCESS"
		END IF
	ELSE
		RETURN "Problem Loading " +  ls_setupform +  " " + ErrorBuffer
	END IF
ELSE
	RETURN "Can't find " + ls_tempdir + "\sscgsrd\" + ls_ptype + ls_setupform + ".srd"
END IF
RETURN ""


end event

event type integer ue_count_photos();Integer li_field = 1, li = 0
DO WHILE li_Field > 0
	li_Field = dw_defaultw.trigger event ue_check_field(dw_defaultw,"photo_" + string(li + 1))
	IF li_Field > 0 THEN li += 1
LOOP
RETURN li 
end event

event type boolean ue_check(string ls_setupform, string ls_ptype);string ls_tempdir
ls_tempdir = get_dir("Templates","")
IF FileExists(ls_tempdir + "\sscgsrd\" + ls_ptype + ls_setupform + ".srd") THEN RETURN TRUE
RETURN FALSE


end event

public subroutine ue_setpicture (string ls_field, integer li_wh);
end subroutine

public function integer search_photo (string ls_field);Integer li

FOR li = 1 TO Upperbound(ls_pic)
	IF ls_pic[li] = ls_field THEN RETURN li
NEXT
RETURN 0
end function

public function string parse_cbx (string ls_value, integer lpos);Integer li, lasc, lc = 0
String ls

FOR li = 1 TO len(ls_value)
	ls = mid(ls_value,li,1)
	lasc = asc(ls)
	IF lasc = 9 THEN
		lc += 1
		IF 	lc = lpos THEN
			RETURN mid(ls_value,li+1,1)
		END IF
	END IF
NEXT
RETURN ""
end function

public function boolean ue_save_form (string ls_tform);integer li_file, li,ly, rtn, lx
string ls_fielf, ls_ctype, ls_item, ls_new, ls_memo, ls_field, ls_save
boolean lb_save = TRUE

li_file = FileOpen(ls_tform, LineMode!, Write!, Shared!, Replace!)

dw_defaultw.Sort()
FOR li = 1 to Integer(dw_defaultw.Object.DataWindow.Column.Count)
	ls_field = dw_defaultw.Describe("#" + string(li) + ".Name")
	ls_ctype = dw_defaultw.Describe("#" + string(li) + ".ColType")
	FOR ly = 1 to dw_defaultw.rowcount()
		CHOOSE CASE UPPER(Left(ls_ctype,4))
		CASE "DATE"
			ls_item = string(dw_defaultw.object.data[ly,li],"mm/dd/yy")
		CASE "CHAR"
			CHOOSE CASE Left(ls_field,6)
			CASE "photo_" 
				ls_item = get_filename(string(dw_defaultw.object.data[ly,li]))
				IF len(ls_item) > 0 THEN
					ii_files[Upperbound(ii_files)+1] = ls_item
					IF FileExists(Left(ls_item,len(ls_item) - 3) + ".rs") THEN
						ii_files[Upperbound(ii_files)+1] = Left(ls_item,len(ls_item) - 3) + ".rs"
					END IF
				END IF
			CASE "tabrte"
//				ls_new = Left(ls_tform, len(ls_tform) - 4)
//				ls_new += string(li_tab) + ".rtf"
//				ls_item = get_filename(ls_new)
//				rtn = u_to_open[li_tab].rte_control.SaveDocument(ls_new, FileTypeRichText!)
//				u_to_open[li_tab].ls_rtename = ls_new
			CASE "tabske"
				ls_item = get_filename(string(dw_defaultw.object.data[ly,li]))
				ii_files[Upperbound(ii_files)+1] = ls_item
			CASE ELSE
				ls_item = ue_fix_string(string(dw_defaultw.object.data[ly,li]))
			END CHOOSE
		CASE ELSE
			CHOOSE CASE ls_field
			CASE "tabphotos"
				//ls_item = string(li_photos)
			CASE ELSE
				ls_item = ue_fix_string(string(dw_defaultw.object.data[ly,li]))
			END CHOOSE
		END CHOOSE
		IF ls_ctype = "char(32766)" THEN
			ls_item = string(dw_defaultw.object.data[ly,li])
			IF ls_field = "tabsketch" THEN
				ls_item = ue_save_memo(ls_field,ls_item,ii_formrow, ls_tform)
			ELSE
				w_waiting.trigger event ue_setup2(len(ls_item))
				ls_memo = ""
				FOR lx = 1 to len(ls_item)
					CHOOSE CASE asc(mid(ls_item,lx,1))
				  	CASE 10
					CASE 12,13
						ls_memo += "|"
					CASE ELSE
						ls_memo += mid(ls_item,lx,1)
					END CHOOSE
					w_waiting.trigger event ue_step2()
				NEXT
				ls_item = ls_memo
			END IF
		END IF
		ls_save = ls_item + "~~"
		IF len(ls_item) > 30000 THEN 
			ls_save = ue_save_memo(ls_field,ls_item,ii_formrow, ls_tform)
		END IF
		IF FileWrite(li_file, ls_ctype + "<" + ls_field + "." + string(ly) + ">" + ls_save) < 0 THEN
			lb_save = FALSE
			Messagebox("FileWrite","Error writing " + ls_field)
		END IF
	NEXT
NEXT

FileClose(li_file)
RETURN lb_save

end function

public function string ue_save_memo (string ls_field, string ls_item, integer li_tab, string ls_filename);integer li_file
string ls_save, ls_memofile
long ll_len, ll_start, li_count = 0

w_waiting.trigger event ue_setup2(100)

IF ISNULL(ls_item) THEN RETURN ""
ls_memofile = get_pathname(ls_filename) + ls_field + string(li_tab) + ".txt"
li_file = FileOpen(ls_memofile,LineMode!,Write!,LockReadWrite!,Replace!)

ll_len = len(ls_item)
ll_start = 1
DO UNTIL ll_start >= len(ls_item)
	ll_len = 30000
	IF len(ls_item) > ll_len + ll_start THEN 
		ls_save = Mid(ls_item,ll_start,ll_len) 
	ELSE
		ll_len = len(ls_item) - ll_start + 1
		ls_save = Mid(ls_item,ll_start,ll_len)
	END IF
	w_waiting.trigger event ue_step2()
	li_count += len(ls_save)
	FileWrite(li_file,ls_save)
	ll_start += ll_len
LOOP

w_waiting.trigger event ue_end2()
//IF len(ls_item) <> li_count THEN
	//Messagebox("Problem saving " + ls_memofile,string(len(ls_item)) + "=" + string(li_count))
//END IF
FileClose(li_file)
RETURN "REF$FILE:" + ls_memofile
end function

public function string ue_fix_string (string ls_item);Integer li
String ls_new = ""

FOR li = 1 to len(ls_item)
	CHOOSE CASE asc(mid(ls_item,li,1))
	CASE 10,12,13,9,11
		ls_new += " "
	CASE ELSE
		ls_new += mid(ls_item,li,1)
	END CHOOSE
NEXT

RETURN ls_new
end function

public function string ue_parse_cbx (string ls_value, integer lpos);Integer li, lasc, lc = 0
String ls

FOR li = 1 TO len(ls_value)
	ls = mid(ls_value,li,1)
	lasc = asc(ls)
	IF lasc = 9 THEN
		lc += 1
		IF 	lc = lpos THEN
			RETURN mid(ls_value,li+1,1)
		END IF
	END IF
NEXT
RETURN ""
end function

on uo_forms_sheet.create
this.cb_crapidsketch=create cb_crapidsketch
this.cb_rapidsketch=create cb_rapidsketch
this.dw_info=create dw_info
this.dw_report=create dw_report
this.dw_defaultw=create dw_defaultw
this.Control[]={this.cb_crapidsketch,&
this.cb_rapidsketch,&
this.dw_info,&
this.dw_report,&
this.dw_defaultw}
end on

on uo_forms_sheet.destroy
destroy(this.cb_crapidsketch)
destroy(this.cb_rapidsketch)
destroy(this.dw_info)
destroy(this.dw_report)
destroy(this.dw_defaultw)
end on

type cb_crapidsketch from commandbutton within uo_forms_sheet
boolean visible = false
integer x = 677
integer y = 648
integer width = 635
integer height = 116
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Rapid Sketch"
end type

event clicked;uo_test.trigger event ue_cancel()
DESTROY uo_test

cb_rapidsketch.visible = FALSE
cb_crapidsketch.visible = FALSE
li_rsketch = 1
lb_changed = FALSE
end event

type cb_rapidsketch from commandbutton within uo_forms_sheet
boolean visible = false
integer x = 677
integer y = 516
integer width = 635
integer height = 116
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import Rapid Sketch"
end type

event clicked;dw_defaultw.trigger event ue_advanced(3)
end event

type dw_info from uo_datawindow within uo_forms_sheet
boolean visible = false
integer x = 192
integer y = 396
integer width = 2345
integer height = 1272
integer taborder = 20
boolean titlebar = true
string dataobject = "dw_datawindow_info"
boolean controlmenu = true
end type

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_sort.visible = TRUE
lm_list.m_listview.m_query.visible = TRUE
end event

type dw_report from uo_datawindow within uo_forms_sheet
event ue_print_job ( long ll_job,  string pwsyntax )
event type string ue_get_dwname ( string ls_key )
event ue_setup_dw ( datawindowchild ldw )
event ue_set_picture ( string ls_field,  integer li_row,  datawindow ldw )
event type string ue_print_logo ( string ls_dlogo )
event type any ue_jpeg_word ( string ls_doc )
event ue_compress_photos ( string ls_key,  boolean lb_overwrite )
event type integer ue_print_all ( long ll_job )
event type integer ue_print_pdf ( long ll_job )
event type integer ue_print_specific ( long ll_job,  integer li )
event ue_parse_cbx ( any ls_cbx )
event ue_cbx_report ( datawindow ldw )
event type string ue_cbx_report_child ( datawindowchild ldw,  string ls_name )
event type string ue_get_syntax ( string ls_formlib,  string ls_fname,  boolean lb_print,  boolean lb_ask )
event type string ue_print_web ( long ll_job )
event ue_print_basic ( long ll_job,  string pwsyntax )
boolean visible = false
integer x = 750
integer y = 292
integer taborder = 20
end type

event ue_print_job(long ll_job, string pwsyntax);string ErrorBuffer, dwsyntax, ls_name, ls_error = "",ls_return, ls_richtext
string ls_logo, ls_height, ls_tag, ls_tname
integer rtncode, li, li_col, lx, ly, li_floc
datawindow ldw
ldw = this

IF pwsyntax <> "" THEN
	IF ll_job = -1 THEN
		open(w_report_screen)
		ldw = w_report_screen.dw_report
		w_report_screen.dw_report.modify("DataWindow.Print.Preview = Yes")
	END IF

	rtncode = ldw.create(pwsyntax,ErrorBuffer)
	IF rtncode = 1 THEN
//		IF rte_control.visible THEN
//			IF FileExists(ls_rtename) THEN
//				IF ldw.InsertDocument(ls_rtename,FALSE, FileTypeRichText!) <> 1 THEN
//					Messagebox("Print Job","Problem inserting " + ls_rtename)
//				END IF
//			ELSE
//				Messagebox("Print Job","RTE File " + ls_rtename + " not found")
//			END IF
//
//			//ls_richtext = rte_control.CopyRTF(FALSE,Detail!)
//			//ldw.PasteRTF(ls_richtext)
//		ELSE
		FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
			ls_name = ldw.Describe("#" + string(li) + ".Name")
			li_col = dw_defaultw.trigger event ue_check_field(dw_defaultw,ls_name)
			FOR ly = 1 to dw_defaultw.rowcount()
				IF ly > ldw.rowcount() THEN ldw.insertrow(0)
				IF Left(ls_name,6) = "photo_" THEN this.trigger event ue_set_picture(ls_name,ly,ldw)
				IF Left(ls_name,4) = "logo" THEN 
					li_floc = dw_defaultw.trigger event ue_check_field(dw_defaultw,ls_name)
					IF li_floc > 0 THEN
						ls_logo = this.trigger event ue_print_logo(dw_defaultw.object.data[ly,li_floc])
						IF NOT ISNULL(ls_logo) THEN ldw.setitem(ly,li,ls_logo)
						ls_name = "logo"
					END IF						
				END IF
				CHOOSE CASE ls_name
				CASE "logo"
//					IF dw_defaultw.trigger event ue_check_field(dw_defaultw,"logo") > 0 THEN
//						ls_logo = this.trigger event ue_print_logo(dw_defaultw.object.logo[ly])
//						IF NOT ISNULL(ls_logo) THEN ldw.setitem(ly,li,ls_logo)
//	//				ELSE
//					END IF						
				CASE "logopage"
					ldw.setitem(ly,li,"Page:  "  + string(li_Formnum))
				CASE ELSE
					li_floc = dw_defaultw.trigger event ue_check_field(dw_defaultw, Left(ls_name,len(ls_name) - 1) + "xx")
					IF li_floc > 0 THEN	
						ldw.setitem(ly,li,dw_defaultw.object.data[ly,li_floc])
					ELSE
						IF li_col > 0 THEN
							ldw.setitem(ly,li,dw_defaultw.object.data[ly,li_col])
						ELSE
							ls_error += "~r" + ls_name
						END IF
					END IF
				END CHOOSE
			NEXT
		NEXT
//		END IF
		ldw.Sort()
		ldw.GroupCalc()
		ldw.modify("DataWindow.Print.Preview = YES")
		CHOOSE CASE ll_job
		CASE -2
		CASE -1
		CASE 0
			IF dw_defaultw.rowcount() > 0 THEN ldw.Print()
		CASE ELSE
			IF dw_defaultw.rowcount() > 0 THEN PrintDataWindow(ll_job,this)
		END CHOOSE
	ELSE
		Messagebox("Form","Error loading " + w_forms_main.i_active_sheet.ls_library  + "-pw_" + ls_formname)
	END IF

//	IF ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormError","NO") = "YES" THEN
//		this.trigger event ue_cbx_report(ldw)
//		IF ls_error <> "" THEN
//			Messagebox("Form " + ls_formname,"Error retrieving the following fields: " + ls_error)
//		END IF
//	END IF
END IF

end event

event type string ue_get_dwname(string ls_key);string dwsyntax
ls_formlibrary = Profilestring(w_forms_main.i_active_sheet.is_formini,Profilestring(w_forms_main.i_active_sheet.is_formini,ls_formname,"Load",ls_formname),"Form","")
dwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary,ls_formname + ls_key,TRUE,FALSE)
IF dwsyntax = "" THEN 
	dwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_formname + ls_key,FALSE,FALSE)
	IF dwsyntax <> "" THEN RETURN "dw_" + ls_formname + ls_key
END IF
IF dwsyntax = "" THEN RETURN ""
RETURN "pw_" + ls_formname + ls_key

end event

event ue_setup_dw(datawindowchild ldw);string pwsyntax, ls_name, ls_logo, ls_error = "", ls_ycol, ls_pfile, ls_visible, ls_cbx[], ls_chkerr
string ls_style
boolean lb_check = FALSE
integer li_tot, li, li_col, ly, li_floc


IF ProfileString(gs_ini,"Utilities","FormError","NO") = "YES" THEN lb_check = TRUE

pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_formname,TRUE,FALSE)
IF pwsyntax = "" THEN 
	pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_formname,FALSE,FALSE)
END IF
IF pwsyntax <> "" THEN
	ldw.modify(pwsyntax)
	//this.trigger event ue_setup_cbx(ldw)
	li_tot = integer(ldw.Describe("DataWindow.Column.Count"))
	FOR li = 1 to li_tot
		ls_visible = ldw.Describe("#" + string(li) + ".Visible")
		//IF ls_visible = "1" THEN
			ls_name = ldw.Describe("#" + string(li) + ".Name")
			ls_ycol = ldw.Describe("#" + string(li) + ".X")
			//  Load these values whether they are printed on datawindow or not
			CHOOSE CASE ls_name
			CASE "zrecno"
				ls_ycol = ""
			END CHOOSE
			IF ls_ycol <> "?" THEN
				li_col = dw_defaultw.trigger event ue_check_field(dw_defaultw,ls_name)
				IF ls_name = "vacant3" THEN 
					Messagebox("vacant3",string(dw_defaultw.object.data[1,li_col]) + "-" + string(li) + "-" + string(li_col))
				END IF
				IF lb_check THEN 
					dw_info.trigger event ue_addnew()
					dw_info.object.name[dw_info.rowcount()] = ls_name
				END IF
				FOR ly = 1 to dw_defaultw.rowcount()
					IF ly > ldw.rowcount() THEN ldw.insertrow(0)
					CHOOSE CASE ls_name
					CASE "logo"
						ls_logo = this.trigger event ue_print_logo(dw_defaultw.object.data[ly,li_col])
						IF NOT ISNULL(ls_logo) THEN ldw.setitem(ly,li,ls_logo)
					CASE "zpage"
				
					CASE ELSE
						li_floc = dw_defaultw.trigger event ue_check_field(dw_defaultw, Left(ls_name,len(ls_name) - 1) + "xx")
						IF li_floc > 0 THEN	
							IF ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormError","NO") = "YES" THEN
								ls_cbx[li] = Left(ls_name,len(ls_name) - 1) + "xx" + "-" + ldw.Describe(ls_name + ".Values") + string(dw_defaultw.object.data[ly,li_floc])
							END IF
							IF ldw.setitem(ly,li,dw_defaultw.object.data[ly,li_floc]) = -1 THEN
									ls_error += "~r[Setitem]" + ls_name
							END IF
						ELSE
							IF li_col > 0 THEN
								IF ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormError","NO") = "YES" THEN
									     ls_style = ldw.Describe(ls_name + ".Edit.Style")
										IF ls_style = "checkbox" THEN
											ls_chkerr = this.trigger event ue_cbx_report_child(ldw, ls_name)
											IF ls_chkerr <> "" THEN ls_error += "~r[Checkbox]" + ls_chkerr
											ls_cbx[li] = ls_name + "-" + ldw.Describe(ls_name + ".Values") + string(dw_defaultw.object.data[ly,li_col])
										END IF
								END IF
								IF ldw.setitem(ly,li,dw_defaultw.object.data[ly,li_col]) = -1 THEN
									ls_error += "~r[Setitem]" + ls_name
								END IF
							ELSE
								ls_error += "~r" + ls_name
							END IF
						END IF
					END CHOOSE
				NEXT
			END IF
		//END IF
	NEXT
	IF dw_defaultw.rowcount() > 0 THEN
		IF ldw.rowcount() = 0 THEN ldw.insertrow(0)
	END IF
	ldw.GroupCalc()
END IF

//IF lb_check THEN this.trigger event ue_parse_cbx(ls_cbx)

IF ls_error <> "" AND lb_check THEN

	Messagebox("Form " + ls_formname,"Error retrieving the following fields: " + ls_error)
END IF

end event

event ue_set_picture(string ls_field, integer li_row, datawindow ldw);string ls_field2, ls_error
integer li_find, li_wh, li_dwh
decimal ld_perc = 0

ls_field2 = Right(ls_field,len(ls_field) - pos(ls_field, "_"))

li_find = dw_defaultw.trigger event ue_check_field(dw_defaultw,"h_" + ls_field2)
IF li_find > 0 THEN
	li_dwh = integer(ldw.Describe(ls_field + ".Height"))
	li_wh = dw_defaultw.object.Data[li_row,li_find]
	IF li_dwh > 0 THEN
		IF li_wh > li_dwh THEN
			ld_perc = li_dwh / li_wh		
			li_wh = li_dwh
		END IF
	END IF
	ls_error = ldw.Modify(ls_field + ".Height = '" + string(li_wh) + "'")
	IF ls_error <> "" THEN Messagebox("Set Picture Height", &
		ls_field + "-" + string(li_wh) + "~r~n" + ls_error)	
END IF

li_find = dw_defaultw.trigger event ue_check_field(dw_defaultw,"w_" + ls_field2)
IF li_find > 0 THEN
	li_dwh = integer(ldw.Describe(ls_field + ".Width"))
	li_wh = dw_defaultw.object.Data[li_row,li_find]
	IF ld_perc > 0 THEN li_wh = Round(li_wh * ld_perc,0)
	ls_error = ldw.Modify(ls_field + ".Width = '" + string(li_wh) + "'")
	IF ls_error <> "" THEN Messagebox("Set Picture Width", &
		ls_field + "-" + string(li_wh) + "~r~n" + ls_error)	
END IF


end event

event type string ue_print_logo(string ls_dlogo);string ls_logo
IF pos(ls_dlogo,"\") > 0 THEN ls_dlogo = get_filename(ls_dlogo)
ls_logo = get_dir("Templates","") + ls_dlogo
					
IF FileExists(ls_logo) THEN
	RETURN ls_logo
END IF
RETURN ""
end event

event type any ue_jpeg_word(string ls_doc);n_cst_printer adobe_reader
OLEObject ole_word, ole_sheet
Integer li, li_count = 0
String ls_nfile[]
adobe_reader = CREATE n_cst_printer
ole_word = CREATE OLEObject

IF ole_word.ConnectToNewObject("word.application") <> 0 THEN
	Messagebox("Error","Microsoft Word is not supported on your computer")
	RETURN "N/F"
END IF

this.trigger event ue_print_all(-2)
li_count += adobe_reader.ue_zvprt(this,ls_doc)
IF li_count = 0 THEN 
	ls_nfile[1] = "N/F"
ELSE
	FOR li = 1 TO li_count
		ls_nfile[li] = adobe_reader.is_jpeg[li]
	NEXT

FOR li = 1 TO Upperbound(ls_nfile)
	IF FileExists(get_dir("Main","Templates") + ls_doc + "z.doc") THEN
		ole_word.Documents.Open(get_dir("Main","Templates") + ls_formname + "z.doc")
	ELSE
		IF FileExists(get_dir("Main","Templates") + "zanprinter.doc") THEN
			ole_word.Documents.Open(get_dir("Main","Templates") + "zanprinter.doc")
		ELSE			
			ole_word.Documents.Add
		END IF
	END IF
	ole_word.ActiveDocument.Shapes.Addpicture(ls_nfile[li])
	ls_nfile[li] = ls_doc + string(li) + "Z.doc"
	ole_word.NormalTemplate.Saved = TRUE
	ole_word.ActiveDocument.SaveAs(ls_nfile[li])
	w_waiting.trigger event ue_filewait(ls_nfile[li],0,TRUE)
	FileDelete(ls_nfile[li])
NEXT
END IF
ole_word.quit
w_waiting.trigger event ue_waiting(long(ProfileString(gs_ini,"WORD","FormsTimer","300000")))
ole_word.DisconnectObject()

DESTROY ole_word
RETURN ls_nfile

		

end event

event ue_compress_photos(string ls_key, boolean lb_overwrite);integer li_tot, li, lx
string ls_name, ls_pfile

IF FileExists(get_dir("TEMPLATES","") + "photo_" + ls_key + ".emp") THEN
li_tot = integer(dw_defaultw.Describe("DataWindow.Column.Count"))
FOR li = 1 to li_tot
	ls_name = dw_defaultw.Describe("#" + string(li) + ".Name")
	FOR lx = 1 to dw_defaultw.rowcount()
		IF pos(ls_name,"photo_") > 0 THEN
			ls_pfile = compress_photo("photo_" + ls_key,ls_key,get_pathname(w_forms_main.i_active_sheet.ls_filename) + &
				get_filename(dw_defaultw.object.data[lx,li]),lb_overwrite)
			IF ls_pfile <> "" THEN dw_defaultw.object.data[lx,li] = ls_pfile
		END IF
	NEXT
NEXT
END IF
end event

event type integer ue_print_all(long ll_job);string pwsyntax, ls_checkform,dwsyntax, ls_printname
integer li, li_count = 0

ls_printname = Profilestring(w_forms_main.i_active_sheet.is_formini,ls_formname,"AltPrint",ls_formname)

ls_checkform = ls_printname
FOR li = 1 to 10
	IF li = 1 THEN
		pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,TRUE)
		ls_formlibrary = Profilestring(w_forms_main.i_active_sheet.is_formini,ls_checkform,"Form","")
	ELSE	
		ls_checkform = ls_printname + string(li)
		dwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,FALSE,FALSE)
		IF dwsyntax <> "" THEN
			pwsyntax = ""
		ELSE
			pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,FALSE)
		END IF
	END IF
	IF pwsyntax <> "" THEN	
		li_count += 1
		IF ll_job <> -1 THEN this.trigger event ue_print_job(ll_job, pwsyntax)
	END IF
NEXT

IF ll_job = -1 THEN
	ls_checkform = ls_printname
	IF li_count = 1 THEN
		pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,TRUE)
	ELSE
//		dwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,FALSE,FALSE)
//		IF dwsyntax <> "" THEN
//			pwsyntax = ""
//		ELSE
			openwithparm(w_ask,"Multiple pages " + string(li_count) + "~r~nWhich page do you want to print?")
			li = integer(message.stringparm)
			IF li > 1 THEN ls_checkform = ls_formname + string(li)
			pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,FALSE)
//		END IF
	END IF
	IF pwsyntax <> "" THEN this.trigger event ue_print_job(ll_job, pwsyntax)
END IF
		
RETURN li_count
end event

event type integer ue_print_pdf(long ll_job);string pwsyntax, ls_checkform
integer li, li_count = 0

ls_checkform = ls_formname
FOR li = 1 to 10
	IF li = 1 THEN
		pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,TRUE)
	ELSE	
		ls_checkform = ls_formname + string(li)
		pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,FALSE)
	END IF
	IF pwsyntax <> "" THEN	
		li_count += 1
		this.trigger event ue_print_job(ll_job, pwsyntax)
	END IF
NEXT
RETURN li_count
end event

event type integer ue_print_specific(long ll_job, integer li);string pwsyntax, ls_checkform
integer li_count = 0

ls_checkform = ls_formname
//FOR li = 1 to 10
	IF li = 1 THEN
		pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,TRUE)
	ELSE	
		ls_checkform = ls_formname + string(li)
		pwsyntax = w_forms_main.i_active_sheet.trigger event ue_get_syntax(ls_formlibrary, ls_checkform,TRUE,FALSE)
	END IF
	IF pwsyntax <> "" THEN	
		li_count += 1
		this.trigger event ue_print_job(ll_job, pwsyntax)
	END IF
//NEXT
RETURN li_count

end event

event ue_parse_cbx(any ls_cbx);Integer li, lz, lpos, li_found, rpos
string ls_names[], ls_values1[], ls_values2[], ls_values3[], ls_answers[], ls_name, ls_type
string ls_defvalues[], ls_message
string ls_return = ""
ls_defvalues = ls_cbx
FOR li = 1 to upperbound(ls_defvalues)
	IF ls_defvalues[li] <> "" THEN
	ls_return += ls_defvalues[li]
	ls_name = Left(ls_defvalues[li],pos(ls_defvalues[li],"-") - 1)
	lpos = 0
	FOR lz = 1 to upperbound(ls_names)
		IF ls_names[lz] = ls_name THEN lpos = lz
	NEXT
	IF lpos = 0 THEN lpos = Upperbound(ls_names) + 1
	ls_names[lpos] = ls_name
	ls_answers[lpos] = Right(ls_defvalues[li],1)
	rpos = pos(ls_defvalues[li],"//")
	IF rpos > 0 THEN rpos += 1
	rpos = pos(ls_defvalues[li],"/",rpos + 1)
	ls_type = mid(ls_defvalues[li],rpos - 1, 1)
	IF upperbound(ls_values1) < lpos THEN
		ls_values1[lpos] = ""
		ls_values2[lpos] = ""
		ls_values3[lpos] = ""
	END IF
	IF ls_values1[lpos] = "" THEN 
		ls_values1[lpos] = ls_type
	ELSE
		IF ls_values2[lpos] = "" THEN 
			ls_values2[lpos] = ls_type
		ELSE
			IF ls_values3[lpos] = "" THEN 
				ls_values3[lpos] = ls_type
			END IF
		END IF
	END IF
	END IF
NEXT

FOR li = 1 to upperbound(ls_answers)
	li_found = 0
	IF ls_answers[li] = ls_values1[li] THEN li_found += 1
	IF ls_answers[li] = ls_values2[li] THEN li_found += 1
	IF ls_answers[li] = ls_values3[li] THEN li_found += 1
	IF li_found = 0 THEN ls_message += ls_names[li] + " "
NEXT
//Messagebox("",ls_return)
IF ls_message <> "" THEN
	Messagebox("Invalid Checkboxes",ls_message)
END IF
end event

event ue_cbx_report(datawindow ldw);long li_prt
integer li, li_floc, li_dloc
string ls_message, ls_field, ls_visible, setting, ls_value1, ls_value2, ls_error
string ls_radio1, ls_radio2, ls_radio3
boolean lb_found1, lb_found2 

	IF messagebox("Print Checkbox Report","Do you wish to print checkbox report",Question!, YesNo!,2) = 1 THEN
		li_prt = PrintOpen("Print Checkbox")
		Print(li_prt,"Checkbox Report")
		FOR li = 1 to Integer(string(ldw.Object.DataWindow.Column.Count))
			ls_message = ""
			ls_field = ldw.Describe("#" + string(li) + ".Name")
			ls_visible = ldw.Describe("#" + string(li) + ".Visible")
			//setting = this.Describe("#" + string(li) + ".Tag")
			//IF Right(ls_field,2) = "xx" THEN
				//ls_message += 	this.Describe(ls_field + ".Values")
			//END IF			
			//Left(ls_name,len(ls_name) - 1) + "xx"
			IF ls_visible = "1" THEN
				ls_error = ""
				lb_found1 = FALSE
				lb_found2 = FALSE
				li_floc = dw_defaultw.trigger event ue_check_field(ldw, Left(ls_field,len(ls_field) - 1) + "xx")
				li_dloc = dw_defaultw.trigger event ue_check_field(dw_defaultw, Left(ls_field,len(ls_field) - 1) + "xx")
				ls_value1 = parse_cbx(ldw.Describe("#" + string(li_floc) + ".values"),1) 
				IF ls_value1 = parse_cbx(ldw.Describe("#" + string(li_floc) + ".values"),2) THEN
					ls_error = "CHECKBOX PROBLEM"
				END IF
				ls_value2 =parse_cbx(ldw.Describe("#" + string(li) + ".values"),1) 
				IF ls_value2 = parse_cbx(ldw.Describe("#" + string(li) + ".values"),2) THEN
					ls_error = "CHECKBOX PROBLEM"
				END IF
				ls_radio1 = parse_cbx(dw_defaultw.Describe("#" + string(li_dloc) + ".values"),1) 
				ls_radio2 = parse_cbx(dw_defaultw.Describe("#" + string(li_dloc) + ".values"),2) 
				ls_radio3 = parse_cbx(dw_defaultw.Describe("#" + string(li_dloc) + ".values"),3) 
				IF ls_value1 = ls_radio1 THEN lb_found1 = TRUE
				IF ls_value1 = ls_radio2 THEN lb_found1 = TRUE
				IF ls_value1 = ls_radio3 THEN lb_found1 = TRUE
				IF ls_value2 = ls_radio1 THEN lb_found2 = TRUE
				IF ls_value2 = ls_radio2 THEN lb_found2 = TRUE
				IF ls_value2 = ls_radio3 THEN lb_found2 = TRUE
				IF lb_found1 AND lb_found2 THEN 
				ELSE
					ls_error = "CHECKBOX PROBLEM"
				END IF
				IF ls_value1 = ls_value2 THEN ls_error = "CHECKBOX PROBLEM"
				IF li_floc > 0 THEN	
					ls_message = string(li_dloc) + "~t" + ls_field 
					ls_message += "~t" + ls_value2
					ls_message += "~t(" + ls_value1 + ")"
					ls_message +=  "~t(radio)~t" + ls_radio1
					ls_message +=  "~t" + ls_radio2
					ls_message +=  "~t" + ls_radio3 + "~t" + ls_error
					Print(li_prt, ls_message)
				END IF
			END IF
		NEXT
		PrintClose(li_prt)
	END IF

end event

event type string ue_cbx_report_child(datawindowchild ldw, string ls_name);string ls_value1, ls_value2, ls_value3, ls_chkbox1, ls_chkbox2, ls_chkbox3, ls_error = ""
string ls_options = "cdefghijklmnopqrstuvwxyz23456789", ls_cbxname, ls_vname, ls_style
boolean lb_error = FALSE
integer li_ctest, lx

ls_style = dw_defaultw.Describe(ls_name + ".Edit.Style")
IF ls_style = "checkbox" THEN
	ls_value1 = parse_cbx(dw_defaultw.Describe(ls_name + ".Values"),1)
	ls_value2 = ""
	ls_value3 = ""
ELSE
	ls_value1 = parse_cbx(dw_defaultw.Describe(ls_name + ".values"),1) 
	ls_value2 = parse_cbx(dw_defaultw.Describe(ls_name + ".values"),2) 
	ls_value3 = parse_cbx(dw_defaultw.Describe(ls_name + ".values"),3) 
END IF
ls_chkbox1 = parse_cbx(ldw.Describe(ls_name + ".Values"),1)
ls_cbxname =Left(ls_name,len(ls_name) - 2)
ls_chkbox2 = parse_cbx(ldw.Describe(ls_cbxname + "1.Values"),1)
ls_chkbox3 = parse_cbx(ldw.Describe(ls_cbxname + "2.Values"),1)
IF ls_chkbox2 = "" THEN	ls_chkbox2 = parse_cbx(ldw.Describe(ls_cbxname + "a.Values"),1)
IF ls_chkbox3 = "" THEN	ls_chkbox3 = parse_cbx(ldw.Describe(ls_cbxname + "b.Values"),1)
IF ls_chkbox2 = "" AND ls_chkbox3 <> ""  THEN
	ls_chkbox2 = parse_cbx(ldw.Describe(ls_cbxname + "b.Values"),1)
	ls_chkbox3 = parse_cbx(ldw.Describe(ls_cbxname + "c.Values"),1)
END IF
IF ls_value3 = "" AND ls_chkbox2 = "" THEN
	ls_chkbox2 = ls_chkbox3
	ls_chkbox3 = ""
END IF
	
IF ls_style = "checkbox" THEN
	IF ls_value1 <> ls_chkbox1 THEN lb_error = TRUE
	ls_vname += ls_name + "  Dw Value(" + ls_value1 + ")"	
	ls_vname += " PW Value(" + ls_chkbox1  + ")"
ELSE
	IF ls_value1 <> ls_chkbox1 THEN lb_error = TRUE
	IF ls_value2 <> ls_chkbox2 THEN lb_error = TRUE
	IF ls_value3 <> ls_chkbox3 THEN lb_error = TRUE

	ls_vname += ls_name + "  Radio Values(" + ls_value1 + "," + ls_value2 + "," + ls_value3 + ")"	
	ls_vname += " Cbx Values(" + ls_chkbox1 + "," + ls_chkbox2 + "," + ls_chkbox3	 + ")"
END IF
//Messagebox("Checkbox", ls_vname)
	

IF lb_error THEN
	IF ls_style <> "checkbox" THEN
		FOR lx =1  to len(ls_options)
			li_ctest = dw_defaultw.trigger event ue_check_field(dw_defaultw,ls_cbxname + mid(ls_options,lx,1))
			IF li_ctest > 0 THEN ls_vname += " Check field name " + ls_cbxname + mid(ls_options,lx,1) + "--"
		NEXT
	END IF
	RETURN ls_vname
END IF
RETURN ""





end event

event type string ue_get_syntax(string ls_formlib, string ls_fname, boolean lb_print, boolean lb_ask);string dwsyntax = "",  ls_ptype = "dw_", ls_templates = ""
ls_templates = get_dir("TEMPLATES","")
IF lb_print THEN ls_ptype = "pw_"
	
IF ls_formlib = "" THEN 
	Messagebox("Load Syntax","No form library specified")
	RETURN ""
END IF
IF pos(ls_formlib,"SRD") > 0 THEN
	IF FileExists(ls_templates + "\sscgsrd\" + ls_ptype + ls_fname + ".srd") THEN
		dwsyntax = get_dwsyntax(ls_templates + "\sscgsrd\" + ls_ptype + ls_fname + ".srd")
	ELSE
		IF lb_print THEN
			IF lb_ask THEN
				IF FileExists(ls_templates + "\sscgsrd\dw_" + ls_fname + ".srd") THEN
					dwsyntax = get_dwsyntax(ls_templates + "\sscgsrd\dw_" + ls_fname + ".srd")
				ELSE
					Messagebox("Load Form-Get Syntax","Library can not find form " + ls_templates + "\sscgsrd\dw_" + ls_fname + ".srd")
					RETURN ""
				END IF
			ELSE
				RETURN ""
			END IF
		ELSE
			IF lb_ask THEN
				Messagebox("Load Form-Get Syntax","Library can not find form " + ls_templates + "\sscgsrd\" + ls_ptype + ls_fname + ".srd")
				RETURN ""
			END IF
		END IF
	END IF
	IF ISNULL(dwsyntax) THEN RETURN ""
	RETURN dwsyntax
END IF

IF pos(ls_formlib,"\") = 0 THEN ls_formlib = ls_templates + ls_formlib
IF NOT FIleExists(ls_formlib) THEN 
	IF lb_ask THEN
		//this.trigger event ue_unzip_mfz(ls_fname)
		Messagebox("Get Syntax","Form library not found for " + ls_formlib)
	END IF
	//ls_formlib = ls_template + ProfileString(is_formini,ls_fname,"Form","11")
	//RETURN 0
	IF NOT FIleExists(ls_formlib) THEN RETURN ""
END IF
dwsyntax = LibraryExport(ls_formlib, ls_ptype + ls_fname, ExportDataWindow!)
IF ISNULL(dwsyntax) OR dwsyntax = "" THEN 
	IF ls_ptype = "pw_" THEN 
		ls_ptype = "dw_"
		dwsyntax = LibraryExport(ls_formlib, ls_ptype + ls_fname, ExportDataWindow!)
	END IF
	IF ISNULL(dwsyntax) OR dwsyntax = "" THEN 
		IF lb_ask THEN
			Messagebox("Get Syntax","Error loading " + ls_ptype + ls_fname + " for " + ls_formlib)
			//SetProfileString(is_formini,ls_fname,"Update","Yes")
			//SetProfileString(is_formini,ls_fname,"Form",ls_formlib)
			//ls_formlib = this.trigger event ue_unzip_mfz(ls_Fname)
			lb_ask = FALSE
			RETURN ""
			dwsyntax = LibraryExport(ls_formlib, ls_ptype + ls_fname, ExportDataWindow!)
		END IF
	END IF
END IF	
IF ISNULL(dwsyntax) OR dwsyntax = "" THEN 
	IF lb_ask THEN
		Messagebox("Load Form-Get Syntax","Library can not find form " + ls_ptype +  ls_fname + " in " + ls_formlib)
	END IF
END IF
IF ISNULL(dwsyntax) THEN RETURN ""
RETURN dwsyntax
end event

event type string ue_print_web(long ll_job);string dwsyntax, ls_tempdir, errorbuffer
integer rtncode, li
boolean lb_add = FALSE
string ls_ptype = "pw_"

ls_tempdir = get_dir("Templates","")
IF FileExists(ls_tempdir + "\sscgsrd\" + ls_ptype + ls_formname + ".srd") THEN
	FOR li = 1 to 10
		IF li = 1 THEN
			dwsyntax = get_dwsyntax(ls_tempdir + "\sscgsrd\" + ls_ptype + ls_formname + ".srd")
		ELSE
			IF FileExists(ls_tempdir + "\sscgsrd\" + ls_ptype + ls_formname + string(li) + ".srd") THEN
				dwsyntax = get_dwsyntax(ls_tempdir + "\sscgsrd\" + ls_ptype + ls_formname + string(li) + ".srd")
			ELSE
				EXIT
			END IF
		END IF
		rtncode = this.create(dwsyntax,ErrorBuffer)
		IF rtncode = 1 THEN
			this.trigger event ue_print_basic(ll_job,dwsyntax)
		ELSE
			IF li = 1 THEN
				Messagebox("Print Web Form","Problem Loading " +  ls_formname +  " " + ErrorBuffer)
				RETURN "Problem Loading " +  ls_formname +  " " + ErrorBuffer
			END IF
		END IF
	NEXT
ELSE
	Messagebox("Print Web Form","Can't find " + ls_tempdir + "\sscgsrd\" + ls_ptype + ls_formname + ".srd")
	RETURN "Can't find " + ls_tempdir + "\sscgsrd\" + ls_ptype + ls_formname + ".srd"
END IF


RETURN ""


end event

event ue_print_basic(long ll_job, string pwsyntax);string ErrorBuffer, dwsyntax, ls_name, ls_error = "",ls_return, ls_richtext
string ls_logo, ls_height, ls_tag, ls_tname
integer rtncode, li, li_col, lx, ly, li_floc
datawindow ldw
ldw = this

IF pwsyntax <> "" THEN
	IF ll_job = -1 THEN
		open(w_report_screen)
		ldw = w_report_screen.dw_report
		w_report_screen.dw_report.modify("DataWindow.Print.Preview = Yes")
	END IF

	rtncode = ldw.create(pwsyntax,ErrorBuffer)
	IF rtncode = 1 THEN
//		IF rte_control.visible THEN
//			IF FileExists(ls_rtename) THEN
//				IF ldw.InsertDocument(ls_rtename,FALSE, FileTypeRichText!) <> 1 THEN
//					Messagebox("Print Job","Problem inserting " + ls_rtename)
//				END IF
//			ELSE
//				Messagebox("Print Job","RTE File " + ls_rtename + " not found")
//			END IF
//
//			//ls_richtext = rte_control.CopyRTF(FALSE,Detail!)
//			//ldw.PasteRTF(ls_richtext)
//		ELSE
		FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
			ls_name = ldw.Describe("#" + string(li) + ".Name")
			li_col = dw_defaultw.trigger event ue_check_field(dw_defaultw,ls_name)
			FOR ly = 1 to dw_defaultw.rowcount()
				IF ly > ldw.rowcount() THEN ldw.insertrow(0)
				IF Left(ls_name,6) = "photo_" THEN this.trigger event ue_set_picture(ls_name,ly,ldw)
				IF Left(ls_name,4) = "logo" THEN 
					li_floc = dw_defaultw.trigger event ue_check_field(dw_defaultw,ls_name)
					IF li_floc > 0 THEN
						ls_logo = this.trigger event ue_print_logo(dw_defaultw.object.data[ly,li_floc])
						IF NOT ISNULL(ls_logo) THEN ldw.setitem(ly,li,ls_logo)
						ls_name = "logo"
					END IF
				END IF
				CHOOSE CASE ls_name
				CASE "logo"
//					IF dw_defaultw.trigger event ue_check_field(dw_defaultw,"logo") > 0 THEN
//						ls_logo = this.trigger event ue_print_logo(dw_defaultw.object.logo[ly])
//						IF NOT ISNULL(ls_logo) THEN ldw.setitem(ly,li,ls_logo)
//					END IF						
				CASE "logopage"
					ldw.setitem(ly,li,"Page:  "  + string(li_Formnum))
				CASE ELSE
//					li_floc = dw_defaultw.trigger event ue_check_field(dw_defaultw, Left(ls_name,len(ls_name) - 1) + "xx")
//					IF li_floc > 0 THEN	
//						ldw.setitem(ly,li,dw_defaultw.object.data[ly,li_floc])
//					ELSE
						IF li_col > 0 THEN
							ldw.setitem(ly,li,dw_defaultw.object.data[ly,li_col])
						ELSE
							ls_error += "~r" + ls_name
						END IF
//					END IF
				END CHOOSE
			NEXT
		NEXT
//		END IF
		ldw.Sort()
		ldw.GroupCalc()
		ldw.modify("DataWindow.Print.Preview = YES")
		CHOOSE CASE ll_job
		CASE -2
		CASE -1
		CASE 0
			IF dw_defaultw.rowcount() > 0 THEN ldw.Print()
		CASE ELSE
			IF dw_defaultw.rowcount() > 0 THEN PrintDataWindow(ll_job,this)
		END CHOOSE
	ELSE
		Messagebox("Form","Error loading " + w_forms_main.i_active_sheet.ls_library  + "-pw_" + ls_formname)
	END IF

//	IF ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormError","NO") = "YES" THEN
//		this.trigger event ue_cbx_report(ldw)
//		IF ls_error <> "" THEN
//			Messagebox("Form " + ls_formname,"Error retrieving the following fields: " + ls_error)
//		END IF
//	END IF
END IF

end event

event ue_print_report;PrintSetup()
this.trigger event ue_print_all(0)
end event

event ue_addnew;call super::ue_addnew;Integer li
String ls_name, ls_desc

FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_name = this.Describe("#" + string(li) + ".Name")
	CHOOSE CASE ls_name
	CASE "zrecno"
		ls_desc = String(Year(Today())) + "." + string(this.rowcount())
		this.setitem(this.rowcount(),li,ls_desc)
	END CHOOSE
NEXT
end event

type dw_defaultw from uo_datawindow within uo_forms_sheet
event ue_values ( )
event ue_import_mpf ( )
event ue_export_mpf ( boolean lb_replace )
event type integer ue_check_field ( datawindow ldw,  string ls_field )
event type integer get_page_count ( string ls_type )
event ue_load_form ( string ls_fname )
event ue_form_error ( )
event ue_setitem ( string ls_field,  string ls_item,  string ls_ctype,  integer li_row )
event ue_correct_form ( )
event ue_display_pictures ( boolean lb_show )
event type integer ue_print_pdf ( ref n_cst_printer adobe_reader,  string ls_pdfname,  string ls_pages )
event ue_set_page ( datawindow ldw )
event type boolean ue_validate ( string ls_pagename )
event ue_setup_ddw ( string ls_field )
event type string ue_setup_helplist ( string ls_field,  decimal li_id )
event ue_copy_picture ( string ls_field,  integer li_row )
event ue_set_picture ( string ls_field,  integer li_row )
event type string ue_set_defaults ( string ls_tab_name )
event type string ue_setup_recs ( string ls_field,  decimal li_id )
event type integer ue_check_tag ( datawindow ldw,  string ls_field )
event type string ue_get_photoname ( string ls_field,  integer li_row,  string ls_ext )
event type integer ue_photocount ( )
event type boolean ue_spellcheck ( )
event ue_load_buildings ( string ls_field,  string ls_location )
event type string ue_button_item ( string ls_tag,  string ls_item )
event type string ue_create_word ( string ls_new )
event type integer ue_check_dbfield ( datawindow ldw,  string ls_field )
event type string ue_check_options ( string ls_field,  string ls_item )
event type string ue_parse_form ( string ls_filename,  integer li_no,  integer li_count,  integer li_form )
event ue_add_locations ( string ls_location,  string ls_building )
event type string ue_validate_group ( string ls_group )
event type string ue_validate_dependency ( string ls_type,  string ls_data,  string ls_group )
event type boolean ue_validate_value ( string ls_type,  string ls_data )
event type boolean ue_validate_old ( string ls_pagename )
event type integer ue_get_dependency ( string setting )
event ue_validation_report ( )
event ue_validate_keys ( )
event type integer get_keyvalue ( string ls_key )
event type string ue_wordini ( string ls_test )
event type string ue_create_excel ( string ls_new )
integer y = 32
integer width = 2592
integer height = 1744
integer taborder = 10
boolean hscrollbar = true
boolean auto_insert = true
end type

event ue_values();//Messagebox("Values","Library:  " + ls_library + "~r~nFlibrary:  " + ls_flibrary)

end event

event ue_import_mpf();//integer li_file, li_length, lpos,rpos, li, rowpos
//string ls_record, ls_item = "", ls_field, ls_ctype, ls_mpftype
//boolean lb_continue = TRUE, lb_validate
//
//this.insertrow(0)
//ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + "mpf"
////IF li_total > 1 THEN
////	IF FileExists(Left(ls_filename,len(ls_filename) - 3) + string(li_page)) THEN
////		ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + string(li_page)
////	END IF
////END IF
//
//st_status.text = "Opening " + ls_mpftype
//ls_cdir = get_pathname(ls_mpftype)
//li_file = FileOpen(ls_mpftype)
//li_length = FileRead(li_file,ls_record)
//DO WHILE li_length >= 0
//	IF lb_continue THEN
//		IF ls_record = "!" THEN 
//			lb_validate = TRUE
//			li_length = FileRead(li_file,ls_record)
//		ELSE
//			IF Trim(ls_record) = "" THEN
//				li_length = FileRead(li_file,ls_record)
//			END IF
//		END IF
//		rpos = pos(ls_record,"<")
//		lpos = pos(ls_record,">")
//		IF lpos > 0 THEN
//			ls_field = Mid(ls_record,rpos + 1, lpos - rpos - 1)
//			ls_item = ""
//		END IF
//		IF rpos > 0 THEN
//			ls_ctype = Left(ls_record, rpos - 1)
//		END IF
//	END IF
//	IF li_length = 0 THEN
//		ls_item += "~r~n"
//	ELSE
//		IF ls_ctype = "char(32766)" THEN
//			FOR li = lpos + 1 to len(ls_record)
//				CHOOSE CASE mid(ls_record,li,1)
//					CASE "|"
//						ls_item += "~r~n"
//					CASE ELSE
//						ls_item += mid(ls_record,li,1)
//				END CHOOSE
//			NEXT
//		ELSE
//			ls_item += Mid(ls_record, lpos + 1, len(ls_record) - lpos) 
//		END IF			
//	END IF
//	IF Right(ls_item,1) = "~~" THEN
//		ls_item = Left(ls_item,len(ls_item) - 1)
//		rowpos = pos(ls_field,"@")
//		IF rowpos > 0 THEN
//			CHOOSE CASE Left(ls_field,5)
//			CASE "form2"
//				this.trigger event ue_setitem(dw_page2,Mid(ls_field,7,rowpos - 7),ls_item,ls_ctype,&
//					integer(right(ls_field,len(ls_field) - rowpos)))
//			CASE "form3"
//				this.trigger event ue_setitem(dw_page3,Mid(ls_field,7,rowpos - 7),ls_item,ls_ctype,&
//					integer(right(ls_field,len(ls_field) - rowpos)))
//			CASE "form4"
//				this.trigger event ue_setitem(dw_page4,Mid(ls_field,7,rowpos - 7),ls_item,ls_ctype,&
//					integer(right(ls_field,len(ls_field) - rowpos)))
//			END CHOOSE
//		ELSE
//			this.trigger event ue_setitem(this,ls_field,ls_item,ls_ctype,1)
//		END IF
//		lb_continue = TRUE
//	ELSE
//		lb_continue = FALSE
//	END IF
//	li_length = FileRead(li_file,ls_record)
//LOOP
//IF ls_record = "~~" THEN
//	IF UPPER(Left(ls_ctype,4)) = "CHAR" THEN
//		this.setitem(1,ls_field,ls_item)
//	END IF
//END IF
//FileClose(li_file)
//st_status.text = ls_mpftype
//iF lb_validate THEN validate_all()
//IF Right(ls_filename,3) = "XML" THEN
//	FileDelete(ls_mpftype)
//END IF
//	
//
end event

event ue_export_mpf(boolean lb_replace);//integer li_file, li_length, li, lx
//string ls_record, ls_item, ls_field, ls_ctype, ls_memo, ls_mpftype, ls_problem
//boolean lb_save = TRUE
//
//IF NOT validate_all() THEN 
//	ls_problem = "!"
//ELSE
//	ls_problem = ""
//END IF
//
////IF li_total > 1 THEN
//	//ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + string(li_page)
////ELSE
//	ls_mpftype = ls_filename
////END IF
//
//st_status.text = "Saving " + ls_mpftype 
//
//IF lb_replace THEN
//	li_file = FileOpen(ls_mpftype,LineMode!,Write!,LockReadWrite!,Replace!)
//ELSE
//	li_file = FileOpen(ls_filename,LineMode!,Write!,LockReadWrite!,Replace!)
//END IF
//
//FileWrite(li_file,ls_problem)
//FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
//	ls_field = this.Describe("#" + string(li) + ".Name")
//	ls_ctype = this.Describe("#" + string(li) + ".ColType")
//	CHOOSE CASE UPPER(Left(ls_ctype,4))
//		CASE "DATE"
//			ls_item = string(this.object.data[1,li],"mm/dd/yy")
//		CASE "CHAR"
//			IF left(ls_field,6) = "photo_" THEN
//				ls_item = get_filename(string(this.object.data[1,li]))
//			ELSE
//				ls_item = string(this.object.data[1,li])
//			END IF
//		CASE ELSE
//			ls_item = string(this.object.data[1,li])
//	END CHOOSE
//	IF ls_ctype = "char(32766)" THEN
//		ls_memo = ""
//		FOR lx = 1 to len(ls_item)
//			CHOOSE CASE asc(mid(ls_item,lx,1))
//			   CASE 10
//				CASE 12,13
//					ls_memo += "|"
//				CASE ELSE
//					ls_memo += mid(ls_item,lx,1)
//			END CHOOSE
//		NEXT
//		ls_item = ls_memo
//	END IF
//	IF FileWrite(li_file,ls_ctype + "<" + ls_field + ">" + ls_item + "~~") < 0 THEN
//		lb_save = FALSE
//		Messagebox("FileWrite","Error writing " + ls_field)
//	END IF
//NEXT
//
//IF lb_save THEN
//	uo_files uo_load
//	uo_load = CREATE uo_files
//	st_status.text = "Saving form 2 " + ls_mpftype
//	uo_load.trigger event save_dw(dw_page2,li_file,"form2",TRUE)
//	st_status.text = "Saving form 3 " + ls_mpftype
//	uo_load.trigger event save_dw(dw_page3,li_file,"form3",TRUE)
//	st_status.text = "Saving form 4 " + ls_mpftype
//	uo_load.trigger event save_dw(dw_page4,li_file,"form4",TRUE)
//	st_status.text = "Saving form 5 " + ls_mpftype
//	uo_load.trigger event save_dw(dw_page5,li_file,"form5",TRUE)
//	DESTROY uo_files	
//END IF
//FileClose(li_file)
//
//IF lb_save THEN
//	urows = 1
//	trows = 0
//	this.ResetUpdate()
//	IF NOT lb_replace THEN
//		IF li_total > 1 THEN	FileDelete(ls_mpftype)
//	END IF
//END IF
//
//
//st_status.text = "Complete " + ls_mpftype
//
//IF ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormInfo","") = "YES" THEN
//	this.trigger event ue_form_error()
//END IF
//
//
end event

event type integer ue_check_field(datawindow ldw, string ls_field);string ls_bfield, ls_dfield, ls_btype,ls
integer li, li_found = 0, li_count

IF not lb_OK THEN RETURN 0
//IF ls_field = "logo" THEN RETURN 1
IF ls_field = "?" THEN 
	Messagebox("Field Error","Problem loading field")
	RETURN 0
END IF
//IF ldw.rowcount() = 0 THEN RETURN 0

ls_btype = ldw.Describe(ls_field + ".ColType")
IF ls_btype <> "!" THEN
	ls = ldw.Describe(ls_field + ".ID")
	IF Integer(ls) > 0 THEN RETURN integer(ls)
END IF

FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
	ls_bfield = ldw.Describe("#" + string(li) + ".Name")
	IF ls_field = ls_bfield THEN RETURN li
NEXT


RETURN li_found
end event

event type integer get_page_count(string ls_type);//Boolean lb_done = FALSE
//integer li_count = 1
//string dwsyntax
//DO UNTIL lb_done
//	li_count += 1
//	dwsyntax = LibraryExport(ls_library, &
//		ls_type + "_" + ls_form + string(li_count), ExportDataWindow!)
//	IF ISNULL(dwsyntax) OR dwsyntax = "" THEN lb_done = TRUE
//LOOP
////em_pages.MinMax = ("1 ~~ " + string(li_count - 1))
//IF ls_type = "dw" THEN
//	IF li_count > 2 THEN
//		htb_pages.MaxPosition = li_count - 1
//		htb_pages.visible = TRUE
//		st_pages.visible = TRUE
//	END IF
//END IF
//RETURN li_count - 1
RETURN 0
end event

event ue_load_form(string ls_fname);//string dwsyntax, ErrorBuffer, ls_message
//integer rtncode
//
//dwsyntax = LibraryExport(ls_library, "dw_" + ls_formname, ExportDataWindow!)
//
//IF ISNULL(dwsyntax) OR dwsyntax = "" THEN
//	ls_flibrary = set_inifiles(w_forms_main.i_active_sheet.is_formini,"Form Library Name",ls_formname,"Form",ls_formname,TRUE)
//	//Messagebox("Form","Error loading " + ls_library  + " Form:dw_" + ls_form)
//ELSE	
//	//ls_message = setup_print_returns(dwsyntax)
//	//print_error(ls_message)
//	rtncode = this.create(dwsyntax,ErrorBuffer)
//	//this.trigger event ue_correct_form()
//	Boolean lb_done
//	Integer li_count = 1
//	DO UNTIL lb_done
//		li_count += 1
//		dwsyntax = LibraryExport(ls_library, "dw_" + ls_formname + string(li_count), ExportDataWindow!)
//		IF ISNULL(dwsyntax) OR dwsyntax = "" THEN 
//			lb_done = TRUE
//		ELSE
//			CHOOSE CASE li_count
//			CASE 2
//				rtncode = dw_page2.create(dwsyntax,ErrorBuffer)
//				dw_page2.insertrow(0)
//			CASE 3
//				rtncode = dw_page3.create(dwsyntax,ErrorBuffer)
//				dw_page3.insertrow(0)
//			CASE 4
//				rtncode = dw_page4.create(dwsyntax,ErrorBuffer)
//				dw_page4.insertrow(0)
//			CASE 5
//				rtncode = dw_page5.create(dwsyntax,ErrorBuffer)
//				dw_page5.insertrow(0)
//			CASE ELSE
//				Messagebox("Load Form", string(li_count) + " form not found")
//			END CHOOSE
//		END IF		
//	LOOP
//
//	IF rtncode = 1 THEN
//		IF FileExists(ls_filename) THEN
//			CHOOSE CASE UPPER(Right(ls_filename,3))
//				CASE "MPF"
//					this.trigger event ue_import_mpf()
//				CASE ELSE
//					this.importfile(ls_filename)
//			END CHOOSE
//		ELSE
//			CHOOSE CASE UPPER(Right(ls_filename,3))
//				CASE "XML"
//					this.trigger event ue_import_mpf()
//				CASE ELSE
//					this.trigger event ue_addnew()
//			END CHOOSE
//		END IF
//	ELSE
//		Messagebox("Form","Error loading " + ls_library  + "-dw" + ls_form)
//	END IF
//	this.trigger event ue_zoom(100)
//END IF
//
//
end event

event ue_form_error();integer li_file, li_length, li, lx, li_count = 0
string ls_record, ls_item, ls_field, ls_ctype, ls_memo, ls_mpftype, ls_dtype, ls_error, ls_bfield
string ls_name

IF this.dataobject = "" THEN RETURN
ls_mpftype = "c:\testform.txt"

li_file = FileOpen(ls_mpftype,LineMode!,Write!,LockReadWrite!,Replace!)

FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(li) + ".DBName")
	ls_ctype = this.Describe("#" + string(li) + ".ColType")
	ls_name = this.Describe("#" + string(li) + ".Name")
	
	//ls_field = this.Describe("#" + string(li) + ".Dbname")
	ls_error = ""
	FOR lx = li + 1 to Integer(this.Object.DataWindow.Column.Count)
		ls_bfield = this.Describe("#" + string(lx) + ".DBName")
		IF ls_field = ls_bfield THEN 
			ls_error = " DUPLICATE " + string(lx)
			li_count += 1
		END IF
	NEXT
	IF ls_error = "" THEN
		FOR lx = li + 1 to Integer(this.Object.DataWindow.Column.Count)
			ls_bfield = this.Describe("#" + string(lx) + ".Name")
			IF ls_name = ls_bfield THEN 
				ls_error = " DUPLICATE NAME" + string(lx)
				li_count += 1
			END IF
		NEXT
	END IF
	//ls_item = string(this.object.data[1,li])
	dw_info.insertrow(0)
	dw_info.object.name[li] = ls_name
	dw_info.object.dbname[li] = ls_Field
	dw_info.object.dbtype[li] = ls_ctype
	dw_info.object.tabse[li] = this.Describe("#" + string(li) + ".TabSequence")
	dw_info.object.error[li] = ls_error

	IF FileWrite(li_file,string(li) + ") " + ls_name + "=" + ls_field + "...." + ls_ctype + ">" + ls_error) < 0 THEN
		Messagebox("FileWrite","Error writing " + ls_field)
	END IF
NEXT

FileClose(li_file)
dw_info.visible = TRUE
IF li_count > 0 THEN 
	Messagebox("Dup Fields","Duplicate fields found")
	//run("notepad " + ls_mpftype)
ELSE
	//Messagebox("Dup Fields","No duplicate fields found")
END IF

end event

event ue_setitem(string ls_field, string ls_item, string ls_ctype, integer li_row);string ls_logo, ls_options, ls_btag, ls_dtype
integer li_find, lpos, rpos, lz, li_floc
boolean lb_continue = FALSE
IF pos(ls_field,".") > 0 THEN
	li_row = Integer(Right(ls_Field,len(ls_Field) - pos(ls_Field,".")))
	ls_field = Left(ls_field,pos(ls_field,".") - 1)
END IF
	
li_floc = this.trigger event ue_check_field(this,ls_field)
IF li_floc > 0 THEN
	lb_continue = TRUE
ELSE
	li_floc = this.trigger event ue_check_dbfield(this,ls_field)
	IF li_floc > 0 THEN
		//ls_field = ls_dfield
		lb_continue = TRUE
	END IF
END IF

IF lb_continue THEN
	IF li_row > this.rowcount() THEN 
		this.insertrow(0)
		//vtb_1.visible = TRUE
		//vtb_1.MaxPosition = li_row
	END IF
	ls_dtype = this.describe("#" + string(li_floc) + ".coltype")
	IF UPPER(ls_ctype) = "PHOTO" THEN ls_dtype = "photo"
	CHOOSE CASE UPPER(Left(ls_dtype,4))
	CASE "CHAR"
		IF left(ls_field,6) = "photo_" THEN
			ls_item = w_forms_main.i_active_sheet.ls_cdir + ls_item
			//w_forms_main.i_active_sheet.lb_photo = TRUE
			IF this.trigger event ue_check_field(this,"tabthumbs") > 0 THEN
				IF this.object.tabthumbs[li_row] = "TRUE" THEN
					IF FileExists(w_forms_main.i_active_sheet.ls_cdir + "T" + ls_item) THEN
						ls_item = w_forms_main.i_active_sheet.ls_cdir + "T" + ls_item
					END IF
				END IF
			END IF
			this.setitem(li_row,ls_field,ls_item)
			this.Modify(ls_field + ".BitMapName = No")
			//this.trigger event ue_set_picture(ls_field, li_row)
		ELSE
			ls_item = this.trigger event ue_check_options(ls_field,ls_item)
			IF pos(ls_field,"zlocation") > 0 THEN this.trigger event ue_load_buildings(ls_field, ls_item)
			CHOOSE CASE ls_field
			CASE "logo"
				this.setitem(li_row,li_floc,dw_report.trigger event ue_print_logo(this.object.logo[li_row]))
			CASE "tabrte"
//				ls_item = w_forms_main.i_active_sheet.ls_cdir + ls_item
//				ls_rtename = ls_item
//				IF FileExists(ls_item) THEN
//					rte_control.InsertDocument(ls_item,TRUE, FileTypeRichText!)
//				ELSE
//					Messagebox("Set Item","RTE File " + ls_item + " not found")
//				END IF
			CASE "q1","q2","q3", "q4","q5"
				IF ProfileString(gs_ini,"FORMS",ls_field + "Ask","NO") = "NO" THEN 
					ls_item = set_ini("Question for " + ls_field,"FORMS",ls_field,"",TRUE)
					SetProfileString(gs_ini,"FORMS",ls_field + "Ask","YES")
				END IF
				this.setitem(li_row,li_floc,ls_item)
			CASE ELSE
				IF this.setitem(li_row,li_floc,ls_item) <> 1 THEN
					Messagebox("Loading Field",ls_field + " does not exist")
				END IF
			END CHOOSE
		END IF
	CASE "DECI"
		this.setitem(li_row,li_floc,dec(ls_item))
	CASE "NUMB"
		IF this.setitem(li_row,li_floc,long(ls_item)) <> 1 THEN
			this.setitem(li_row,li_floc,ls_item)
		END IF
	CASE "DATE"
		this.setitem(li_row,li_floc,date(ls_item))
	CASE "PHOT"
		IF this.trigger event ue_check_field(this,"tabthumbs") > 0 THEN
			IF this.object.tabthumbs[li_row] = "TRUE" THEN
				IF FileExists(w_forms_main.i_active_sheet.ls_cdir + "T" + ls_item) THEN
					ls_item = w_forms_main.i_active_sheet.ls_cdir + "T" + ls_item
				END IF
			END IF
		END IF
		IF ls_item = "" THEN
			this.setitem(li_row,ls_field,"")
		ELSE
			this.setitem(li_row,get_filename(ls_field),ls_item)
			this.Modify(ls_field + ".BitMapName = No")
			open(w_picture_set)
			li_find = search_photo(ls_field)
			w_picture_set.set_picture(this,li_row,ls_field,ls_item,2907,1336)
			close(w_picture_set)
		END IF
	CASE "QUES"
		IF ProfileString(gs_ini,"FORMS",ls_field + "Ask","NO") = "NO" THEN 
			set_ini("Question for " + ls_item,"FORMS",ls_field,"",TRUE)
			SetProfileString(gs_ini,"FORMS",ls_field + "Ask","YES")
		END IF
		ls_item = ProfileString(gs_ini,"FORMS",ls_field,"")
		this.setitem(li_row,li_floc,ls_item) 
	CASE ELSE
		Messagebox("Form","Can not load type " + ls_ctype)
	END CHOOSE
ELSE
	CHOOSE CASE ls_field
	CASE "version"
		is_version = ls_item
	CASE "tabname"
		parent.Text = ls_item
	END CHOOSE

END IF

end event

event ue_correct_form();Integer li
String ls_name, ls_error, Errorbuffer,dwsyntax
FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_name = this.Describe("#" + string(li) + ".Name")
	ls_error = this.Modify("#" + string(li) + ".DBName='" + ls_name + "'")
	IF ls_error <> "" THEN Messagebox("Error", ls_error)
NEXT

dwsyntax = this.Describe("DataWindow.Syntax")
LibraryImport(w_forms_main.i_active_sheet.ls_library, "test", ImportDataWindow!, &
	dwsyntax, ErrorBuffer)


end event

event ue_display_pictures(boolean lb_show);Integer lx
String ls_field, ls_answer
IF lb_show THEN
	ls_answer = "Yes"
ELSE
	ls_answer = "No"
END IF
IF NOT lb_ok THEN RETURN
FOR lx = 1 to Integer(this.Object.Datawindow.Column.Count)
	ls_field = this.Describe("#" + string(lx) + ".Name")
	IF Left(ls_field,6) = "photo_" THEN
		this.Modify(ls_field + ".BitMapName = " + ls_answer)
	END IF
NEXT


end event

event type integer ue_print_pdf(ref n_cst_printer adobe_reader, string ls_pdfname, string ls_pages);////this.trigger event ue_zoom(100)
////IF li_total = 1 THEN
////	IF this.rowcount() > 0 THEN
////		IF printsetup() = 1 THEN dw_print.print()
////	ELSE
////		Messagebox("Print","No records to print")
////	END IF
////ELSE
//Boolean lb_combine = FALSE
//
//	IF ls_pdfname = "" THEN
//		lb_combine = TRUE
//		ls_pdfname = Left(ls_filename,len(ls_filename) - 4)
//	ELSE
//		w_forms.visible = FALSE		
//	END IF
//	integer li_count, li_start
//	li_count = this.trigger event get_page_count("pw")
//	//openwithparm(w_ask,"Print Page (" + string(li_count) + ")/ALL")
//	CHOOSE CASE ls_pages
//	CASE "ALL"
//		li_start = 1
//	CASE ELSE
//		IF integer(message.stringparm) > 0 THEN
//			IF integer(message.stringparm) <= li_count THEN
//				li_start = integer(message.stringparm)
//				li_count = li_start
//			ELSE
//				RETURN 0
//			END IF
//		ELSE
//			RETURN 0
//		END IF
//	END CHOOSE
//	//printsetup()
//	long ll_job
//	//ll_job = PrintOpen("Form " + ls_filename)
//	FOR li_page = li_start to li_count
//		st_status.text = "Printing " + string(li_page) + " of " + string(li_count)
//		IF li_page = 1 THEN
//			dw_print.trigger event ue_load_form(ls_form)
//		ELSE
//			dw_print.trigger event ue_load_form(ls_form + string(li_page))
//		END IF			
//		IF dw_print.rowcount() > 0 THEN
//			adobe_reader.of_print2pdf(dw_print,ls_pdfname + string(li_page) + ".pdf")
//			adobe_reader.ue_addfile(ls_pdfname + string(li_page) + ".pdf",TRUE)
//			//dw_print.Print(FALSE)
//		END IF
//		//PrintDataWIndow(ll_job,dw_print)
//	NEXT
//	//PrintClose(ll_job)
//IF lb_combine THEN 
//	adobe_reader.ue_combine_pdf(ls_pdfname + ".pdf")
//	st_status.text = "Printing Complete"
//ELSE
//	close(w_forms)
//END IF
//RETURN li_count
////END IF
RETURN 0
end event

event ue_set_page(datawindow ldw);integer li_no
decimal ld_page
li_no = this.trigger event ue_check_field(ldw,"li_page")

IF li_no > 0 THEN
	IF ldw.rowcount() > 1 THEN
		ld_page = Dec(ldw.object.data[ldw.rowcount() -1, li_no])
		ldw.setitem(ldw.rowcount(),li_no,ld_page + .01)
	END IF
END IF
	

end event

event type boolean ue_validate(string ls_pagename);integer li, li_return, colnum, li_count, lx
Long li_prt
String setting, ls_field, ls_error = "", ls_vempty, ls_vopt, ls_valid, ls_ctype, ls_visible
String ls_value, ls_tag[], ls_message
Boolean lb_found = FALSE
IF NOT w_forms_main.i_active_sheet.lb_check_validation THEN RETURN TRUE
IF this.rowcount() = 0 THEN 
	Messagebox("Form is not complete","Blank Page is found for " + is_tabname)
	RETURN TRUE
END IF

this.accepttext()	
IF NOT lb_validate THEN RETURN TRUE
IF this.rowcount() = 0 THEN RETURN TRUE

ls_vempty = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","VEmpty","16777215")
ls_valid = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Valid","12632256")
ls_vopt = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Vopt","16777215")


FOR li = 1 to Integer(string(this.Object.DataWindow.Column.Count))
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_visible = this.Describe("#" + string(li) + ".Visible")
	ls_value = string(this.object.data[1,li])
	IF ISNULL(ls_value) THEN ls_value = ""
	IF ls_visible = "1" THEN
	setting = this.Describe(ls_field + ".Tag")
	IF pos(setting,"X") > 0 THEN
		IF len(ls_value)  = 0 THEN 
			ls_ctype = ls_vempty
		ELSE
			ls_ctype = ls_valid
		END IF
	END IF		
	IF pos(setting,"A") > 0 THEN
		IF pos(setting,"A") = 1 THEN ls_ctype = ls_vempty
		li_count += 1
		ls_tag[li_count] = mid(setting,pos(setting,"A")+1,2)
		IF len(ls_value)  = 0 THEN 
			ls_ctype = ls_vempty
		ELSE
			ls_ctype = ls_valid
		END IF
	END IF		
	IF pos(setting,"B") > 0 THEN
		IF pos(setting,"B") = 1 THEN ls_ctype = ls_vopt
		li_count += 1
		ls_tag[li_count] = mid(setting,pos(setting,"B")+1,2)
		IF len(ls_value) > 0 THEN ls_ctype = ls_valid
	END IF		
	IF pos(setting,"D") > 0 THEN
		IF pos(setting,"D") = 1 THEN ls_ctype = ls_vopt
		colnum = this.trigger event ue_get_dependency(setting)	
		IF colnum > 0 THEN
			IF colnum > 1000 THEN
				IF NOT ISNULL(string(this.object.data[1,colnum - 1000])) THEN
					CHOOSE CASE string(this.object.data[1,colnum - 1000])
					CASE "0","n","N",""
					CASE ELSE
						IF len(ls_value) > 0 THEN 
							ls_ctype = ls_valid
						ELSE
							ls_ctype = ls_vempty
						END IF
					END CHOOSE
				END IF
			ELSE
				CHOOSE CASE string(this.object.data[1,colnum])
				CASE "0","n","N"
				CASE ELSE
					IF len(ls_value) > 0 THEN 
						ls_ctype = ls_valid
					ELSE
						ls_ctype = ls_vempty
					END IF
				END CHOOSE
			END IF
		END IF
	END IF
	IF pos(setting,"E") > 0 THEN
		ls_ctype = ls_vopt
		colnum = this.trigger event ue_get_dependency(setting)	
		IF colnum > 0 THEN
			IF colnum > 1000 THEN
				IF NOT ISNULL(string(this.object.data[1,colnum - 1000])) THEN
					CHOOSE CASE string(this.object.data[1,colnum - 1000])
					CASE "0","n","N"
						IF len(ls_value) > 0 THEN 
							ls_ctype = ls_valid
						ELSE
							ls_ctype = ls_vempty
						END IF
					END CHOOSE
				END IF
			ELSE
				CHOOSE CASE string(this.object.data[1,colnum])
				CASE "0","n","N"
					IF len(ls_value) > 0 THEN 
						ls_ctype = ls_valid
					ELSE
						ls_ctype = ls_vempty
					END IF
				END CHOOSE
			END IF
		END IF
	END IF	
	IF pos(setting,"G") > 0 THEN
		IF pos(setting,"G") = 1 THEN ls_ctype = "0"
		IF ls_ctype <> ls_vopt THEN
			ls_ctype = this.trigger event ue_validate_group(mid(setting,pos(setting,"G")+1,2))
		END IF
	END IF
	IF setting = "" OR setting = "sp" THEN
		ls_ctype = ls_vopt
		IF NOT ISNULL(this.object.data[1,li]) THEN 
			IF ProfileString(gs_ini,"Utilities","FormError","NO") = "NO" THEN
				ls_ctype = ls_valid
			END IF
		END IF
	END IF
	IF ls_ctype = "" OR setting = "?" THEN
		ls_error = this.Modify(ls_field + ".Background.Color='" + ls_vopt + "'")			
		IF ls_error <> "" THEN Messagebox("Validation " + ls_field , ls_error)
	ELSE		
		ls_error = this.Modify(ls_field + ".Background.Color='" + ls_ctype + "'")			
		IF ls_error <> "" THEN Messagebox("Validation " + ls_field , ls_error)
	END IF
	IF ls_ctype = ls_vempty THEN lb_found = TRUE
//	IF ls_ctype = ls_valid THEN
//		this.Modify(ls_field + ".Color=0")
//	ELSE
//		this.Modify(ls_field + ".Color=255")
//	END IF			
	END IF
NEXT


IF ProfileString(gs_ini,"Utilities","FormError","NO") <> "NO" THEN
	FOR li = 1 to li_count
		FOR lx =  1 to li_count
			IF ls_tag[li] = ls_tag[lx] AND li <> lx THEN
				ls_message +=  "[" + ls_tag[lx] + ")  "
			END IF
		NEXT
	NEXT
	IF ls_message <> "" THEN
		Messagebox("Validation Error Duplication",ls_message)
	END IF
END IF

//IF ProfileString(gs_ini,"Utilities","FormValidation","NO") = "YES" THEN
	//this.trigger event ue_validation_report()
//END IF

IF lb_found THEN 
	IF ls_pagename <> "SETUP" THEN
		Messagebox("Form is not complete","Required fields on " + ls_pagename + " not found." + &
			"  Missing items are in red text or yellow boxes.")
	END IF
END IF
RETURN lb_found
end event

event ue_setup_ddw(string ls_field);DataWindowChild state_child
integer li, rtncode, lx
long ll_customer
String ls_type, ls_options, ls_item = ""

IF len(ls_field) < 3 THEN RETURN
ls_type = Mid(ls_field,2,len(ls_field) -2)

rtncode = this.GetChild(ls_type, state_child)
IF rtncode = -1 THEN RETURN

FOR li = 1 to w_forms_main.i_active_sheet.dw_help.rowcount()
	IF w_forms_main.i_active_sheet.dw_help.object.topic[li] = ls_field THEN
		ls_options = w_forms_main.i_active_sheet.dw_help.object.description[li]
		FOR lx = 1 to len(ls_options)
			IF mid(ls_options,lx,1) = "~~" THEN
				state_child.insertrow(0)
				state_child.setitem(state_child.rowcount(),1,ls_item)
				ls_item = ""
			ELSE
				ls_item += mid(ls_options,lx,1)
			END IF
		NEXT
		state_child.insertrow(0)
		state_child.setitem(state_child.rowcount(),1,ls_item)
	END IF
NEXT


end event

event type string ue_setup_helplist(string ls_field, decimal li_id);integer li, rtncode, lx
long ll_customer
String ls_type, ls_options, ls_item = ""


ls_type = Mid(ls_field,2,len(ls_field) -2)

FOR li = 1 to w_forms_main.i_active_sheet.dw_help.rowcount()
	IF w_forms_main.i_active_sheet.dw_help.object.topicid[li] = li_id THEN
		ls_options = w_forms_main.i_active_sheet.dw_help.object.description[li]
		IF pos(ls_options,"~~") > 0 THEN
			openwithparm(w_list_ddw,ls_options)
		ELSE
			RETURN ls_options
		END IF
	END IF
NEXT

RETURN ""


end event

event ue_copy_picture(string ls_field, integer li_row);string ls_photo, ls_new
long ll_size
ll_size = long(ProfileString(w_forms_main.i_active_sheet.is_formini,"MAIN","PhotoSize","1000")) * 1000
ls_new = Left(w_forms_main.i_active_sheet.ls_filename, len(w_forms_main.i_active_sheet.ls_filename) - 4)
ls_new += "p" + Right(ls_field,len(ls_field) - 6) + string(li_row)
ls_photo = this.trigger event ue_copypicture("",ls_new)
//IF filesize(ls_photo) > ll_size THEN
		//Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
//ELSE
	IF ls_photo <> "" THEN
		this.setitem(li_row,Right(ls_field,len(ls_field) -2),ls_photo)
	END IF
//END IF
end event

event ue_set_picture(string ls_field, integer li_row);string ls_field2, ls_error
integer li_find, li_wh

li_find = search_photo(ls_field)

IF li_find = 0 THEN
	li_find = Upperbound(ls_pic) + 1
	ls_pic[li_find] = ls_field
	li_pwidth[li_find] = integer(this.Describe(ls_field + ".Width"))
	li_pheight[li_find] = integer(this.Describe(ls_field + ".Height"))
END IF

ls_field2 = Right(ls_field,len(ls_field) - pos(ls_field, "_"))
li_find = this.trigger event ue_check_field(this,"w_" + ls_field2)
IF li_find > 0 THEN
	li_wh = this.object.Data[li_row,li_find]
	ls_error = this.Modify(ls_field + ".Width = '" + string(li_wh) + "'")
	IF ls_error <> "" THEN Messagebox("Set Picture Width", &
		ls_field + "-" + string(li_wh) + "~r~n" + ls_error)	
END IF

li_find = this.trigger event ue_check_field(this,"h_" + ls_field2)
IF li_find > 0 THEN
	li_wh = this.object.Data[li_row,li_find]
	ls_error = this.Modify(ls_field + ".Height = '" + string(li_wh) + "'")
	IF ls_error <> "" THEN Messagebox("Set Picture Height", &
		ls_field + "-" + string(li_wh) + "~r~n" + ls_error)	
END IF

end event

event type string ue_set_defaults(string ls_tab_name);string ls_field,  ls_ctype, ls_btag, ls_tag, ls_count = ""
integer li, li_row, ll_r, lx
boolean lb_add = FALSE
lb_loaded = TRUE
IF not lb_OK THEN RETURN ""

IF is_footer_height = "" THEN
	is_footer_height =this.Object.DataWindow.footer.height
	this.object.DataWindow.footer.height = "0"
END IF
IF this.rowcount() = 0 THEN
	lb_add = TRUE
	this.trigger event ue_addnew()
	is_tabname = ls_tab_name
	this.trigger event ue_advanced(4)
END IF
IF pos(ls_tab_name,"^") > 0 THEN
	ls_count = Right(ls_tab_name,len(ls_tab_name) - pos(ls_tab_name,"^"))
	ls_tab_name = Left(ls_tab_name,pos(ls_tab_name,"^") - 1)
END IF
FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_ctype = this.Describe("#" + string(li) + ".ColType")
	ls_tag = this.describe(ls_field + ".Tag")
	IF NOT lb_validate THEN
		IF pos(ls_tag,"X") > 0 THEN lb_validate = TRUE
		IF pos(ls_tag,"A") > 0 THEN lb_validate = TRUE
		IF pos(ls_tag,"B") > 0 THEN lb_validate = TRUE
		IF pos(ls_tag,"G") > 0 THEN lb_validate = TRUE
	END IF
	IF Left(ls_field,6) = "photo_" THEN
		FOR li_row = 1 TO this.rowcount()
			this.trigger event ue_set_picture(ls_field,li_row)
		NEXT
	END IF
	CHOOSE CASE ls_field
	CASE "tabmultiple"
		IF this.object.tabmultiple[1] = "TRUE" THEN lb_multiple = TRUE
	CASE "tabname" 
		ls_tab_name = this.object.tabname[1]
	CASE "tabrte" 
//		rte_control.visible = TRUE
	CASE "tabsketch" 
		IF li_rsketch <> 99 THEN
			IF Profilestring(w_forms_main.i_active_sheet.is_formini,"FORMS","RapidSketch","") = "YES" THEN	li_rsketch = 1
		END IF
	CASE "tabphotoid"
//		IF this.object.tabphotoid[1] = 0 THEN
//			this.object.tabphotoid[1] = w_forms_main.i_active_sheet.u_to_open[1].dw_defaultw.trigger event ue_photocount()
//		END IF
	CASE "recommendations"
		lb_recs = TRUE
	CASE "tabrows"
		ll_r = this.rowcount()
		IF ll_r = 0 THEN 
			this.insertrow(0)
			ll_r = 1
		END IF
		IF ll_r + 1 < integer(this.object.tabrows[1]) THEN
			FOR lx = (ll_r + 1) TO integer(this.object.tabrows[1])
				this.insertrow(0)
			NEXT
		END IF
	END CHOOSE
	IF pos(ls_ctype,"32766") > 0 THEN 
		CHOOSE CASE this.Describe(ls_field + ".TabSequence")
		CASE "?","0"
		CASE ELSE
			IF ls_tag = "?" THEN this.modify(ls_field + ".Tag = 'sp'")
		END CHOOSE
	END IF
NEXT
IF lb_add THEN 
	IF lb_multiple THEN this.deleterow(1)
END IF
this.trigger event ue_validate("SETUP")
IF ls_tab_name = "" THEN ls_tab_name = ls_formname
is_tabname = ls_tab_name 
is_cversion = ProfileString(w_forms_main.i_active_sheet.is_formini,ls_Formname,"CVersion5","")
RETURN ls_tab_name + ls_count
end event

event type string ue_setup_recs(string ls_field, decimal li_id);integer li, rtncode, lx, li_col, li_row, lpos, rpos, li_rectab
//integer li_tab 
long ll_customer
String ls_type, ls_options = "", ls_item = "", ls_help, ls_title = "", ls_return, ls_recs, ls_btag
String ls_bfield
Decimal li_recs[], ld_item, li_start, li_end, ldx

IF w_forms_main.i_active_sheet.dw_rec_list.rowcount() = 0 THEN
	w_forms_main.i_active_sheet.dw_rec_list.trigger event ue_reretrieve()
END IF
IF li_id = 0 THEN
	lpos = pos(ls_field,"_")
	rpos = pos(ls_field,"_",lpos + 1)
	li_id = integer(mid(ls_field,lpos + 1, rpos - lpos - 1))
END IF

//ls_recs = 
ls_btag = this.Describe(ls_field + ".Tag")
ls_bfield = this.trigger event ue_button_item(ls_btag,"recs:")
IF ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormError","") = "YES" THEN 
	Messagebox("Rec Button","Name:  " + ls_field + "~r~nID#:  " + string(li_id) + "~r~nTag:  " + ls_bfield)
END IF
IF ls_bfield <> "" THEN
	ls_bfield += ";"
	li_start = -1
	FOR li = 1 to len(ls_bfield)	
		CHOOSE CASE mid(ls_bfield,li,1)
		CASE ";"
			IF li_start >= 0 THEN
				IF pos(ls_item,".") > 0 THEN
					IF len(ls_item) = pos(ls_item,".") + 3 THEN
						li_end = dec(ls_item) * 1000
						li_start = li_start * 1000
					ELSE
						li_end = dec(ls_item) * 100
						li_start = li_start * 100
					END IF
				ELSE
					li_end = dec(ls_item)
				END IF
				FOR ldx = li_start TO li_end
					IF pos(ls_item,".") > 0 THEN
						li_recs[Upperbound(li_recs) + 1] = round(ldx /100,2)						
					ELSE
						li_recs[Upperbound(li_recs) + 1] = round(li_id + (integer(ldx)/100),2)
					END IF
				NEXT
				li_start = -1
			ELSE
				IF dec(ls_item) > 0 THEN 
					IF pos(ls_item,".") > 0 THEN
						IF len(ls_item) = pos(ls_item,".") + 3 THEN
							ld_item = round(dec(ls_item),3)
						ELSE
							ld_item = round(dec(ls_item),2)
						END IF
					ELSE
						IF len(ls_item) = 3 THEN
							ld_item = round(li_id + (integer(ls_item) / 1000),3)
						ELSE
							ld_item = round(li_id + (integer(ls_item) / 100),2)
						END IF
					END IF
					li_recs[Upperbound(li_recs) + 1] = ld_item
				END IF
			END IF
   			ls_item = ""
		CASE "-"
			li_start = dec(ls_item)
			ls_item = ""
		CASE ELSE
			ls_item += mid(ls_bfield,li,1)
		END CHOOSE
	NEXT
END IF
			
	


FOR li = 1 to w_forms_main.i_active_sheet.dw_rec_list.rowcount()
	IF Integer(w_forms_main.i_active_sheet.dw_rec_list.object.topicid[li]) = li_id THEN
		IF ls_title = "" THEN ls_title = w_forms_main.i_active_sheet.dw_rec_list.object.topic[li]
		IF ls_bfield = "" THEN
			ls_options += w_forms_main.i_active_sheet.dw_rec_list.object.description[li] 
			ls_options += w_forms_main.i_active_sheet.dw_rec_list.object.mandatory[li] + "~~"
		END IF
	END IF	
	FOR lx = 1 TO Upperbound(li_recs)
		IF w_forms_main.i_active_sheet.dw_rec_list.object.topicid[li]	= li_recs[lx] THEN
			ls_options += w_forms_main.i_active_sheet.dw_rec_list.object.description[li] 
			ls_options += w_forms_main.i_active_sheet.dw_rec_list.object.mandatory[li] + "~~"
		END IF
	NEXT
NEXT
//ls_return = message.stringparm
//
li_rectab = w_forms_main.i_active_sheet.dw_formlist.trigger event ue_get_recs()
//IF this.trigger event ue_check_field(this, "tabrecs") > 0 THEN
IF li_rectab > 0 AND this.trigger event ue_check_field(this, "tabrecs") > 0 THEN
	ls_help = this.object.tabrecs[1]
//	li_tab = 0
	IF pos(ls_help,".") > 0 THEN
	//	li_tab = integer(Right(ls_help,len(ls_help) - pos(ls_help,".")))
		ls_help = Left(ls_help,pos(ls_help,".") - 1)
	END IF
	//IF li_tab > 0 THEN
	IF li_rectab > 0 THEN
		openwithparm(w_recs,ls_title + "|" + ls_options)
		//w_recs.li_tab = li_tab
		w_recs.ls_help = ls_help
		w_recs.li_id = li_id
		ls_bfield = this.trigger event ue_button_item(ls_btag,"rmemo:")
		IF ls_bfield <> "" THEN
			w_recs.li_col = this.trigger event ue_check_field(this,ls_bfield)
		ELSE
			w_recs.li_col = this.trigger event ue_check_tag(this,ls_field)
		END IF
		//w_recs.li_current = li_formnum
		w_recs.li_current = ii_tab
		w_recs.li_tab = li_rectab
	END IF
ELSE
	IF ProfileString(w_forms_main.i_active_sheet.is_formini,"Utilities","FormError","") = "YES" THEN 
		Messagebox("Tab Recs","tabrecs field not found in form")
	END IF
END IF


//	IF li_tab = 0 THEN
//		this.trigger event ue_addnew()
//		li_row = this.rowcount()
//		li_col = this.trigger event ue_check_field(this,ls_help)
//		IF li_col > 0 THEN this.setitem(li_row,ls_help,ls_return)
//	ELSE
//		w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event ue_addnew()
//		li_row = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.rowcount()
//		li_col = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
//			ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,ls_help)
//		IF li_col > 0 THEN 
//			w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.setitem(li_row,ls_help,ls_return)
//			li_row = this.rowcount()
//			li_col = this.trigger event ue_check_tag(this,ls_field)
//			IF li_col > 0 THEN
	//			this.setitem(li_row,li_col,"See Recommendations")		
	//		END IF
//		END IF
//	END IF
//END IF
//
RETURN ""


end event

event type integer ue_check_tag(datawindow ldw, string ls_field);string ls_bfield, ls_btag
integer li, li_found, li_count

IF ls_field = "logo" THEN RETURN 1
IF ls_field = "?" THEN 
	Messagebox("Field Error","Problem loading field")
	RETURN 0
END IF
//IF ldw.rowcount() = 0 THEN RETURN 0
FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
	ls_bfield = ldw.Describe("#" + string(li) + ".Name")
	ls_btag = ldw.Describe(ls_bfield + ".Tag")
	IF pos(ls_btag,ls_field) > 0 THEN li_found = li
NEXT


RETURN li_found
end event

event type string ue_get_photoname(string ls_field, integer li_row, string ls_ext);string ls_new
integer li_photoid = 0

ls_new = Left(w_forms_main.i_active_sheet.ls_filename, len(w_forms_main.i_active_sheet.ls_filename) - 4)
ls_new += "p" + Right(ls_field,len(ls_field) - 6)
IF li_row > 1 THEN ls_new += string(li_row)
//IF this.trigger event ue_check_field(this,"tabphotoid") > 0 THEN
//	IF ISNULL(this.object.tabphotoid[1]) THEN this.object.tabphotoid[1] = 0
//	IF this.object.tabphotoid[1] = 0 THEN
//		IF this.trigger event ue_check_field(w_forms_main.i_active_sheet.u_to_open[1].dw_defaultw,"tabphotos") > 0 THEN
//			li_photoid = w_forms_main.i_active_sheet.u_to_open[1].dw_defaultw.object.tabphotos[1]
//			li_photoid += 1
//			w_forms_main.i_active_sheet.u_to_open[1].dw_defaultw.object.tabphotos[1] = li_photoid
//			this.object.tabphotoid[li_row] = li_photoid
//		ELSE
//			li_photoid = w_forms_main.i_active_sheet.ii_tphoto
//			li_photoid += 1
//			w_forms_main.i_active_sheet.ii_tphoto = li_photoid
//			this.object.tabphotoid[li_row] = li_photoid
//		END IF
//	ELSE
//		li_photoid = this.object.tabphotoid[1]
//	END IF
//ELSE
//	Messagebox("Tab Photos","Tabphotoid field not found")
//END IF
//ls_new += string(li_photoid)
ls_new += string(ii_formrow)
IF ls_ext <> "" THEN ls_new += "." + ls_ext

RETURN ls_new
end event

event type integer ue_photocount();integer li_field, li_photos

li_field = this.trigger event ue_check_field(this,"tabphotos")
IF li_field > 0 THEN
	li_photos = this.object.tabphotos[1]
	li_photos += 1
	this.object.tabphotos[1] = li_photos
ELSE
	li_photos = w_forms_main.i_active_sheet.ii_tphoto
	li_photos += 1
	w_forms_main.i_active_sheet.ii_tphoto = li_photos
	//Messagebox("Photo Count","Field 'tabphotos' not found")
END IF
RETURN li_photos
end event

event type boolean ue_spellcheck();integer li, li_return
String setting, ls_field, ls_error = "" , ls_ctype
Boolean lb_found = FALSE, lb_spell
IF this.rowcount() = 0 THEN RETURN FALSE
this.accepttext()	
FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(li) + ".Name")
	setting = this.Describe(ls_field + ".Tag")
	ls_ctype = this.Describe("#" + string(li) + ".ColType")
	lb_spell = FALSE
	IF Pos(setting,"sp") > 0 OR pos(ls_ctype,"32766") > 0 THEN lb_spell = TRUE
	IF ls_field = "tabsketch" THEN lb_spell = FALSE
	IF lb_spell THEN
		li_return = this.trigger event ue_spell(ls_field,1,string(this.object.data[1,li]))
		IF li_return = 2 THEN lb_changed = TRUE
	END IF
NEXT

RETURN lb_found
end event

event ue_load_buildings(string ls_field, string ls_location);string ls_loc, ls_desc
integer lx
IF Integer(Right(ls_field,2)) > 0 THEN
	ls_loc = Right(ls_field,2)
ELSE
	ls_loc = Right(ls_field,1)
END IF
ls_desc = "~t/"
FOR lx = 1 to Upperbound(w_forms_main.i_active_sheet.ls_building)
	IF w_forms_main.i_active_sheet.ls_location[lx] = ls_location THEN
		IF w_forms_main.i_active_sheet.ls_building[lx] <> "<NONE>" THEN
			ls_desc += w_forms_main.i_active_sheet.ls_building[lx] + "~t" + w_forms_main.i_active_sheet.ls_building[lx] + "/"  
		END IF
	END IF
NEXT
this.modify("zbuilding_" + ls_loc + ".values = ~"" + ls_desc + "~"")


end event

event ue_button_item;integer lpos, rpos
string ls_bfield
lpos = pos(ls_tag,ls_item) 
IF lpos > 0 THEN
	rpos = pos(ls_tag,",",lpos)
	IF rpos = 0 THEN rpos = len(ls_tag) + 1
	lpos += len(ls_item)
	ls_bfield = mid(ls_tag,lpos,rpos - lpos)
	RETURN ls_bfield
END IF
RETURN ""
end event

event type string ue_create_word(string ls_new);string ls_answer, ls_location, ls_field, ls_dir, ls_phone, ls_file, ls_filename, ls_ctype, ls_item
string ls_nfield, ls_visible
integer li, li_column, li_row, lx, li_protect_type
Boolean lb_found = FALSE, lb_checkbox = FALSE
OLEObject ole_word

IF pos(ls_filename,"\") = 0 THEN
	ls_dir = set_inifiles(w_forms_main.i_active_sheet.is_formini,"Location of Templates","MAIN","Templates","c:\mgmt4\template",FALSE)
	IF Left(ls_dir,1) <> "\" THEN ls_dir += "\"
	ls_file = ls_dir + ls_formname + ".dot"
ELSE
	ls_file = ls_filename
END IF

IF NOT FileExists(ls_file) THEN
	//Messagebox("Template",ls_file + " not found")
	RETURN "N/F-" + ls_file
END IF

ls_wordini = ls_dir + ls_formname + ".ini"
IF ls_new = "" THEN RETURN ls_file

IF NOT FileExists(ls_wordini) THEN
	Messagebox("INI File",ls_wordini + " not found")
END IF

//ole_word.ConnectToObject(ls_file)
ole_word = CREATE OLEObject
IF ole_word.ConnectToNewObject("word.application") <> 0 THEN
	Messagebox("Error","Microsoft Word is not supported on your computer")
	RETURN ""
END IF

	
IF pos(ls_new,".") > 0 THEN 
	ls_new = Left(ls_new, len(ls_new) -3) + "doc"
ELSE
	ls_new += ".doc"
END IF
//ls_new = dw_attachments.trigger event ue_addfile(ls_new, ls_type)

ole_word.Documents.Open(ls_file)

li_protect_type = ole_word.ActiveDocument.ProtectionType
IF li_protect_type > 0 THEN ole_word.ActiveDocument.Unprotect

IF ls_new <> "" THEN
	FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
		ls_field = this.Describe("#" + string(li) + ".Name")
		ls_ctype = this.Describe("#" + string(li) + ".ColType")
		ls_visible = this.Describe("#" + string(li) + ".Visible")
		ls_item = string(this.object.data[1,li])
		If Isnull(ls_item) THEN ls_item = ""
		ls_nfield = ProfileString(ls_wordini,is_tabname,ls_field,"")
		lb_checkbox = FALSE
		IF ls_visible = "1" AND ls_nfield <> "" THEN
			IF Left(ls_field,6) = "photo_" THEN
				IF FileExists(ls_item) THEN
					IF goto_word(ole_word,ls_nfield) THEN
						ole_word.Selection.InlineShapes.AddPicture(ls_item,FALSE,TRUE)
						//ole_sheet = ole_word.ActiveDocument.InlineShapes.AddPicture(ls_item,FALSE,TRUE)
					END IF
				END IF
			ELSE
				IF ls_nfield = "CHX" THEN
					lb_checkbox = TRUE
					ls_nfield = ProfileString(ls_wordini,is_tabname,ls_field + "-" + ls_item,"")
				END IF
				IF ole_word.ActiveDocument.Bookmarks.Exists(ls_nfield) Then
					ole_word.Application.ActiveDocument.Bookmarks.Item(ls_nfield).Select()
					IF lb_checkbox THEN
						IF ls_nfield <> "" THEN
							ole_word.Application.ActiveDocument.FormFields.Item(ls_nfield).CheckBox.Value = True
						END IF
					ELSE
						ole_word.Selection.TypeText( ls_item)
						//load_word(ole_word,ls_nfield, ls_item) 
					END IF
				ELSE
					IF ls_nfield <> "" THEN
						IF UPPER(ProfileString(gs_ini,"Utilities","FormError","")) = "YES" THEN
							Messagebox("Form Error","Bookmark not found for " + ls_nfield)
							this.Modify(ls_field + ".Background.Color='255'")			
						END IF
					END IF
				END IF
				//load_word(ole_word,ls_nfield, ls_item) 
			END IF
		END IF
	NEXT

//	load_word(ole_word,ls_location, &
	//	this.trigger event ue_get_field(ls_field,1))

IF li_protect_type > 0 THEN ole_word.ActiveDocument.Protect(li_protect_type,True)
ole_word.NormalTemplate.Saved = TRUE
ole_word.ActiveDocument.saveas(ls_new) 
ole_word.quit
END IF

w_waiting.trigger event ue_waiting(long(ProfileString(gs_ini,"WORD","FormsTimer","300000")))

ole_word.DisconnectObject()
DESTROY ole_word

//run_file(ls_new)
RETURN ls_new
	
end event

event type integer ue_check_dbfield(datawindow ldw, string ls_field);string ls_bfield, ls_dfield = ""
integer li, li_found = 0, li_count

IF not lb_OK THEN RETURN 0
//IF ls_field = "logo" THEN RETURN 1
IF ls_field = "?" THEN 
	Messagebox("Field Error","Problem loading field")
	RETURN 0
END IF
//IF ldw.rowcount() = 0 THEN RETURN 0

FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
	ls_bfield = ldw.Describe("#" + string(li) + ".DbName")
	IF ls_field = ls_bfield THEN 
		IF ldw.rowcount() > 0 THEN
			IF ISNULL(ldw.object.data[1,li]) THEN 
				ls_dfield = ldw.Describe("#" + string(li) + ".Name")
				li_found = li
			END IF
		END IF
	END IF
NEXT

RETURN li_found
end event

event type string ue_check_options(string ls_field, string ls_item);string ls_btag
integer lpos, rpos, lz
string ls_options, ls_opt[], ls_new[], ls_test = ""
boolean lb_find = FALSE

ls_btag = this.Describe(ls_field + ".Tag")
lpos = pos(ls_btag,"options:")
// Example to replace small letters with caps  put in   options:Y-y/N-n/
IF lpos > 0 THEN
	lpos += 8
	rpos = pos(ls_btag,";")
	IF rpos = 0 THEN rpos = len(ls_btag)
	ls_options = mid(ls_btag,lpos,  rpos - lpos + 1) + "-"
	FOR lz = 1 to len(ls_options)
		CHOOSE CASE mid(ls_options,lz,1)
		CASE "/"
			ls_opt[Upperbound(ls_opt) + 1] = ls_test
			ls_test = ""
		CASE "-"
			ls_new[Upperbound(ls_new) + 1] = ls_test
			ls_test = ""
		CASE ELSE
			ls_test += mid(ls_options,lz,1)
		END CHOOSE
	NEXT
	FOR lz = 1 TO upperbound(ls_opt)
		IF ls_item = ls_opt[lz] THEN RETURN ls_new[lz]
		IF ls_item = ls_new[lz] THEN lb_find = TRUE
	NEXT
	IF NOT lb_find THEN 
		//Messagebox(ls_Field,ls_item + " not found")
	END IF
END IF
RETURN ls_item

end event

event type string ue_parse_form(string ls_filename, integer li_no, integer li_count, integer li_form);Integer li_file = 0, lx, ly
string ls_tform, ls_template, ls_sscgtemp, ls_newpath, ls_maindir, ls_source, ls_copy
string ls_photo, ls_field, ls_newfile
boolean lb_cont = FALSE

ls_template = ProfileString(w_forms_main.i_active_sheet.is_formini,"Main","Templates","c:\minipro\template")  + "\sscgforms"
ls_sscgtemp = Profilestring(w_forms_main.i_active_sheet.is_formini,"MAIN","Tempdir","C:\sscgtemp")
//IF li_count >= 0 THEN
//	IF FileExists(ls_template + "\" + ls_formname + ".mfz") THEN 
//		li_count += 1
//		li_form = 1
//	ELSE
//		li_form += 1
//	END IF
//ELSE
//	li_count = abs(li_count)
//END IF
//	
//location of original main.mpf
ls_maindir = get_pathname(w_forms_main.i_active_sheet.ls_filename) 
ls_newpath = ls_sscgtemp + "\" +  ls_filename + ".mpq"
CreateDirectory(ls_newpath)
li_file = FileOpen(ls_newpath + "\main.mpf",LineMode!,Write!,LockReadWrite!,Append!)

ls_source = ls_maindir + string(ii_formrow,"00") + ls_formname + ".mpf"
ls_copy = ls_newpath + "\" +string(li_form,"00") + ls_formname + ".mpf"
FileWrite(li_file,  get_filename(ls_copy))
IF FileCopy(ls_source,ls_copy ,TRUE) <> 1 THEN
	Messagebox("Copying Error", "Problem copying " + ls_source +  " to  " + ls_copy)
END IF
ls_source = ls_maindir + "defaults.mpf"
ls_copy = ls_newpath + "\defaults.mpf"
IF FileCopy(ls_source,ls_copy ,TRUE) <> 1 THEN
	Messagebox("Copying Error", "Problem copying " + ls_source +  " to  " + ls_copy)
END IF
FOR lx = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(lx) + ".Name")
	FOR ly = 1 to this.rowcount()
		CHOOSE CASE Left(ls_field,6)
		CASE "photo_" 
			IF FileExists(this.object.data[ly,lx]) THEN
				ls_photo = string(this.object.data[ly,lx])
				ls_source = ls_maindir + get_filename(ls_photo)
				ls_copy = ls_newpath + "\" + get_filename(ls_photo)
				IF FileCopy(ls_source,ls_copy ,TRUE) <> 1 THEN
					Messagebox("Copying Error", "Problem copying " + ls_source +  " to  " + ls_copy)
				END IF
			END IF
		CASE "tabske"
			IF pos(this.object.data[ly,lx],"REF$FILE:") > 0 THEN
				ls_photo = get_filename(right(this.object.tabsketch[lx], len(this.object.tabsketch[lx]) - 9))
				ls_source = ls_maindir + ls_photo
				ls_copy = ls_newpath + "\" + ls_photo
				IF FileCopy(ls_source,ls_copy ,TRUE) <> 1 THEN
					Messagebox("Copying Error", "Problem copying " + ls_source +  " to  " + ls_copy)
				END IF
			END IF
		END CHOOSE
	NEXT
 NEXT
	
FileClose(li_file)
RETURN ls_newpath
end event

event ue_add_locations(string ls_location, string ls_building);IF this.rowcount() = 0 THEN this.trigger event ue_addnew()
IF this.trigger event ue_check_field(this,"zlocation_1") > 0 THEN
	this.object.zlocation_1[1] = ls_location
END IF
IF this.trigger event ue_check_field(this,"zbuilding_1") > 0 THEN
	this.trigger event ue_load_buildings("zbuilding_1", ls_location)
	this.object.zbuilding_1[1] = ls_building
END IF
end event

event type string ue_validate_group(string ls_group);integer li, li_return, lx = 0
String setting, ls_field, ls_error = "", ls_vempty, ls_vopt, ls_valid, ls_ctype, ls_test, ls_gfields[]
Boolean lb_found = FALSE

ls_vempty = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","VEmpty","16777215")
ls_valid = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Valid","12632256")
//ls_vopt = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Vopt","16777215")

ls_ctype = ls_vempty
FOR li = 1 to Integer(string(this.Object.DataWindow.Column.Count))
	ls_field = this.Describe("#" + string(li) + ".Name")
	setting = this.Describe(ls_field + ".Tag")
	IF pos(setting,"G" + ls_group) > 0 THEN
		ls_test = string(this.object.data[1,li])
		lx += 1
		ls_gfields[lx] = ls_field
		IF ls_test = "1"  OR Upper(ls_test) = "X" OR UPPER(ls_test) = "Y" OR len(ls_test) > 1  THEN 
			lb_found = TRUE
		END IF
	END IF
NEXT

IF lb_found THEN ls_ctype = ls_valid

FOR li = 1 to lx
	ls_error = this.Modify(ls_gfields[li] + ".Background.Color='" + ls_ctype + "'")			
	IF ls_error <> "" THEN Messagebox("Validation " + ls_field , ls_error)
NEXT

RETURN ls_ctype
end event

event type string ue_validate_dependency(string ls_type, string ls_data, string ls_group);integer li, li_return
String setting, ls_field, ls_error = "", ls_vempty, ls_vopt, ls_valid, ls_return, ls_cdata
Boolean lb_check = TRUE

ls_vempty = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","VEmpty","16777215")
ls_valid = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Valid","12632256")
ls_vopt = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Vopt","16777215")

ls_return = ls_vopt
IF NOT ISNULL(ls_data) THEN ls_return = ls_valid
IF ls_type = "A" THEN
	IF ISNULL(ls_data) OR ls_data = "" THEN ls_return = ls_vempty
	IF ls_data = "0" OR Upper(ls_data) = "N" THEN lb_check = FALSE
ELSE
	IF ISNULL(ls_data) OR ls_data = "" THEN lb_check = FALSE
END IF


FOR li = 1 to Integer(string(this.Object.DataWindow.Column.Count))
	ls_field = this.Describe("#" + string(li) + ".Name")
	setting = this.Describe(ls_field + ".Tag")
	ls_cdata = string(this.object.data[1,li])
	IF pos(setting,"D" + ls_group) > 0 THEN
		IF lb_check THEN
			IF ISNULL(ls_cdata) OR ls_cdata = "" THEN 
			//this.Modify(ls_field + ".Color=255")
				ls_error = this.Modify(ls_field + ".Background.Color='" + ls_vempty + "'")			
				IF ls_error <> "" THEN Messagebox("Validation",ls_error)
			ELSE
			//this.Modify(ls_field + ".Color=0")
				ls_error = this.Modify(ls_field + ".Background.Color='" + ls_valid + "'")			
				IF ls_error <> "" THEN Messagebox("Validation",ls_error)
			END IF
		ELSE
			ls_error = this.Modify(ls_field + ".Background.Color='" + ls_vopt + "'")			
			IF ls_error <> "" THEN Messagebox("Validation",ls_error)
		END IF
	END IF
NEXT

RETURN ls_return
end event

event type boolean ue_validate_value(string ls_type, string ls_data);boolean lb_check = TRUE


CHOOSE CASE Left(ls_type,1)
CASE "A"
	IF ls_data = "0" OR Upper(ls_data) = "N" THEN lb_check = FALSE
CASE "B"
	IF ISNULL(ls_data) OR ls_data = "" THEN lb_check = FALSE
CASE "G"
	IF ISNULL(ls_data) THEN lb_check = FALSE
	CHOOSE CASE ls_data
	CASE "0","n","N"
		lb_check = FALSE
	END CHOOSE
END CHOOSE
RETURN lb_check


end event

event type boolean ue_validate_old(string ls_pagename);integer li, li_return, li_count, lpos, li_colnum[], colnum, lx, li_level[], li_lev
long li_prt, li_values[]
String setting, ls_field, ls_error = "", ls_vempty, ls_vopt, ls_valid, ls_ctype, ls_visible
String ls_fields[], ls_tag[], ls_message = "", ls_backcolor, ls_color, ls_ntype, ls_check[]
boolean lb_found
IF this.rowcount() = 0 THEN 
	Messagebox("Form is not complete","Blank Page is found for " + is_tabname)
	RETURN TRUE
END IF

this.accepttext()	
IF NOT lb_validate THEN RETURN TRUE

ls_vempty = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","VEmpty","16777215")
ls_valid = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Valid","12632256")
ls_vopt = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms","Vopt","16777215")

FOR li = 1 to Integer(string(this.Object.DataWindow.Column.Count))
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_visible = this.Describe("#" + string(li) + ".Visible")
	IF ls_visible = "1" THEN
		setting = this.Describe(ls_field + ".Tag")
		lpos = pos(setting,"|")
		IF lpos = 0 THEN
			li_count += 1
			ls_fields[li_count] = ls_field
			ls_tag[li_count] = setting
			li_colnum[li_count] = li
			li_level[li_count] = 0
			//li_values = this.trigger event ue_validate_dependent(this.object.data[1,li])
		ELSE
			li_count += 1
			ls_fields[li_count] = ls_field
			ls_tag[li_count] = Left(setting,3)
			li_colnum[li_count] = li
			li_level[li_count] = 0
			li_lev = 0
			DO WHILE lpos > 0
				li_count += 1
				ls_fields[li_count] = ls_field
				ls_tag[li_count] = mid(setting,lpos+1,3)
				li_colnum[li_count] = li
				lpos = pos(setting,"|",lpos + 1)
				li_lev += 1
				li_level[li_count] = li_lev
			LOOP
		END IF
	END IF
NEXT
	
IF ProfileString(gs_ini,"Utilities","FormError","NO") <> "NO" THEN
	FOR li = 1 to li_count
		IF Left(ls_tag[li],1) = "A" THEN
			FOR lx =  1 to li_count
				IF ls_tag[li] = ls_tag[lx] AND li <> lx THEN
					ls_message += ls_fields[lx] + "[" + ls_tag[lx] + ")  "
				END IF
			NEXT
		END IF
	NEXT
	IF ls_message <> "" THEN
		Messagebox("Validation Error Duplication",ls_message)
	END IF
END IF

FOR li = 1 to li_count
	ls_field = ls_fields[li]
	setting = ls_tag[li]
	colnum = li_colnum[li]
	ls_ctype = ls_vopt
	CHOOSE CASE Left(setting,1)
	CASE "X"
		IF ISNULL(this.object.data[1,colnum]) OR string(this.object.data[1,colnum]) = "" THEN 
			ls_ctype = ls_vempty
		ELSE
			ls_ctype = ls_valid
		END IF
		ls_error = this.Modify(ls_field + ".Background.Color='" + ls_ctype + "'")			
		IF ls_error <> "" THEN Messagebox("Validation " + ls_field , ls_error)
		IF ls_ctype = ls_valid THEN
			this.Modify(ls_field + ".Color=0")
		ELSE
			this.Modify(ls_field + ".Color=255")
		END IF			
	CASE "A","B"
		IF len(setting) >= 3 THEN
			ls_ctype =  this.trigger event ue_validate_dependency(Left(setting,1),string(this.object.data[1,colnum]),mid(setting,2,2)) 
			ls_error = this.Modify(ls_field + ".Background.Color='" + ls_ctype + "'")			
			IF ls_error <> "" THEN Messagebox("Validation " + ls_field , ls_error)
			ls_check[integer(mid(setting,2,2))] = ls_ctype
		END IF
	CASE "G"
		IF len(setting) >= 3 THEN
			IF li_level[li] = 0 THEN
				ls_ctype = this.trigger event ue_validate_group(mid(setting,2,2))
			ELSE
				IF ls_ntype = ls_vempty THEN
					ls_ctype = this.trigger event ue_validate_group(mid(setting,2,2))
				END IF
			END IF
		END IF
	CASE "D"
		ls_ntype = ls_check[integer(mid(setting,2,2))]
	CASE ELSE
		IF NOT ISNULL(this.object.data[1,colnum]) THEN 
			IF ProfileString(gs_ini,"Utilities","FormError","NO") = "NO" THEN
				ls_ctype = ls_valid
			END IF
		END IF
		ls_error = this.Modify(ls_field + ".Background.Color='" + ls_ctype + "'")			
		IF ls_error <> "" THEN Messagebox("Validation " + ls_field , ls_error)
	END CHOOSE
NEXT

IF ProfileString(gs_ini,"Utilities","FormValidation","NO") = "YES" THEN
	IF messagebox("Print Validation","Do you wish to print validation report",Question!, YesNo!,2) = 1 THEN
		li_prt = PrintOpen("Print Validate")
		FOR li = 1 to li_count
			Print(li_prt,string(li) + "~t" + ls_fields[li] + "~t " + ls_tag[li])
		NEXT
		PrintClose(li_prt)
	END IF
END IF

FOR li = 1 to li_count
	ls_field = ls_fields[li]
	ls_backcolor = this.Describe(ls_field +  ".Background.Color")
	ls_color = this.Modify(ls_field + ".Color")
	IF ls_color = "255" OR ls_backcolor = ls_vempty THEN lb_found = TRUE
NEXT	

IF lb_found THEN
	IF ls_pagename <> "SETUP" THEN
		Messagebox("Form is not complete","Required fields on " + ls_pagename + " not found." + &
			"  Missing items are in red text or yellow boxes.")
	END IF
END IF
RETURN lb_found
end event

event type integer ue_get_dependency(string setting);string ls_num
integer li
string ls_field, ls_visible
IF pos(setting,"D") > 0 THEN	ls_num = mid(setting,pos(setting,"D") + 1,2)
IF pos(setting,"E") > 0 THEN	ls_num = mid(setting,pos(setting,"E") + 1,2)


FOR li = 1 to Integer(string(this.Object.DataWindow.Column.Count))
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_visible = this.Describe("#" + string(li) + ".Visible")
	IF ls_visible = "1" THEN 
		setting = this.Describe(ls_field + ".Tag")
		IF pos(setting,"A" + ls_num) > 0 THEN	RETURN li
		IF pos(setting,"B" + ls_num) > 0 THEN	RETURN li + 1000
		IF pos(setting,"E" + ls_num) > 0 THEN	RETURN li
	END IF
NEXT
RETURN 0
end event

event ue_validation_report();long li_prt
integer li
string ls_message, ls_field, ls_visible, setting

	IF messagebox("Print Validation","Do you wish to print validation report",Question!, YesNo!,2) = 1 THEN
		li_prt = PrintOpen("Print Validate")
		Print(li_prt,"Validation Report")
		FOR li = 1 to Integer(string(this.Object.DataWindow.Column.Count))
			ls_message = ""
			ls_field = this.Describe("#" + string(li) + ".Name")
			IF this.trigger event ue_check_field(dw_defaultw, Left(ls_field,len(ls_field) - 1) + "xx") > 0 THEN
				ls_message = "WARNING---CBX FIELD VALIDATION ERROR"
			END IF
			ls_visible = this.Describe("#" + string(li) + ".Visible")
			setting = this.Describe("#" + string(li) + ".Tag")
			IF Right(ls_field,2) = "xx" THEN
				ls_message += 	this.Describe(ls_field + ".Values")
			END IF			
			//Left(ls_name,len(ls_name) - 1) + "xx"
			IF ls_visible = "1" THEN
				Print(li_prt,string(li) + "~t" + ls_field + "~t " + setting + "~t" + ls_message)
			END IF
		NEXT
		PrintClose(li_prt)
	END IF

end event

event ue_validate_keys();string ls_keys[200], ls_groups[100], ls_field, ls_visible, ls_value, setting
string ls_fgroup = "", ls_fvalid = "", ls_fvalida = "", spos
integer li, li_key, lkey

FOR li = 1 to Integer(string(this.Object.DataWindow.Column.Count))
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_visible = this.Describe("#" + string(li) + ".Visible")
	ls_value = string(this.object.data[1,li])
	IF ISNULL(ls_value) THEN ls_value = ""
	IF ls_visible = "1" THEN
	setting = this.Describe(ls_field + ".Tag")
	IF pos(setting,"A") > 0 THEN
		li_key = this.trigger event get_keyvalue(setting)
		IF li_key > 0 THEN ls_keys[li_key] = "A"
	END IF
	IF pos(setting,"B") > 0 THEN
		li_key = integer(mid(setting,pos(setting,"B")+1,2)) + 1
		IF li_key > 0 THEN ls_keys[li_key] = "B"
	END IF
	IF pos(setting,"G") > 0 THEN
		li_key = integer(mid(setting,pos(setting,"G")+1,2)) + 1
		IF li_key > 0 THEN ls_groups[li_key] = "G"
	END IF
	END IF
NEXT

FOR li = 1 to 100
	IF ls_groups[li] <> "G" THEN
	    ls_fgroup += string(li - 1) + "/"
	END IF
NEXT
FOR li = 1 to 100
	IF ls_keys[li] = "A"  OR ls_keys[li] = "B" THEN
	ELSE
	   ls_fvalid += string(li - 1) + "/"
	END IF
NEXT
FOR li = 101 to 199
	IF ls_keys[li] = "A"  OR ls_keys[li] = "B" THEN
	ELSE
	   lkey = Truncate((li - 100)/10,0)
	   spos = mid("PQRSTUVWXYZ",li - (100 + (lkey * 10)),1)
	   ls_fvalida += string(lkey) + spos + "/"
	END IF
NEXT

IF Messagebox("Available Keys","Group=" + ls_fgroup + "~r~n~r~nA/B=" + ls_fvalid +  &
	"~r~n~r~n(NOTE:  OVERFLOW ONLY)  A=" + ls_fvalida + "~r~n~r~nDo you wish to Print?",Question!,YesNo!,2) = 1 THEN
	
	Long  jobno

	jobno = PrintOpen("Validation Keys")

	Print(jobno, "Validation Keys for  " + ls_formname + "    " + String(Today()))
	Print(jobno, "")
	Print(jobno, "")
	Print(jobno,"Group=" + ls_fgroup + "~r~n~r~nA/B=" + ls_fvalid +  &
	"~r~n~r~n(NOTE:  OVERFLOW ONLY)  A=" + ls_fvalida)

	PrintClose(jobno)

END IF

end event

event type integer get_keyvalue(string ls_key);string ls_options = "PQRSTUVWXYZ"
string ls_type 
integer li_place, li_key, lpos

ls_type = Right(ls_key,2)
lpos = pos(ls_options, Right(ls_type,1))
IF lpos > 0 THEN
	li_place = integer(Left(ls_type,1))
	li_key = ((li_place * 10) + lpos) + 100
ELSE
	li_key = integer(mid(ls_key,pos(ls_key,"A")+1,2)) + 1
END IF
RETURN li_key

end event

event type string ue_wordini(string ls_test);string ls_answer, ls_location, ls_field, ls_dir, ls_phone, ls_file, ls_filename, ls_ctype, ls_item
string ls_nfield, ls_note, ls_visible
integer li, li_column, li_row, lx, li_protect_type
Boolean lb_found = FALSE, lb_checkbox = FALSE, lb_error = FALSE
OLEObject ole_word

dw_info.trigger event ue_dataobject("dw_bookmarks")

IF pos(ls_filename,"\") = 0 THEN
	ls_dir = set_inifiles(w_forms_main.i_active_sheet.is_formini,"Location of Templates","MAIN","Templates","c:\mgmt4\template",FALSE)
	IF Left(ls_dir,1) <> "\" THEN ls_dir += "\"
	ls_file = ls_dir + ls_formname + ".dot"
ELSE
	ls_file = ls_filename
END IF

IF NOT FileExists(ls_file) THEN
	//Messagebox("Template",ls_file + " not found")
	RETURN "N/F-" + ls_file
END IF

ls_wordini = ls_dir + ls_formname + ".ini"
IF NOT FileExists(ls_wordini) THEN
	Messagebox("INI File",ls_wordini + " not found")
END IF

IF ls_test = "Test" THEN
	ole_word = CREATE OLEObject
	IF ole_word.ConnectToNewObject("word.application") <> 0 THEN
		Messagebox("Error","Microsoft Word is not supported on your computer")
		RETURN ""
	END IF
	ole_word.Documents.Open(ls_file)

	li_protect_type = ole_word.ActiveDocument.ProtectionType
	IF li_protect_type > 0 THEN ole_word.ActiveDocument.Unprotect
END IF


FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_note = ""
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_ctype = this.Describe("#" + string(li) + ".ColType")
	//ls_item = string(this.object.data[1,li])
	ls_nfield = ProfileString(ls_wordini,is_tabname,ls_field,"")
	lb_checkbox = FALSE
	ls_visible = this.Describe("#" + string(li) + ".Visible")
	IF ls_nfield <> "" AND ls_visible = "1" THEN
		IF ls_nfield = "CHX" THEN
			FOR lx = 1 to 4
				ls_item = parse_cbx(this.Describe(ls_field + ".values"),lx)
				IF ls_item <> "" THEN
					ls_nfield = ProfileString(ls_wordini,is_tabname,ls_field + "-" + ls_item,"")
					dw_info.trigger event ue_addnew()
					dw_info.object.ls_wordini[dw_info.rowcount()] = ls_wordini
					dw_info.object.ls_fieldname[dw_info.rowcount()] =ls_field + " [" + ls_item + "]"
					dw_info.object.ls_bookmark[dw_info.rowcount()] = ls_nfield
					dw_info.object.ls_note[dw_info.rowcount()] = ls_note
					IF ls_test = "Test" AND ls_nfield <> "" Then
						IF ole_word.ActiveDocument.Bookmarks.Exists(ls_nfield) Then
							ole_word.Application.ActiveDocument.Bookmarks.Item(ls_nfield).Select()
							ole_word.Application.ActiveDocument.FormFields.Item(ls_nfield).CheckBox.Value = True
						ELSE
							Messagebox("Form Error","Bookmark not found for " + ls_nfield)
							this.Modify(ls_field + ".Background.Color='255'")			
						END IF
					END IF
				END IF
			NEXT
			ls_note = "N/F"
		END IF
	END IF
	IF ls_field = ls_nfield THEN ls_note = "[Internal Bookmark]"
	IF ls_note <> "N/F" THEN
		//ls_nfield = ProfileString(ls_wordini,is_tabname,ls_field + "-" + ls_item,"")
		dw_info.trigger event ue_addnew()
		dw_info.object.ls_wordini[dw_info.rowcount()] = ls_wordini
		dw_info.object.ls_fieldname[dw_info.rowcount()] =ls_field
		dw_info.object.ls_bookmark[dw_info.rowcount()] = ls_nfield
		dw_info.object.ls_note[dw_info.rowcount()] = ls_note
		IF ls_test = "Test" AND ls_nfield <> "" Then
			IF ole_word.ActiveDocument.Bookmarks.Exists(ls_nfield) Then
				ole_word.Application.ActiveDocument.Bookmarks.Item(ls_nfield).Select()
				ole_word.Selection.TypeText("TEST-" + ls_nfield + ">>")
			ELSE
				Messagebox("Form Error","Bookmark not found for " + ls_nfield)
				this.Modify(ls_field + ".Background.Color='255'")			
			END IF
		END IF
	END IF
NEXT

FOR li = 1 to dw_info.rowcount()
	ls_nfield = dw_info.object.ls_bookmark[li]
	IF ls_nfield <> "" THEN
		FOR lx = 1 to dw_info.rowcount()
			IF ls_nfield = dw_info.object.ls_bookmark[lx] AND li <> lx THEN
				dw_info.object.ls_note[li] = "ERROR--DUPLICATE BOOKMARK!!"
				lb_error = TRUE
			END IF
		NEXT
	END IF
NEXT

IF ls_test = "Test" THEN
	ole_word.Visible = TRUE
	ole_word.DisconnectObject()
	DESTROY ole_word
END IF

IF lb_error THEN Messagebox("Word INI","Error duplicate bookmark")
	
		
dw_info.visible = TRUE

	

end event

event type string ue_create_excel(string ls_new);string ls_answer, ls_location, ls_field, ls_dir, ls_phone, ls_file, ls_filename, ls_ctype, ls_item, ls_excelini
string ls_nfield, ls_visible
integer li, li_column, li_row, lx, li_protect_type
Boolean lb_found = FALSE, lb_checkbox = FALSE

u_oleobject uo_excel
uo_excel = CREATE u_oleobject

ls_excelini = get_dir("TEMPLATES","")  + ls_formname + ".ini"
ls_wordini = ls_excelini
IF NOT FileExists(ls_excelini) THEN
	Messagebox("INI File",ls_excelini + " not found")
	RETURN "N/F"
END IF

IF NOT uo_excel.of_excelopen(get_dir("TEMPLATES","") + ls_formname + ".xlt") THEN RETURN "N/F"

ls_new = Left(ls_new, len(ls_new) -3) + "xls"

FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_ctype = this.Describe("#" + string(li) + ".ColType")
	ls_visible = this.Describe("#" + string(li) + ".Visible")
	ls_item = string(this.object.data[1,li])
	If Isnull(ls_item) THEN ls_item = ""
	ls_nfield = ProfileString(ls_excelini,is_tabname,ls_field,"")
	lb_checkbox = FALSE
	IF ls_visible = "1" AND ls_nfield <> "" THEN
		uo_excel.of_excel_info(ls_nfield,ls_item,ls_ctype)
	END IF
NEXT

w_waiting.trigger event ue_waiting(long(ProfileString(gs_ini,"EXCEL","FormsTimer","300000")))

uo_excel.of_excelsave(ls_new)
DESTROY uo_excel

RETURN ls_new
	
end event

event buttonclicked;call super::buttonclicked;integer li_help
string ls_return
boolean lb_brecs = FALSE
IF dwo.name = "help_tab" THEN
	this.object.DataWindow.footer.height = "0"
	RETURN
END IF
CHOOSE CASE Left(dwo.name,5)
CASE "b_pho"
	//this.trigger event ue_copy_picture(row,this)
CASE "help_"
	w_forms_main.i_active_sheet.dw_help.trigger event ue_retrieve_help(ls_formname)
	integer li, li_col, li_tab = 0, li_row
	string ls_help, ls_desc
	boolean lb_continue = TRUE
	li_help = Integer(Right(dwo.name,len(string(dwo.name)) -pos(dwo.name,"_")))
	FOR li = 1 to w_forms_main.i_active_sheet.dw_help.rowcount()
		IF li_help = Integer(w_forms_main.i_active_sheet.dw_help.object.topicid[li]) THEN
			IF pos(w_forms_main.i_active_sheet.dw_help.object.topic[li],"<") = 1 THEN
				ls_return = this.trigger event ue_setup_helplist( &
					w_forms_main.i_active_sheet.dw_help.object.topic[li],w_forms_main.i_active_sheet.dw_help.object.topicid[li])
				IF ls_return = "" THEN ls_return = message.stringparm
				IF ls_return = "N/A" THEN lb_continue = FALSE
				IF lb_continue THEN
					//string(this.object.data[row,li])
					ls_help = w_forms_main.i_active_sheet.dw_help.object.topic[li]
					ls_help = Mid(ls_help,2,len(ls_help) - 2)
					li_row = row
					li_tab = 0
					IF pos(ls_help,".") > 0 THEN
						li_tab = integer(Right(ls_help,len(ls_help) - pos(ls_help,".")))
						ls_help = Left(ls_help,pos(ls_help,".") - 1)
					END IF
					IF li_tab = 0 THEN
						li_col = this.trigger event ue_check_field(this,ls_help)
						IF lb_multiple THEN
							this.trigger event ue_addnew()
							li_row = this.rowcount()
						ELSE
							ls_desc = string(this.object.data[row,li_col])
						END IF
					ELSE
						li_col = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
							ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,ls_help)
						IF w_forms_main.i_active_sheet.u_to_open[li_tab].lb_multiple THEN
							w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event ue_addnew()
							li_row = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.rowcount()
						ELSE
							ls_desc = string(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.object.data[row,li_col])
						END IF
					END IF
					IF ISNULL(ls_desc) THEN ls_desc = ""
					IF pos(ls_desc,ls_return) = 0 THEN
						IF ls_desc <> "" THEN ls_desc += "~r~n~r~n"
						ls_desc += ls_return
						IF li_tab = 0 THEN
							IF li_col > 0 THEN this.setitem(li_row,ls_help,ls_desc)
						ELSE
							w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.setitem(li_row,ls_help,ls_desc)
						END IF
					END IF
				END IF
			ELSE
				IF this.trigger event ue_check_field(this,"tabhelp") > 0 THEN
					this.object.tabhelp[row] = "[" + UPPER(w_forms_main.i_active_sheet.dw_help.object.topic[li]) + "]~r~n" + &
					w_forms_main.i_active_sheet.dw_help.object.description[li]
					this.object.DataWindow.footer.height = is_footer_height
				ELSE
					Messagebox(string(w_forms_main.i_active_sheet.dw_help.object.topic[li]), &
						string(w_forms_main.i_active_sheet.dw_help.object.description[li]))
				END IF
			END IF
		END IF
	NEXT
CASE "recs_"
	IF dwo.name = "recs_all" THEN
		openwithparm(w_recs,"ALL")
		w_recs.li_tab = ii_tab
		w_recs.ls_help = "recommendations"
	ELSE
		lb_brecs = TRUE
	END IF
CASE ELSE
	IF Left(dwo.name,4) = "recs" THEN 
		lb_brecs = TRUE
	ELSE
		Messagebox("Button",string(dwo.name) + " not recognized")
	END IF
END CHOOSE

IF lb_brecs THEN
	li_help = Integer(Right(dwo.name,len(string(dwo.name)) -pos(dwo.name,"_")))
	ls_return = this.trigger event ue_setup_recs(dwo.name,li_help)
END IF
end event

event clicked;call super::clicked;Integer li_yes, li_no, li
String ls_name

IF this.rowcount() = 0 THEN this.trigger event ue_addnew()

ls_name = dwo.name

IF Right(ls_name,3) = "_no" THEN
	li_no = this.trigger event ue_check_field(this,ls_name)
	li_yes = this.trigger event ue_check_field(this,Left(ls_name,len(ls_name) - 3))
ELSE
	li_no = this.trigger event ue_check_field(this,ls_name + "_no")
	li_yes = this.trigger event ue_check_field(this,ls_name)
END IF

//Messagebox(ls_name,string(li_no) + "-" + string(li_yes))
IF li_no > 0 and li_yes > 0 THEN
	IF Right(ls_name,3) = "_no" THEN
		this.object.data[row,li_yes] = 0
	ELSE
		this.object.data[row,li_no] = 0
	END IF
END IF

IF Mid(ls_name,len(ls_name) - 2,2) = "_m" THEN
	FOR li =  1 to 9
		IF integer(left(ls_name,1)) <> li THEN
			li_yes = this.trigger event &
				ue_check_field(this,Left(ls_name,len(ls_name) - 1) + string(li))
			IF li_yes > 0 THEN
				this.object.data[row,li_yes] = 0
			END IF
		END IF
	NEXT
END IF
		
end event

event doubleclicked;call super::doubleclicked;CHOOSE CASE Left(dwo.name,6)
CASE "photo_"
//	IF lb_rsketch THEN
	//	openwithparm(w_rapidsketch,this.trigger event ue_get_photoname(dwo.name,row,""))
//	ELSE
		string ls_new
		integer li_col
		li_col = this.trigger event ue_check_field(this,dwo.name)
		ls_new = string(this.object.data[row,li_col])
		IF FileExists(ls_new) THEN
			run_file(ls_new)
		ELSE
			open(w_photos)
		END IF
	//END IF
//	string ls_photo, ls_new, ls_field
//	long ll_size
//	integer li_width, li_height, li_awidth, li_aheight
//	ll_size = long(ProfileString(w_forms_main.i_active_sheet.is_formini,"MAIN","PhotoSize","100")) * 1000
//	ls_field = dwo.name
//	ls_new = Left(w_forms_main.i_active_sheet.ls_filename, len(w_forms_main.i_active_sheet.ls_filename) - 4)
//	ls_new += "p" + Right(ls_field,len(ls_field) - 6)
//	IF row > 1 THEN ls_new += string(row)
//	open(w_load_picture)
//	w_load_picture.ls_cname = ls_new
//	w_load_picture.ls_field = ls_field
//	w_load_picture.li_row = row
//	w_load_picture.ldw = this
//
//	//ls_photo = this.trigger event ue_copypicture("",ls_new)
//	ll_size = long(ProfileString(w_forms_main.i_active_sheet.is_formini,"MAIN","PhotoSize","100")) * 1000
//	//IF filesize(ls_photo) > ll_size THEN
//			//Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
//	//ELSE
////	IF FileExists(ls_photo) THEN
////		IF ls_photo <> "" THEN
////			w_forms_main.i_active_sheet.lb_photo = TRUE
////			this.setitem(row,dwo.name,ls_photo)
////			this.accepttext()
////			lb_changed = TRUE
////		END IF
////		this.setcolumn(0)
////	END IF
CASE "docum_"
	openwithparm(w_forms_document,string(this.object.data[row,this.getcolumn()]))
	this.setitem(row,dwo.name,message.stringparm)
END CHOOSE
end event

event getfocus;call super::getfocus;//ShowPopupHelp ( "Help/my_app.hlp", this, 510)
end event

event itemchanged;call super::itemchanged;string ls_tag, ls_desc, ls_loc, ls_ctype
integer lx
ls_tag = this.describe(dwo.name + ".Tag")
ls_ctype = this.Describe(dwo.name + ".ColType")
lb_changed = TRUE
IF pos(ls_tag,"sp") > 0 OR pos(ls_ctype,"32766") > 0 THEN RETURN this.trigger event ue_spell(dwo.name,row,data)

IF pos(dwo.name,"zlocation") > 0 THEN 	this.trigger event ue_load_buildings(dwo.name, data)
	


end event

event ue_addnew;call super::ue_addnew;//this.trigger event ue_reretrieve()
Integer li
String ls_name, ls_desc

w_forms_main.i_active_sheet.trigger event ue_dup_fields(ii_tab)

FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_name = this.Describe("#" + string(li) + ".Name")
	CHOOSE CASE ls_name
	CASE "zrecno"
		ls_desc = String(Year(Today())) + "." + string(Month(Today()))
		this.setitem(this.rowcount(),li,ls_desc)
	END CHOOSE
NEXT




end event

event ue_retrieve;call super::ue_retrieve;//integer lpos, rpos
//string ls_name
//boolean lb_pdf
//
//ls_name = message.stringparm
//lb_ready = FALSE
//
//
//lpos = pos(ls_name,"_")
//rpos = pos(ls_name,"-",lpos)
//IF rpos > 0 THEN
//	rpos = rpos - lpos - 1
//ELSE
//	rpos = len(ls_name) - lpos - 4
//END IF
//ls_form = Mid(ls_name,lpos + 1, rpos)
//ls_filename = ls_name
//
////dwsyntax = this.Describe("DataWindow.Syntax")
//ls_library = set_inifiles(w_forms_main.i_active_sheet.is_formini,"Location of Templates","MAIN","Templates","",FALSE)
//IF Left(ls_library,1) <> "\" THEN ls_library += "\"
////ls_library += "dw" + ls_form + ".srd"
//
//ls_flibrary = ProfileString(w_forms_main.i_active_sheet.is_formini,ls_form,"Form","")
//IF ls_flibrary = "" THEN
//	ls_flibrary = set_inifiles(w_forms_main.i_active_sheet.is_formini,"Location of Form Library","MAIN","Form","",FALSE)
//END IF
//ls_library += ls_flibrary
//
//IF FileExists(ls_library) THEN
//	li_total = this.trigger event get_page_count("dw")	
//	this.trigger event ue_load_form(ls_form)
//	this.ResetUpdate()
//ELSE
//	Messagebox("Forms", "File " + ls_library + " does not exist.")
//END IF
//
//lb_ready = TRUE
////rtncode = LibraryImport(ls_library, "dw" + ls_form + ".srd", ImportDataWindow!, &
////	dwsyntax, ErrorBuffer )
//
//
//
end event

event ue_print_report;dw_report.trigger event ue_print_all(-1)
//this.trigger event ue_zoom(100)
//IF li_total = 1 THEN
//	IF this.rowcount() > 0 THEN
//		IF printsetup() = 1 THEN dw_print.print()
//	ELSE
//		Messagebox("Print","No records to print")
//	END IF
//ELSE
//	integer li_count, li_start
//	li_count = this.trigger event get_page_count("pw")
//	openwithparm(w_ask,"Print Page (" + string(li_count) + ")?/ALL")
//	IF message.stringparm = "" THEN RETURN
//	CHOOSE CASE message.stringparm
//	CASE "ALL"
//		li_start = 1
//	CASE ELSE
//		IF integer(message.stringparm) > 0 THEN
//			IF integer(message.stringparm) <= li_count THEN
//				li_start = integer(message.stringparm)
//				li_count = li_start
//			ELSE
//				RETURN
//			END IF
//		ELSE
//			RETURN
//		END IF
//	END CHOOSE
//	printsetup()
//	long ll_job
//	ll_job = PrintOpen("Form " + ls_filename)
//	FOR li_page = li_start to li_count
//		st_status.text = "Printing " + string(li_page) + " of " + string(li_count)
//		IF li_page = 1 THEN
//			dw_print.trigger event ue_load_form(ls_form)
//		ELSE
//			dw_print.trigger event ue_load_form(ls_form + string(li_page))
//		END IF			
//		PrintDataWIndow(ll_job,dw_print)
//	NEXT
//	PrintClose(ll_job)
//	st_status.text = "Printing Complete"
////END IF
end event

event ue_rightbutton;call super::ue_rightbutton;//lm_list.m_listview.m_retrieverecords.enabled = TRUE
IF lb_multiple THEN
	lm_list.m_listview.m_add.enabled = TRUE
	lm_list.m_listview.m_delete.enabled = TRUE
END IF
IF this.rowcount() > 1 THEN
	lm_list.m_listview.m_delete.enabled = TRUE
END IF	
lm_list.m_listview.m_zoom.visible = TRUE
IF li_rsketch > 0 THEN 
	lm_list.m_listview.m_advanced3.visible = TRUE
	CHOOSE CASE li_rsketch
	CASE 2
		lm_list.m_listview.m_advanced3.text = "Import Rapid Sketch"
	CASE 99
		lm_list.m_listview.m_advanced3.text = "Apex"
	CASE ELSE
		lm_list.m_listview.m_advanced3.text = "Rapid Sketch"
	END CHOOSE
END IF
IF lb_recs THEN 
	lm_list.m_listview.m_advanced3.visible = TRUE
	lm_list.m_listview.m_advanced3.text = "Add Recommendations"
END IF

IF this.trigger event ue_check_field(this,"tabrows") > 0 THEN
	lm_list.m_listview.m_add.enabled = TRUE
	lm_list.m_listview.m_delete.enabled = TRUE
END IF

end event

event ue_reretrieve;Integer li
String ls_item, ls_field
Date ld_date
ld_date = Today()

FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_item = ProfileString(w_forms_main.i_active_sheet.is_formini,"Forms",ls_field,"") 
	IF ls_item <> "" THEN this.setitem(1,li,ls_item)
	IF UPPER(left(ls_field,4)) = "DATE" THEN this.setitem(1,li,ld_date)
NEXT

end event

event ue_commit;this.trigger event ue_update()
end event

event ue_delete;call super::ue_delete;//Integer li, lpos, lx
//String ls_desc, ls_name, ls_oname
//FOR li = 1 to integer(this.object.DataWindow.Column.Count)
//	ls_name = this.Describe("#" + string(li) + ".Name")
//	CHOOSE CASE ls_name
//	CASE "zrecno"
//		FOR lx = 1 to this.rowcount()
//			DO UNTIL pos(this.object.zrecno[lx],".") = 0
//				lpos = pos(this.object.zrecno[lx],".")
//			LOOP
//			ls_desc = Left(this.object.zrecno[lx],lpos) +  String(this.rowcount())
//			this.setitem(this.rowcount(),lx,ls_desc)
//		NEXT
//	END CHOOSE
//NEXT
lb_changed = TRUE


end event

event dragdrop;call super::dragdrop;CHOOSE CASE Left(dwo.name,6)
CASE "photo_"
	string ls_photo, ls_new, ls_field, ls_error
	integer li_owidth, li_oheight, li_find
	ls_field = dwo.name
	li_find = search_photo(ls_field)
	IF li_find > 0 THEN
		li_owidth = li_pwidth[li_find]
		li_oheight = li_pheight[li_find]
	END IF
	
	lb_changed = TRUE
	ls_photo = w_photos.get_height(this,row,dwo.name,li_owidth, li_oheight)
	IF FileExists(ls_photo) THEN
		ls_new = this.trigger event ue_get_photoname(ls_field,row,Right(ls_photo,3))
		FileCopy(ls_photo, ls_new,TRUE)
		this.Modify(ls_field + ".BitMapName = No")
		IF FileExists(ls_new) THEN 
			this.SetBorderStyle(ls_field, ShadowBox!)
			this.setitem(row,ls_field,ls_new)
			this.Modify(ls_field + ".BitMapName = Yes")
		END IF
	END IF
END CHOOSE
end event

event ue_advanced;call super::ue_advanced;string ls_name, ls_data, ls_aname, ls_style
integer li_total, li_find, li, li_loop = 0
boolean lb_stop = FALSE
Integer  lx, lpos, rpos

CHOOSE CASE li_no
CASE 2
	string ls_field, ls_pict
	integer li_field
	ls_field = ls_field_name
	IF pos(ls_field,"photo_") > 0 THEN
		li_field = this.trigger event ue_check_field(this,ls_field)
		ls_pict = this.object.data[li_rownum,li_field]
		li_find = search_photo(ls_field)
		open(w_picture_set)
		w_picture_set.is_cname = this.trigger event ue_get_photoname(ls_field,li_rownum,"")
		w_picture_set.set_defaults(this,li_rownum,ls_field,ls_pict,li_pwidth[li_find], li_pheight[li_find],ii_tab)
	END IF
	IF ls_wordini <> "" THEN
		IF NOT Fileexists(ls_wordini) THEN create_file(ls_wordini)
		ls_style = this.Describe(ls_field + ".Edit.Style")
		CHOOSE CASE ls_style
		CASE "radiobuttons","checkbox"
			li_find = this.trigger event ue_check_field(this,ls_field)
			IF li_find > 0 THEN
				ls_data = string(this.object.data[1,li_find])
				IF ls_data = "" THEN
					Messagebox("Word Options","No value selected")
				ELSE
					ls_pict = ProfileString(ls_wordini,is_tabname,ls_field + "-" + ls_data,"")
					SetProfileString(ls_wordini,is_tabname,ls_field,"CHX")
					openwithparm(w_ask,"Location of field " + ls_field + "-" + ls_data + "/" + ls_pict)
					SetProfileString(ls_wordini,is_tabname,ls_field + "-" + ls_data,message.stringparm)
				END IF
			END IF
		CASE ELSE	
			ls_pict = ProfileString(ls_wordini,is_tabname,ls_field,"")
			openwithparm(w_ask,"Location of field " + ls_field + "/" + ls_pict)
			SetProfileString(ls_wordini,is_tabname,ls_field,message.stringparm)
		END CHOOSE
	END IF
CASE 3
	IF li_rsketch = 99 THEN
		ls_name = this.object.photo_diagram[1]
		lpos = pos(ls_name,"_PAGE1.jpg")
		ls_name = Left(ls_name,lpos - 1) + ".ax4"
		run_file(ls_name)
	ELSE
	IF lb_recs THEN
		openwithparm(w_recs,"ALL")
		w_recs.li_tab = ii_tab
		w_recs.ls_help = "recommendations"
	ELSE
	IF li_rsketch = 1 THEN
		ls_name = this.trigger event ue_get_photoname("photo_diagram",1,"")
		uo_test = CREATE uo_rapidsketch
		ls_data = this.object.tabsketch[1]
		IF pos(ls_data,"</DATA>") > 0 THEN 	
			uo_test.is_data = this.object.tabsketch[1]
		ELSE
			IF len(ls_data) > 10 THEN Messagebox("Rapid Sketch","Rapid Sketch data is corrupt")
		END IF
		IF uo_test.trigger event ue_start(ls_name) THEN 
			cb_rapidsketch.visible = TRUE
			cb_crapidsketch.visible = TRUE
			li_rsketch = 2
			lb_changed = TRUE
		END IF
	ELSE
		DO UNTIL lb_stop
			li_loop += 1
			Yield()
			li_total = uo_test.trigger event ue_complete()
			IF li_total > 0 THEN lb_stop = TRUE
			IF li_loop = 15 THEN lb_stop = TRUE
		LOOP
		IF li_total > 0 THEN	
			this.setitem(1,"photo_diagram",uo_test.ls_filename + "1.jpg")
			open(w_picture_set)
			li_find = search_photo("photo_diagram")
			w_picture_set.set_picture(this,1,"photo_diagram",uo_test.ls_filename + "1.jpg",li_pwidth[li_find], li_pheight[li_find])
			close(w_picture_set)
			this.setitem(1,"tabsketch",uo_test.is_fdata)
			IF li_total > 1 THEN
				Messagebox("Rapid Sketch","This returned multiple pages-only the first page will be saved")
			END IF
			DESTROY uo_test
			li_rsketch = 1
			cb_rapidsketch.visible = FALSE
			cb_crapidsketch.visible = FALSE
		ELSE
			Messagebox("Rapid SKetch","No items were found to import")
		END IF
	END IF
	END IF
END IF
CASE 4
	//reload records
String ls_desc, ls_building, ls_location
Boolean lb_location = FALSE
open(w_waiting)
w_forms_main.i_active_sheet.trigger event ue_import_zip("default.mpf", ii_tab)
close(w_waiting)
lpos = pos(is_tabname,"[")
IF lpos > 0 THEN
	rpos = pos(is_tabname,":")
	IF rpos = 0 THEN rpos = len(is_tabname)
	ls_location = Mid(is_tabname,lpos + 1,rpos - lpos - 1)
	IF rpos <> len(is_tabname) THEN
		ls_building = Mid(is_tabname,rpos + 1, len(is_tabname) - rpos - 1)
	END IF
END IF
FOR li = 1 to integer(this.object.DataWindow.Column.Count)
	ls_name = this.Describe("#" + string(li) + ".Name")
	ls_aname = ls_name
	IF pos(ls_name,"_") > 0 THEN
		ls_aname = Left(ls_name,pos(ls_name,"_") - 1)
	END IF
	CHOOSE CASE ls_aname
	CASE "zrecno"
		ls_desc = String(Year(Today())) + "." + String(Month(Today()))  
	CASE "tabmultiple"
		IF this.object.tabmultiple[1] = "TRUE" THEN lb_multiple = TRUE
	CASE "zlocation"
		ls_desc = ""
		FOR lx = 1 to Upperbound(w_forms_main.i_active_sheet.ls_location)
			IF w_forms_main.i_active_sheet.ls_location[lx]  <> "<DELETED>" THEN
				ls_desc += w_forms_main.i_active_sheet.ls_location[lx] + "~t" + w_forms_main.i_active_sheet.ls_location[lx] + "/"  
			END IF
		NEXT
		this.modify(ls_name + ".values = ~"" + ls_desc + "~"")
		IF ls_location <> "" THEN 
			this.setitem(this.rowcount(),li,ls_location)
			this.trigger event ue_load_buildings(ls_name, ls_location)
		END IF
	CASE "zbuilding"
		IF ls_building <> "" THEN this.setitem(this.rowcount(),li,ls_building)
	END CHOOSE
NEXT

END CHOOSE
end event

event rbuttondown;lm_list = create menu_form_list
lm_list.dw_parent = this
ls_field_name = dwo.name
li_rownum = row
this.trigger event ue_rightbutton()
lm_list.m_listview.PopMenu(PointerX(), PointerY())
destroy lm_list

end event

