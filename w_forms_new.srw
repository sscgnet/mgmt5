HA$PBExportHeader$w_forms_new.srw
forward
global type w_forms_new from window
end type
type dw_formlist from uo_datawindow within w_forms_new
end type
type dw_rec_list from uo_datawindow within w_forms_new
end type
type dw_help from uo_datawindow within w_forms_new
end type
type tab_main from tab within w_forms_new
end type
type tab_main from tab within w_forms_new
end type
end forward

global type w_forms_new from window
integer width = 3598
integer height = 3732
boolean titlebar = true
string title = "Loading..please wait..."
string menuname = "menu_form_new"
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 12639424
string icon = "Form!"
boolean toolbarvisible = false
event type integer ue_open_tab ( integer li_tab )
event ue_retrieve ( )
event type boolean ue_save ( )
event ue_print ( )
event ue_display_pictures ( boolean lb_display )
event ue_import_file ( )
event ue_zip ( boolean lb_dozip )
event ue_delete_photos ( )
event type integer ue_print_pdf ( n_cst_printer adobe_reader,  string ls_pdfname,  boolean lb_close )
event type integer ue_load_form ( string ls_fname,  string ls_tabname,  string ls_formlib )
event ue_dup_fields ( integer li_new )
event type integer ue_load_pictures ( )
event type string ue_save_memo ( string ls_field,  string ls_item,  integer li_tab )
event type string ue_import_memo ( string ls_field,  integer li_tab,  string ls_ctype,  string ls_sitem )
event type string ue_import_srd ( string ls_tempdir,  string ls_name,  string ls_templib )
event type string ue_unzip_mfz ( string ls_formname )
event type integer ue_get_tab ( string ls_fname )
event ue_retrieve_zip ( )
event type integer ue_import_zip ( string ls_mpftype,  integer li_tab )
event type boolean ue_save_form ( string ls_fname,  integer li_tab,  integer li_copy )
event type integer ue_load_zip ( string ls_fname,  string ls_tabname,  integer li_tab )
event type integer ue_load_dups ( string ls_fname,  integer li_formid,  integer li_order )
event type integer ue_spellcheck ( )
event type integer ue_print_jpeg ( n_cst_printer adobe_reader,  string ls_pdfname,  boolean lb_close )
event type string ue_get_syntax ( string ls_formlib,  string ls_fname,  boolean lb_print,  boolean lb_ask )
event ue_parse_form ( )
event type integer ue_load_pictures_tab ( integer li_tab )
event type integer ue_print_all ( boolean lb_close,  boolean lb_preview )
event ue_word_form ( )
event ue_parse_form_old ( )
event ue_word_parse ( )
event type string ue_zipup ( string ls_path,  string ls_newzip )
event ue_zipadd ( string ls_zipname )
event ue_delete_print ( string ls_file )
event type boolean ue_web_connect ( )
dw_formlist dw_formlist
dw_rec_list dw_rec_list
dw_help dw_help
tab_main tab_main
end type
global w_forms_new w_forms_new

type prototypes

end prototypes

type variables
uo_forms_sheet u_to_open[]
boolean lb_ready, lb_zip = FALSE, lb_photo = FALSE, lb_errors = FALSE, ib_changed = FALSE, ib_deleted = FALSE, lb_pdfreset = FALSE
string ls_filename, ls_form, ls_cdir,  ls_zipfile, ls_flibrary, ls_photos[], ls_building[], ls_location[], ls_library, is_helpname, is_pforms[], is_pfname[], ls_zipfiles[]
string is_formini, ls_pdftype = "None", ii_templates
integer li_timer = 0, ii_id = 1,ii_tphoto = 0, ii_copy = 0
boolean lb_check_validation = TRUE, lb_web_connect = FALSE
long il_control, il_id
transaction websource

end variables

forward prototypes
public subroutine ue_retrieve_help (string ls_helpname)
end prototypes

event type integer ue_open_tab(integer li_tab);Integer li, li_start
IF li_tab = 0 THEN li_tab = upperbound(u_to_open) + 1
IF li_tab > Upperbound(u_to_open) THEN
	li_start = Upperbound(u_to_open) + 1
	FOR li = li_start TO li_tab
		tab_main.OpenTabWithParm(u_to_open[li],"",0)
		u_to_open[li].Text = "Page " + string(li)
		u_to_open[li].ii_tab = li
		//IF li > 1 THEN u_to_open[li].lb_multiple = TRUE
	NEXT
END IF
RETURN li_tab

end event

event ue_retrieve();integer lpos, rpos, rtncode, li
string errorbuffer,dwsyntax, ls_formname
boolean lb_pdf

lb_ready = FALSE
Timer(0)

ls_form = get_filename(ls_filename)
lpos = pos(ls_form,"_")
rpos = pos(ls_form,"-",lpos)
IF rpos > 0 THEN
	rpos = rpos - lpos - 1
ELSE
	rpos = len(ls_form) - lpos - 4
END IF
ls_form = Mid(ls_form,lpos + 1, rpos)

//dwsyntax = this.Describe("DataWindow.Syntax")
ls_library = set_ini("Location of Templates","MAIN","Templates","",FALSE)
IF Left(ls_library,1) <> "\" THEN ls_library += "\"
//ls_library += "dw" + ls_form + ".srd"

this.trigger event ue_unzip_mfz(ls_form)
//IF Upper(ProfileString(is_formini,ls_form,"Update","Yes")) = "YES" THEN lb_update_mfz = TRUE
ls_flibrary = ProfileString(is_formini,ls_form,"Form","")
IF ls_flibrary = "" THEN
	ls_flibrary = set_ini("Location of Form Library","MAIN","Form","",FALSE)
END IF
ls_library += ls_flibrary

IF FileExists(ls_library) THEN
	Boolean lb_done = FALSE
	Integer li_count = 0
	DO UNTIL lb_done
		li_count += 1
		
		IF li_count = 1 THEN
			ls_formname = ls_form
		ELSE
			ls_formname = ls_form + string(li_count)
		END IF			
		dwsyntax = LibraryExport(ls_library, "dw_" + ls_formname, ExportDataWindow!)
		IF ISNULL(dwsyntax) OR dwsyntax = "" THEN 
			lb_done = TRUE
		ELSE
			li_count = this.trigger event ue_open_tab(li_count)
			
			u_to_open[li_count].ls_formname = ls_formname
			u_to_open[li_count].ls_formlibrary = ls_library
			u_to_open[li_count].is_cversion = ProfileString(is_formini,ls_formname,"CVersion","")

			u_to_open[li_count].dw_defaultw.height = &
				(this.height - u_to_open[li_count].dw_defaultw.y) - 500
			u_to_open[li_count].dw_defaultw.width = &
				(this.width - u_to_open[li_count].dw_defaultw.x) - 150

			rtncode = u_to_open[li_count].dw_defaultw.create(dwsyntax,ErrorBuffer)
			IF li_count = 1 THEN	u_to_open[li_count].dw_defaultw.insertrow(0)
		END IF		
	LOOP
	//li_total = this.trigger event get_page_count("dw")	
	//this.trigger event ue_load_form(ls_form)
	//this.ResetUpdate()
	IF Upperbound(u_to_open) > 0 THEN this.trigger event ue_import_file()
ELSE
	Messagebox("Forms", "File " + ls_library + " does not exist.")
END IF


this.title = ls_form + "!" + ls_zipfile
dw_help.trigger event ue_reretrieve()
lb_ready = TRUE

end event

event type boolean ue_save();string ls_tform[], ls_tversion[], ls_tabname[], ls_locname[], ls_buildname[], ls_sform
integer li,lr, lz, li_count, li_file
boolean lb_ok = TRUE

IF lb_web_connect THEN 
	FOR lr = 1 to upperbound(u_to_open)
		IF u_to_open[lr].lb_changed THEN
			this.trigger event ue_save_form(ls_sform,lr,0)
			u_to_open[lr].lb_changed = FALSE
		END IF
	NEXT	
	RETURN TRUE
END IF
ls_filename = get_pathname(ls_filename) + "main.mpf"

FOR li = 1 TO Upperbound(u_to_open)
	IF u_to_open[li].lb_ok THEN
		//IF u_to_open[li].dw_defaultw.trigger event ue_validate("Page " + string(li)) THEN
		//	lb_ok = FALSE
		//END IF
		IF u_to_open[li].li_rsketch > 1 THEN
			Messagebox("Rapid Sketch","Rapid Sketch is either open or pending an import")
			lb_ok =FALSE
		END IF
	END IF
NEXT

openwithparm(w_waiting,"Saving file-" + string(Upperbound(u_to_open)))

FOR lr = 1 to upperbound(u_to_open)
	IF u_to_open[lr].lb_changed THEN
		ls_sform =  string(u_to_open[lr].ii_formrow,"000") + u_to_open[lr].ls_formname
		ii_copy += 1 
		IF ii_copy = 4 THEN ii_copy = 1
		this.trigger event ue_save_form(ls_sform,lr,ii_copy)
		this.trigger event ue_save_form(ls_sform,lr,0)
		u_to_open[lr].lb_changed = FALSE
	END IF
//	w_waiting.trigger event ue_step()
NEXT

dw_formlist.trigger event ue_update()

li_file = FileOpen(ls_filename,LineMode!,Write!,LockReadWrite!,Replace!)
//FOR li = 1 to li_count
//	FileWrite(li_file, ls_tform[li])
//	FileWrite(li_file, "00" + string(li,"00") + "TABNM" + ls_tabname[li] )
//	FileWrite(li_file, "00" + string(li,"00") + "VERSN" + ls_tversion[li] )
//	FileWrite(li_file, "00" + string(li,"00") + "LOCAT" + ls_locname[li] )
//	FileWrite(li_file, "00" + string(li,"00") + "BUILD" + ls_buildname[li] )
//NEXT
FileWrite(li_file, "0000PHOTO" + string(ii_tphoto))
FileWrite(li_file, "9999PDFTP" + ls_pdftype)
IF lb_pdfreset = TRUE THEN FileWrite(li_file, "9999PDRSTTRUE")
FileClose(li_file)

string ls_record
IF Upperbound(ls_location) > 0 THEN
	li_file = FileOpen(ls_cdir + "\location.mpf",LineMode!,Write!,LockReadWrite!,Replace!)
	FOR li = 1 to Upperbound(ls_location)
		IF ls_location[li] <> "<DELETED>" THEN
			FileWrite(li_file, "char<locnum." + string(li) + ">" + ls_location[li] + "~~")
			FileWrite(li_file, "char<locdes." + string(li) + ">" + ls_building[li] + "~~")
		END IF
	NEXT
	FileClose(li_file)
END IF


Close(w_waiting)

IF ProfileString(gs_ini,"Utilities","FormInfo","") = "YES" THEN
	FOR li = 1 to Upperbound(u_to_open)
		u_to_open[li].dw_defaultw.trigger event ue_form_error()
	NEXT
END IF

this.SetMicroHelp("Complete " + ls_filename)
ib_changed = FALSE
lb_zip = TRUE
RETURN lb_ok



end event

event ue_print();Integer li, li_count

open(w_forms_print)
//long ll_job
//ll_job = PrintOpen("Form " + ls_filename)
//FOR li = 1 to Upperbound(u_to_open)
//	//u_to_open[li].dw_report.trigger event ue_print_job(ll_job)
//	//w_forms_print.lb_list.SetSTate(li,TRUE)
//	w_forms_print.lb_list.additem(u_to_open[li].text)

//NEXT
//PrintClose(ll_job)

FOR li = 1 to dw_formlist.rowcount()
	IF dw_formlist.object.lorder[li] <> 0 THEN 
		li_count += 1
		w_forms_print.lb_list.additem(dw_formlist.object.tabname[li])
	END IF
NEXT


end event

event ue_display_pictures(boolean lb_display);Integer li
FOR li = 1 to Upperbound(u_to_open)
	u_to_open[li].dw_defaultw.trigger event ue_display_pictures(lb_display)
NEXT
	
end event

event ue_import_file();integer li_file, li_length, lpos,rpos, li, rowpos, li_tab = 1
string ls_record, ls_item = "", ls_field, ls_ctype, ls_mpftype, ls_formlib
boolean lb_continue = TRUE, lb_validate

integer li_test

ls_mpftype = ls_filename
//ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + "mpf"
//IF li_total > 1 THEN
//	IF FileExists(Left(ls_filename,len(ls_filename) - 3) + string(li_page)) THEN
//		ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + string(li_page)
//	END IF
//END IF

openwithparm(w_waiting,"Loading...-200")
this.SetMicroHelp("Opening " + ls_mpftype)
ls_cdir = get_pathname(ls_mpftype)
//li_file = FileOpen(ls_mpftype,TextMode!,Read!,Shared! )
li_file = FileOpen(ls_mpftype)
li_length = FileRead(li_file,ls_record)
DO WHILE li_length >= 0
	IF lb_continue THEN
		IF ls_record = "!" THEN 
			lb_validate = TRUE
			li_length = FileRead(li_file,ls_record)
		ELSE
			IF Trim(ls_record) = "" THEN
				li_length = FileRead(li_file,ls_record)
			END IF
		END IF
		rpos = pos(ls_record,"<")
		lpos = pos(ls_record,">")
		IF lpos > 0 THEN
			ls_field = Mid(ls_record,rpos + 1, lpos - rpos - 1)
			ls_item = ""
		END IF
		IF rpos > 0 THEN
			ls_ctype = Left(ls_record, rpos - 1)
		END IF
	END IF
	IF li_length = 0 THEN
		ls_item += "~r~n"
	ELSE
		IF pos(ls_ctype,"char(32766)") > 0 THEN
			IF ls_field = "tabsketch" THEN
				ls_item += ls_record
			ELSE
				FOR li = lpos + 1 to len(ls_record)
					CHOOSE CASE mid(ls_record,li,1)
					CASE "|"
						ls_item += "~r~n"
					CASE ELSE
						ls_item += mid(ls_record,li,1)
					END CHOOSE
				NEXT
				lpos = 0
			END IF
		ELSE
			ls_item += Mid(ls_record, lpos + 1, len(ls_record) - lpos) 
		END IF			
	END IF
	IF Right(ls_item,1) = "~~" THEN
		ls_item = Left(ls_item,len(ls_item) - 1)
		rowpos = pos(ls_ctype,"@")
		IF rowpos > 0 THEN
			li_tab = this.trigger event ue_get_tab(Left(ls_ctype,rowpos - 1))
			IF li_tab = 0 THEN
				ls_formlib = this.trigger event ue_unzip_mfz(Left(ls_ctype,rowpos - 1))
				li_tab = this.trigger event ue_load_form(Left(ls_ctype,rowpos - 1),"",ls_formlib)
			END IF
			IF li_tab > 0 AND li_tab <= Upperbound(u_to_open) THEN
				ls_ctype = Right(ls_ctype,len(ls_ctype) - rowpos)
				IF pos(ls_record,"REF$FILE:") > 0 THEN	
					//IF pos(ls_field,"tabsketch") = 0 THEN
					this.trigger event ue_import_memo(ls_field,li_tab,ls_ctype,ls_item)
					//END IF
				ELSE
				u_to_open[li_tab].lb_ok = TRUE
				u_to_open[li_tab].dw_defaultw.trigger event ue_setitem(ls_field,ls_item,ls_ctype,1)
				END IF
				
			END IF
		ELSE
			IF Upperbound(u_to_open) > 0 THEN
				IF ls_ctype = "MAIN" THEN
					CHOOSE CASE ls_field
					CASE "versionno"
						//is_fversion = ls_item
					CASE "tabphotos"
						ii_tphoto = integer(ls_item)
					END CHOOSE
				ELSE
					u_to_open[1].lb_ok = TRUE
					u_to_open[1].dw_defaultw.trigger event ue_setitem(ls_field,ls_item,ls_ctype,1)
				END IF
			END IF
		END IF
		lb_continue = TRUE
	ELSE
		lb_continue = FALSE
	END IF

	IF lb_continue THEN
		w_waiting.trigger event ue_step()
	ELSE
		w_waiting.trigger event ue_step2()
	END IF
	li_length = FileRead(li_file,ls_record)
LOOP
IF ls_record = "~~" THEN
	IF UPPER(Left(ls_ctype,4)) = "CHAR" THEN
		IF li_tab <= Upperbound(u_to_open) THEN
			u_to_open[li_tab].dw_defaultw.trigger event ue_setitem(ls_field,ls_item,ls_ctype,1)
		END IF
	END IF
END IF
//Messagebox("",ls_item)
FileClose(li_file)
SetMicroHelp(ls_mpftype)
//iF lb_validate THEN validate_all()
IF Right(ls_filename,3) = "XML" THEN
	FileDelete(ls_mpftype)
END IF
string ls_tabname
w_waiting.title = "Initializing..."
w_waiting.trigger event ue_setup(Upperbound(u_to_open))
FOR li = 1 to Upperbound(u_to_open)
	ls_tabname = u_to_open[li].dw_defaultw.trigger event ue_set_defaults("")
	w_waiting.trigger event ue_step()
	IF ls_tabname <> "" THEN u_to_open[li].Text = ls_tabname
	dw_formlist.trigger event ue_addnew()
	dw_formlist.object.formid[li] = dw_formlist.rowcount()
	dw_formlist.object.form[li] =  u_to_open[li].ls_formname 
	dw_formlist.object.lorder[li] = dw_formlist.rowcount()
	dw_formlist.object.tabname[li] = ls_tabname
	dw_formlist.object.loaded[li] = "Y"
	dw_formlist.object.fupdate[li] = "Y"
	dw_formlist.object.version[li] = u_to_open[li].is_version
	 u_to_open[li].is_cversion = ProfileString(is_formini,u_to_open[li].ls_formname,"Version5","")
	dw_formlist.object.tabid[li] = li
	u_to_open[li].ii_formrow = li
	u_to_open[li].lb_changed = TRUE
	IF ls_tabname = "RECS" OR ls_tabname = "RECOMMENDATIONS" THEN
		dw_formlist.object.recs[li] = "Y"
	END IF
NEXT
Close(w_waiting)
end event

event ue_zip(boolean lb_dozip);Integer lz, li, lx
String ls_field, ls_photo

IF lb_errors THEN RETURN
backup_file(ls_zipfile)
openwithparm(w_simplezip,ls_zipfile)
//w_simplezip.lb_list.additem(ls_filename)
//IF lb_photo THEN
//	FOR lz = 1 to Upperbound(u_to_open)
//		FOR li = 1 to Integer(u_to_open[lz].dw_defaultw.Object.DataWindow.Column.Count)
//			ls_field = u_to_open[lz].dw_defaultw.Describe("#" + string(li) + ".Name")
//			IF left(ls_field,6) = "photo_" THEN
//				FOR lx = 1 TO u_to_open[lz].dw_defaultw.rowcount()
//					ls_photo = string(u_to_open[lz].dw_defaultw.object.data[lx,li])
//					IF FileExists(ls_photo) THEN
//						w_simplezip.lb_list.additem(ls_photo)
//					ELSE
//						//Messagebox("Warning","File not found " + ls_item)
//					END IF
//				NEXT
//			END IF
//		NEXT
//	NEXT
//	lb_photo = FALSE
//END IF
w_simplezip.sle_path.text = get_pathname(ls_filename)
IF lb_dozip THEN
//	FOR lx = 1 to upperbound(ls_zipfiles)
	//	w_simplezip.ls_zip_list[lx] = ls_zipfiles[lx]
//	NEXT
	IF ProfileString(is_formini,"FORMS","ZipAll","TRUE") = "TRUE" THEN
		//w_simplezip.ziplistsub(FALSE,TRUE,"pdf")
		w_simplezip.ziplistall(FALSE,TRUE)
	ELSE
		w_simplezip.zipall(FALSE,TRUE)
	END IF	
ELSE
	w_simplezip.ue_deleteall(get_pathname(ls_filename),FALSE,TRUE)
END IF
Close(w_simplezip)




end event

event ue_delete_photos();Integer lz, li, lx
String ls_field, ls_photo

FOR lz = 1 to Upperbound(u_to_open)
	FOR li = 1 to Integer(u_to_open[lz].dw_defaultw.Object.DataWindow.Column.Count)
		ls_field = u_to_open[lz].dw_defaultw.Describe("#" + string(li) + ".Name")
		IF left(ls_field,6) = "photo_" THEN
			FOR lx = 1 TO u_to_open[lz].dw_defaultw.rowcount()
				ls_photo = string(u_to_open[lz].dw_defaultw.object.data[lx,li])
				IF FileExists(ls_photo) THEN
					IF NOT FileDelete(ls_photo) THEN
						Messagebox("Warning", ls_photo + " can not be deleted")
					END IF
				ELSE
					//Messagebox("Warning","File not found " + ls_item)
				END IF
			NEXT
		END IF
	NEXT
NEXT


end event

event type integer ue_print_pdf(n_cst_printer adobe_reader, string ls_pdfname, boolean lb_close);Integer li, li_count = 0, li_tab, lx, li_test

IF lb_close THEN w_forms_main.i_active_sheet.visible = FALSE
//li_count = Upperbound(u_to_open)
//FOR li = 1 to Upperbound(u_to_open)
//	IF u_to_open[li].dw_defaultw.rowcount() > 0 THEN
//		u_to_open[li].dw_report.trigger event ue_print_job(-2)
//		adobe_reader.of_print2pdf(u_to_open[li].dw_report,ls_pdfname + string(li) + ".pdf")
//		adobe_reader.ue_addfile(ls_pdfname + string(li) + ".pdf",TRUE)
//	END IF
//NEXT

open(w_waiting)
open(w_forms_print)
w_forms_main.i_active_sheet.trigger event ue_print()
//w_forms_print.cb_5.trigger event clicked()
//Yield()
//li_count = w_forms_print.dw_report.trigger event ue_print_pdf(ls_pdfname)

//w_forms_print.dw_report.trigger event ue_setup(w_forms_print.dw_report)
//adobe_reader.of_print2pdf(w_forms_print.dw_report,ls_pdfname + "1.pdf")
//adobe_reader.ue_addfile(ls_pdfname + "1.pdf",TRUE)

w_forms_print.lb_list.setstate(0,TRUE)
IF w_forms_print.dw_report.trigger event ue_setup(w_forms_print.dw_report) THEN
	adobe_reader.of_print2pdf(w_forms_print.dw_report,ls_pdfname + ".pdf")
	//CHOOSE CASE set_ini("Choose ADOBE=Acrobat Reador or PDF=Default (Recommended)","Adobe","Default","PDF",FALSE) 
	//CASE "PDF","PDF995"
	//CASE ELSE
		//adobe_reader.ue_addfile(ls_pdfname + ".pdf",FALSE)
	//END CHOOSE
	li_count = 1
ELSE
    w_waiting.title = "Please wait..."
	FOR li = 1 to w_forms_print.lb_list.totalitems()
		li_tab = w_forms_main.i_active_sheet.dw_formlist.trigger event ue_setup_form(li,TRUE)
		IF w_forms_main.i_active_sheet.dw_formlist.trigger event ue_multiple(w_forms_print.lb_list.text(li)) THEN
			li_test = 	w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_print_all(-2)
			adobe_reader.of_print2pdf(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report,ls_pdfname + string(li) + string(lx,"00") + ".pdf")
			//CHOOSE CASE set_ini("Choose ADOBE=Acrobat Reador or PDF=Default (Recommended)","Adobe","Default","PDF",FALSE) 
			//CASE "PDF","PDF995"
			//CASE ELSE
				//adobe_reader.ue_addfile(ls_pdfname + string(li) + string(lx,"00") + ".pdf",FALSE)
			//END CHOOSE
			li_count += 1
		ELSE
			FOR lx = 1 to 10
				li_test = 	w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_print_specific(-2, lx)
			//li_test = 	w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_print_all(-2)
				IF li_test > 0 THEN
					adobe_reader.of_print2pdf(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report,ls_pdfname + string(li) + string(lx,"00") + ".pdf")
					//CHOOSE CASE set_ini("Choose ADOBE=Acrobat Reador or PDF=Default (Recommended)","Adobe","Default","PDF",FALSE) 
					//CASE "PDF","PDF995"
					//CASE ELSE
						//adobe_reader.ue_addfile(ls_pdfname + string(li) + string(lx,"00") + ".pdf",FALSE)
					//END CHOOSE
				//w_waiting.trigger event ue_step2()
					li_count += 1
				END IF
			NEXT
		END IF
	NEXT
END IF
		
IF w_forms_print.lb_perror THEN 
	Messagebox("Print PDF","Errors were found")
	li_count = 0
END IF
	
IF lb_close THEN 
	close(w_forms_print)
	close(w_forms_new)
	close(w_forms_main)
END IF
RETURN li_count

end event

event type integer ue_load_form(string ls_fname, string ls_tabname, string ls_formlib);Integer li, rtncode, li_pos
Boolean lb_open = TRUE
String dwsyntax, errorbuffer

li_pos = pos(ls_fname, "!")
IF li_pos > 0 THEN
	li = Integer(Right(ls_fname, len(ls_fname) - li_pos))
	ls_fname = Left(ls_fname, li_pos - 1)
	//IF li > Upperbound(u_to_open) THEN RETURN 0
ELSE
	FOR li = 1 to Upperbound(u_to_open)
		IF u_to_open[li].ls_formname = ls_fname THEN
			RETURN li
		END IF
	NEXT
	li = Upperbound(u_to_open) + 1
END IF

//IF Left(ls_fname,4) = "main" THEN 
	//ls_formlib = ls_template + ls_flibrary
//ELSE

//END IF
dwsyntax = this.trigger event ue_get_syntax(ls_formlib,ls_fname,FALSE,TRUE)
IF ISNULL(dwsyntax) OR dwsyntax = "" THEN 
ELSE
	li = this.trigger event ue_open_tab(li)
	u_to_open[li].ls_formlibrary = ls_formlib
	u_to_open[li].ls_formname = ls_fname
	u_to_open[li].li_formnum = li
     u_to_open[li].lb_ok = TRUE
	u_to_open[li].is_cversion = ProfileString(is_formini,ls_fname,"CVersion","")
	rtncode = u_to_open[li].dw_defaultw.create(dwsyntax,ErrorBuffer)
	ls_tabname = u_to_open[li].dw_defaultw.trigger event ue_set_defaults(ls_tabname)
	IF ls_tabname <> "" THEN u_to_open[li].Text = ls_tabname
//	IF u_to_open[li].rte_control.visible THEN
//		u_to_open[li].rte_control.height = &
//			(this.height - u_to_open[li].rte_control.y) - 500
//		u_to_open[li].rte_control.width = &
//			(this.width - u_to_open[li].rte_control.x) - 150
//	ELSE
		u_to_open[li].dw_defaultw.height = &
			(this.height - u_to_open[li].dw_defaultw.y) - 500
		u_to_open[li].dw_defaultw.width = &
			(this.width - u_to_open[li].dw_defaultw.x) - 150
//	END IF
	RETURN li
END IF
RETURN 0
		
end event

event ue_dup_fields(integer li_new);//Integer li, li_field
//String ls_field
//IF li_new > upperbound(u_to_open) THEN li_new = 1
//IF li_new > 1 THEN
//FOR li = 1 to Integer(u_to_open[li_new].dw_defaultw.Object.DataWindow.Column.Count)
//	ls_field = u_to_open[li_new].dw_defaultw.Describe("#" + string(li) + ".Name")
//	IF Left(ls_Field,3) <> "tab" THEN
//		CHOOSE CASE ls_field
//		CASE "zrecno"
//		CASE ELSE
//			li_field = u_to_open[1].dw_defaultw.trigger event ue_check_field(u_to_open[1].dw_defaultw,ls_Field)	
//			IF li_field > 0 THEN
//				u_to_open[li_new].dw_defaultw.setitem(1,ls_field,u_to_open[1].dw_defaultw.object.data[1,li_field])
//			END IF
//		END CHOOSE
//	END IF
//NEXT
//END IF
end event

event type integer ue_load_pictures();Integer li, lz, ly, li_count = 0
string ls_field, ls_ctype

//IF lb_close THEN w_forms_new.visible = FALSE

dw_formlist.trigger event ue_loadall()
FOR lz = 1 to Upperbound(u_to_open)
 FOR li = 1 to Integer(u_to_open[lz].dw_defaultw.Object.DataWindow.Column.Count)
	ls_field = u_to_open[lz].dw_defaultw.Describe("#" + string(li) + ".Name")
	FOR ly = 1 to u_to_open[lz].dw_defaultw.rowcount()
		CHOOSE CASE Left(ls_field,6)
		CASE "photo_" 
			IF FileExists(u_to_open[lz].dw_defaultw.object.data[ly,li]) THEN
				li_count += 1
				ls_photos[li_count] = string(u_to_open[lz].dw_defaultw.object.data[ly,li])
			END IF
		END CHOOSE
	NEXT
 NEXT
NEXT

//IF lb_close THEN close(w_forms_new)
RETURN li_count

end event

event type string ue_save_memo(string ls_field, string ls_item, integer li_tab);integer li_file
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
end event

event type string ue_import_memo(string ls_field, integer li_tab, string ls_ctype, string ls_sitem);integer li_file, li, li_pos
string ls_record, ls_memofile, ls_item = ""
long ll_len, ll_start, li_length

w_waiting.trigger event ue_setup2(100)

IF pos(ls_sitem,"REF$FILE:") > 0 THEN 
	li_pos = pos(ls_sitem,"REF$FILE:") + 9
	ls_memofile = Mid(ls_sitem, li_pos, len(ls_sitem) -li_pos + 1)
	ls_memofile = get_pathname(ls_filename) + get_filename(ls_memofile)
ELSE
	ls_memofile = get_pathname(ls_filename) + ls_field + string(li_tab) + ".txt"
END IF

IF FIleExists(ls_memofile) THEN
	w_waiting.trigger event ue_step2()
	li_file = FileOpen(ls_memofile)
	li_length = FileRead(li_file,ls_record)
	DO WHILE li_length >= 0
		IF pos(ls_field,"tabsketch") > 0 THEN
			ls_item += ls_record
		ELSE
			FOR li = 1 to len(ls_record)
				CHOOSE CASE mid(ls_record,li,1)
				CASE "|"
					ls_item += "~r~n"
				CASE ELSE
					ls_item += mid(ls_record,li,1)
				END CHOOSE
			NEXT
		END IF
		li_length = FileRead(li_file,ls_record)
	LOOP
	FileClose(li_file)
ELSE
	Messagebox("Import Memo",ls_sitem + " does not exist")
END IF
li_length = len(ls_item)
//Messagebox(ls_memofile,string(len(ls_item)))

u_to_open[li_tab].dw_defaultw.trigger event ue_setitem(ls_field,ls_item,ls_ctype,1)

w_waiting.trigger event ue_end2()

RETURN ls_item
end event

event type string ue_import_srd(string ls_tempdir, string ls_name, string ls_templib);string pwsyntax = "", ErrorBuffer, ls_rec, ls_tname
integer rtncode, li_FileNum, li_length
boolean lb_success = FALSE
IF Right(ls_tempdir,1) <> "\" THEN ls_tempdir += "\"
//IF li_num = 0 THEN
//	ls_tname = ls_type + "_" + ls_form
//	ls_name = ls_tempdir + ls_type + "_" + ls_form + ".srd"
//ELSE
//	ls_tname = ls_type + "_" + ls_form + string(li_num)
//	ls_name = ls_tempdir + ls_type + "_" + ls_form + string(li_num) + ".srd"
//END IF
ls_tname = Left(ls_name,len(ls_name) - 4)
	
IF FileExists(ls_name) THEN
	pwsyntax = get_dwsyntax(ls_name)
	IF Not FileExists(ls_templib) THEN
		rtncode = LibraryCreate(ls_templib)
		IF rtncode <> 1 THEN
			Messagebox(ls_templib,"Unable to create")
		END IF
	END IF		
	rtncode = LibraryImport(ls_templib, ls_tname, ImportDataWindow!, &
     pwsyntax, ErrorBuffer )
	IF rtncode <> 1 THEN	
		SetProfileString(is_formini,ls_tname,"Update","Yes")
		Messagebox(ls_tname,ErrorBuffer)
	ELSE
		lb_success = TRUE
		//IF NOT FileDelete(ls_name) THEN
			//Messagebox("Import SRD","Problem deleting " + ls_name)
		//END IF
	END IF
END IF
IF lb_success THEN RETURN ls_tname
RETURN ""
end event

event type string ue_unzip_mfz(string ls_formname);String ls_tempdir, ls_Formlib, ls_Formver, ls_cversion, ls_oversion, ls_error= "", ls_fname, ls_recs
String ls_wversion, ls_options = "abcdefghijklmnopqrstuvwxyz"
Integer li, lpos, li_count = 0
Boolean lb_update, lb_ask = TRUE, lb_web = FALSE

IF ls_form = "" THEN ls_form = ls_formname
lb_update = FALSE


// To load old files
IF pos(ls_formname,"!") > 0 THEN
	lpos = pos(ls_formname,"!")
	ls_formname = Left(ls_formname,lpos - 1) 
END IF

ls_formname = ProfileString(is_formini,ls_formname,"Load",ls_formname)

ls_oversion = ProfileString(is_formini,ls_formname,"CVersion5","1.00")
ls_oversion = ProfileString(is_formini, ls_formname,"Version",ls_oversion)

ls_cversion = ProfileString(is_formini,ls_Formname,"Version5","")
ls_wversion = ProfileString(is_formini,"Web Options",ls_formname,"")
IF ls_cversion = "" THEN lb_update = TRUE

IF ProfileString(is_formini, ls_formname,"Web","No") = "Yes" THEN
	IF ls_wversion <> ls_cversion THEN lb_web = TRUE
	IF ProfileString(is_formini, ls_formname,"WebUpdate","No") = "Yes" THEN lb_web = TRUE
	IF FileExists(ii_templates + "sscgforms\" +  ls_formname + ".mfz") THEN 
		IF ls_cversion = "" THEN lb_web = FALSE
	END IF
	IF lb_web THEN
		IF Messagebox("Web Update Available","Do you wish to connect and update",Question!, YesNo!,2) = 1 THEN
			setprofilestring(is_formini,"FTP","Profile","Default")
			open(w_ftp_download)
			IF w_ftp_download.trigger event ue_getfile(ProfileString(is_formini,"FTP","Repfiles","/repfiles"), &
				ii_templates + "\sscgforms",ls_formname + ".mfz") THEN
					lb_update = TRUE
					lb_ask = FALSE
					SetProfileString(is_formini, ls_formname,"WebUpdate","No")
					SetProfilestring(is_formini,ls_formname,"Update","YES")
					close(w_ftp_download)
			ELSE
				restore_file(ii_templates + "\sscgforms\"+ ls_formname + ".mfz")
				Messagebox("Web Transfer",ls_formname + ".mfz" + " not found on server")
				//RETURN ""
			END IF
		END IF
	END IF
END IF

ls_formlib = ProfileString(is_formini,ls_Formname,"Form","")
IF ls_formlib = "" THEN lb_update = TRUE
IF ls_oversion = "" THEN ls_oversion = ls_cversion

//only used in testing module
	IF Upper(ProfileString(is_formini,ls_formname,"Update","Yes")) = "N/A" THEN 
		RETURN ls_formlib
	END IF
	IF Upper(ProfileString(is_formini,ls_form,"Update","Yes")) = "N/A" THEN 
		RETURN ls_formlib
	END IF


//IF pos(ls_formlib,".") > 0 AND pos(ls_formlib, "_5") = 0 THEN 
//	IF Profilestring(is_formini,"Utilities","FormError","") = "" THEN
//		ls_formlib = Left(ls_formlib,pos(ls_formlib,".") - 1) + "_5" +  Right(ls_formlib,4)
//	END IF
//END IF

IF Upper(Profilestring(is_formini,ls_formname,"Update","YES")) = "YES" THEN
	ls_error += "~r~nUpdate reset for " + ls_formname
	lb_update = TRUE
END IF

IF  ls_oversion <> ls_cversion THEN 
	ls_error += "~r~nVersion " + ls_cversion + " needs to be updated to " + ls_oversion
	lb_update = TRUE
END IF	

//IF lb_update_mfz THEN 
	//ls_error += "~r~nMain Load Form-Unzip MFZ reset"
	//lb_update = TRUE
//END IF	

IF 	ProfileString(is_formini,ls_formname,"SRD","No") = "Yes" THEN ls_formlib = "SRD"
IF ls_formlib = "SRD" THEN
	IF FileExists(ii_templates + "sscgsrd\dw_" + ls_formname + ".srd") THEN 
		IF NOT lb_update THEN RETURN "SRD"
	END IF
	lb_update = TRUE
END IF

IF lb_update THEN
	FOR li = 1 to len(ls_options)
		IF Profilestring(gs_ini, ls_formname + mid(ls_options,li,1),"PUpdate","") <> "" THEN
			SetProfileString(gs_ini,ls_formname + mid(ls_options,li,1),"PUpdate","N/A")
		END IF
	NEXT
	IF FileExists(ii_templates + "sscgforms\" + ls_formname + ".mfz") THEN
		IF lb_ask THEN
			IF Messagebox("Form Update-Unzip MFZ",ls_formname + " update version was triggered." + ls_error + "~r~n Do you wish to continue",Question!,YesNo!,2) = 2 THEN
				SetProfileString(is_formini,ls_formname,"Update","No")
				RETURN ls_formlib
			END IF
		END IF
	ELSE
		Messagebox("Form Error", ls_formname + " update version was triggered." + ls_error + "~r~n" + ii_Templates + "sscgforms\" + ls_formname + ".mfz  does not exist")
		RETURN ""
	END IF
	openwithparm(w_simplezip,ii_templates + "sscgforms\" +  ls_formname + ".mfz")
	w_simplezip.ue_unzipall(ii_templates + "sscgforms\" + ls_formname + ".mfz","") 
	ls_tempdir = w_simplezip.ue_finddir()
	ls_formlib = get_dwsyntax(ls_tempdir + "form.txt")
	ls_formver = get_dwsyntax(ls_tempdir + "version.txt")
	IF ls_formver = "" THEN ls_formver = "1.00"
	FOR li = 1 TO w_simplezip.lb_list.totalitems()
		CHOOSE CASE UPPER(Right(w_simplezip.lb_list.text(li),3))
		CASE "SRD"
			IF pos(w_simplezip.lb_list.text(li),"_header") > 0 THEN
				SetProfileString(is_formini,ls_formname,"FORMHEADER","YES")
				//SetProfileString(is_formini,ls_formname,"Choices","No")
			END IF
			IF pos(w_simplezip.lb_list.text(li),"_footer") > 0 THEN
				SetProfileString(is_formini,ls_formname,"FORMHEADER","YES")
				//SetProfileString(is_formini,ls_formname,"Choices","No")
			END IF
			ls_fname = w_simplezip.lb_list.text(li)
			IF ls_formlib = "SRD" OR ProfileString(is_formini,ls_formname,"SRD","") = "Yes" THEN
				CreateDirectory(ii_templates + "\sscgsrd\")							
				FileCopy(ls_tempdir + w_simplezip.lb_list.text(li),ii_templates + "\sscgsrd\" + w_simplezip.lb_list.text(li), TRUE)
				this.trigger event ue_delete_print(ii_templates + "\sscgsrd\" + w_simplezip.lb_list.text(li))
			ELSE
				this.trigger event ue_import_srd(ls_tempdir,w_simplezip.lb_list.text(li),ii_templates + ls_formlib) 
			END IF				
			IF pos(ls_fname,"dw_") > 0 THEN
				li_count += 1
				ls_fname = Mid(ls_fname,4,len(ls_fname) - 7)
				SetProfileString(is_formini,ls_formname,string(li_count),ls_fname)
				IF li_count = 1 THEN
					SetProfileString(is_formini,ls_fname,"Form",ls_formlib)
					SetProfileString(is_formini,ls_fname,"CVersion5",ls_formver)
					IF lb_web THEN SetProfileString(is_formini,"Web Options",ls_fname,ls_formver)
					IF ls_cversion = "" THEN ls_oversion = ls_formver
				ELSE
					SetProfileString(is_formini,ls_fname,"Load",ls_formname)
				END IF
				SetProfileString(is_formini,ls_fname,"Update","No")
			END IF
			IF pos(ls_fname,"pw_") > 0 THEN 
				ls_fname = Mid(ls_fname,4,len(ls_fname) - 7)
				IF ls_fname = ls_formname + "a" THEN SetProfileString(is_formini,ls_formname,"FORMHEADER","YES")
				SetProfileString(is_formini,ls_fname,"PUpdate","YES")
				SetProfileString(is_formini,ls_fname,"Load",ls_formname)
			END IF
		CASE "JPG","HLP","DOT","INI"
			IF pos( w_simplezip.lb_list.text(li),"_recs") > 0 THEN
				w_waiting.trigger event ue_copyfile(ls_tempdir + w_simplezip.lb_list.text(li),ii_templates + w_simplezip.lb_list.text(li), FALSE)
				ls_recs = w_simplezip.lb_list.text(li)
				SetProfileString(is_formini,ls_formname,"Recs",Left(ls_recs,len(ls_recs) - 4))
			ELSE
				w_waiting.trigger event ue_copyfile(ls_tempdir + w_simplezip.lb_list.text(li),ii_templates + w_simplezip.lb_list.text(li), FALSE)
				//FileCopy(ls_tempdir + w_simplezip.lb_list.text(li),ii_templates + w_simplezip.lb_list.text(li), TRUE)
			END IF
		END CHOOSE
	NEXT
	SetProfileString(is_formini,ls_formname,"Form",ls_formlib)
	SetProfileString(is_formini,ls_formname,"Version5",ls_formver)
	ls_oversion = ProfileString(is_formini,ls_formname,"CVersion5","1.00")
	ls_oversion = ProfileString(is_formini, ls_formname,"Version",ls_oversion)
	IF ls_formver <> ls_oversion THEN
		Messagebox("Warning","Version#  " + ls_oversion + " does not match " + ls_formver + &
				"~r~nPlease call office and ask for updated form " + ls_formname)
		SetProfileString(is_formini,ls_formname,"Version",ls_formver)
	END IF
	ls_cversion = ls_formver
	w_simplezip.deleteall(FALSE,TRUE)
	close(w_simplezip)
	SetProfileString(is_formini,ls_formname,"Update","No")
END IF
RETURN ls_formlib

end event

event type integer ue_get_tab(string ls_fname);Integer li, li_pos

li_pos = pos(ls_fname, "!")
IF li_pos > 0 THEN
	li = Integer(Right(ls_fname, len(ls_fname) - li_pos))
	ls_fname = Left(ls_fname, li_pos - 1)
	//li_tab = this.trigger event ue_load_zip(ls_fname,"",li)
	IF li <= Upperbound(u_to_open) THEN RETURN li
END IF

RETURN 0

end event

event ue_retrieve_zip();Integer li_file, li_count, li_length, li, li_load = 0
string ls_record, ls_fname, ls_item[]

Timer(0)
lb_ready = FALSE

ls_cdir = get_pathname(ls_filename)

integer lpos, rpos, lx
string ls_test
li_file = FileOpen(ls_cdir + "\location.mpf")
li_length = FileRead(li_file,ls_record)
li = 0

DO WHILE li_length > 0
	lpos = pos(ls_record,">")
	rpos = pos(ls_record,"~~")
	IF pos(ls_record,"<locnum") > 0 THEN
		li += 1
		ls_location[li] = mid(ls_record,lpos + 1, rpos - lpos - 1)
	END IF
	IF pos(ls_record,"<locdes") > 0 THEN ls_building[li] = mid(ls_record,lpos + 1, rpos - lpos - 1)
	li_length = FileRead(li_file,ls_record)
LOOP

FileClose(li_file)

li_file = FileOpen(ls_filename)
li_length = FileRead(li_file,ls_record)
li_count = 0
DO WHILE li_length > 0
	li += 1
	ls_item[li] = ls_record
	IF Integer(left(ls_record,2)) > 0 THEN li_count += 1
	li_length = FileRead(li_file,ls_record)
LOOP

FileClose(li_file)

dw_formlist.trigger event ue_reretrieve()

IF dw_formlist.rowcount() = 0 THEN
openwithparm(w_waiting,"Loading...-" + string(li_count))
FOR li = 1 TO Upperbound(ls_item)
	li_count = Integer(left(ls_item[li],2))
	ls_fname = Right(ls_item[li],len(ls_item[li]) - 2)
	CHOOSE CASE li_count
	CASE 0
		li_count = Integer(mid(ls_item[li],3,2))
		ls_fname = Right(ls_item[li],len(ls_item[li]) - 9)
		CHOOSE CASE Mid(ls_item[li],5,5)
		CASE "TABNM"
			dw_formlist.object.tabname[dw_formlist.rowcount()] = ls_fname
			IF li_count <= Upperbound(u_to_open) THEN
				u_to_open[li_count].text = ls_fname
			END IF
		CASE "LOCAT"
			dw_formlist.object.location[dw_formlist.rowcount()] = ls_fname
			IF li_count <= Upperbound(u_to_open) THEN
				u_to_open[li_count].is_location = ls_fname
				IF ls_fname <> "none" THEN
					//IF len(ls_fname) > 0 THEN u_to_open[li_count].visible = FALSE
				END IF
			END IF
		CASE "BUILD"
			dw_formlist.object.building[dw_formlist.rowcount()] = ls_fname
			IF li_count <= Upperbound(u_to_open) THEN
				u_to_open[li_count].is_building = ls_fname
			END IF
		CASE "VERSN"
			dw_formlist.object.version[dw_formlist.rowcount()] = ls_fname
			IF li_count <= Upperbound(u_to_open) THEN
				u_to_open[li_count].is_version = ls_fname
			END IF
		CASE "PHOTO"
			ii_tphoto = Integer(ls_Fname)
		CASE "DUPLS"
			this.trigger event ue_load_dups(ls_fname,1,1)
		CASE "PDFTP"
			ls_pdftype = ls_fname
		END CHOOSE
	CASE ELSE
		dw_formlist.trigger event ue_addnew()
		dw_formlist.object.formid[dw_formlist.rowcount()] = li_count
		dw_formlist.object.form[dw_formlist.rowcount()] = Left(ls_fname,len(ls_fname) - 4)
		dw_formlist.object.lorder[dw_formlist.rowcount()] = li_count
		dw_formlist.trigger event ue_setup_form(1,FALSE)
		//dw_formlist.object.tabid[dw_formlist.rowcount()] = li_count
		//this.trigger event ue_import_zip(ls_fname, li_count)
		//dw_formlist.object.loaded[dw_formlist.rowcount()] = "Y"
	END CHOOSE
NEXT
close(w_waiting)
ELSE
	FOR li = 1 TO Upperbound(ls_item)
		li_count = Integer(left(ls_item[li],2))
		ls_fname = Right(ls_item[li],len(ls_item[li]) - 2)
		IF li_count <> 0 THEN
			CHOOSE CASE Mid(ls_item[li],5,5)
			CASE "PHOTO"
				ii_tphoto = Integer(ls_Fname)
			CASE "PDFTP"
				ls_pdftype = right(ls_item[li],len(ls_item[li]) - 9)
			CASE "PDRST"
				IF right(ls_item[li],len(ls_item[li]) - 9) = "TRUE" THEN
					lb_pdfreset = TRUE
				END IF
			CASE "DUPLS"
				this.trigger event ue_load_dups(ls_fname,1,1)
			END CHOOSE
		END IF
	NEXT
END IF

li_count = dw_formlist.rowcount()
IF li_count > 15 THEN li_count = 15
open(w_waiting)
FOR li = 1 to li_count
	dw_formlist.trigger event ue_setup_form(li,FALSE)
NEXT
close(w_waiting)

IF dw_formlist.rowcount() > 15 THEN	dw_formlist.visible = TRUE

this.title = ls_form + "!" + ls_zipfile
//dw_help.trigger event ue_reretrieve()
//dw_rec_list.trigger event ue_reretrieve()

open(w_forms_special)
lb_ready = TRUE



end event

event type integer ue_import_zip(string ls_mpftype, integer li_tab);integer li_file, li_length, lpos,rpos, li, rowpos
string ls_record, ls_item = "", ls_field, ls_ctype, ls_tabname, ls_Fname,dwsyntax
boolean lb_continue = TRUE, lb_validate
integer li_test

//IF li_tab = 0 THEN li_tab = upperbound(u_to_open) + 1
//ls_Fname = ls_mpftype
//lpos = pos(ls_fname,".")
//IF lpos > 0 THEN ls_fname = Left(ls_fname,lpos - 1)
//IF li_tab = 1 THEN ls_form = ls_fname
//li_tab = this.trigger event ue_load_zip(ls_fname,"",li_tab)
//IF li_tab = 0 THEN RETURN 0
open(w_waiting)
u_to_open[li_tab].visible = TRUE
IF NOT FileExists(get_pathname(ls_filename) + ls_mpftype) THEN 
	ls_mpftype = Right(ls_mpftype,len(ls_mpftype) - 1)
	IF NOT FileExists(get_pathname(ls_filename) + ls_mpftype) THEN ls_mpftype = "defaults.mpf"
END IF
IF FileExists(get_pathname(ls_filename) + ls_mpftype) THEN 
	
this.SetMicroHelp("Opening " + ls_mpftype)

li_file = FileOpen(get_pathname(ls_filename) + ls_mpftype)
li_length = FileRead(li_file,ls_record)
w_waiting.trigger event ue_step()
DO WHILE li_length >= 0
	IF lb_continue THEN
		IF ls_record = "!" THEN 
			lb_validate = TRUE
			li_length = FileRead(li_file,ls_record)
		ELSE
			IF Trim(ls_record) = "" THEN
				li_length = FileRead(li_file,ls_record)
			END IF
		END IF
		rpos = pos(ls_record,"<")
		lpos = pos(ls_record,">")
		IF lpos > 0 THEN
			ls_field = Mid(ls_record,rpos + 1, lpos - rpos - 1)
			ls_item = ""
		END IF
		IF rpos > 0 THEN
			ls_ctype = Left(ls_record, rpos - 1)
		END IF
	END IF
	IF li_length = 0 THEN
		ls_item += "~r~n"
	ELSE
		IF pos(ls_ctype,"char(32766)") > 0 THEN
			IF ls_field = "tabsketch" THEN
				ls_item += ls_record
			ELSE
				FOR li = lpos + 1 to len(ls_record)
					CHOOSE CASE mid(ls_record,li,1)
					CASE "|"
						ls_item += "~r~n"
					CASE ELSE
						ls_item += mid(ls_record,li,1)
					END CHOOSE
				NEXT
				lpos = 0
			END IF
		ELSE
			ls_item += Mid(ls_record, lpos + 1, len(ls_record) - lpos) 
		END IF			
	END IF
	IF Right(ls_item,1) = "~~" THEN
		ls_item = Left(ls_item,len(ls_item) - 1)
		ls_ctype = Right(ls_ctype,len(ls_ctype) - rowpos)
		IF pos(ls_record,"REF$FILE:") > 0 THEN	
			this.trigger event ue_import_memo(ls_field,li_tab,ls_ctype,ls_item)
		ELSE
			u_to_open[li_tab].dw_defaultw.trigger event ue_setitem(ls_field,ls_item,ls_ctype,1)
		END IF
		lb_continue = TRUE
	ELSE
		lb_continue = FALSE
	END IF

	IF lb_continue THEN
	ELSE
		w_waiting.trigger event ue_step2()
	END IF
	li_length = FileRead(li_file,ls_record)
LOOP
IF ls_record = "~~" THEN
	IF UPPER(Left(ls_ctype,4)) = "CHAR" THEN
		u_to_open[li_tab].dw_defaultw.trigger event ue_setitem(ls_field,ls_item,ls_ctype,1)
	END IF
END IF
FileClose(li_file)
END IF
SetMicroHelp(ls_mpftype)
ls_tabname = u_to_open[li_tab].dw_defaultw.trigger event ue_set_defaults("")
IF li_tab = 1 THEN u_to_open[li_tab].dw_defaultw.trigger event ue_display_pictures(TRUE)
IF ls_tabname <> "" THEN u_to_open[li_tab].text = ls_tabname
RETURN li_tab
end event

event type boolean ue_save_form(string ls_fname, integer li_tab, integer li_copy);integer li_file, li,ly, rtn, lx
string ls_fielf, ls_ctype, ls_item, ls_new, ls_memo, ls_field, ls_save, ls_tform, ls_copy = ""
boolean lb_save

IF li_copy > 0 THEN ls_copy = string(li_copy)
IF u_to_open[li_tab].lb_ok THEN
dw_formlist.object.fupdate[u_to_open[li_tab].ii_formrow] = "Y"
dw_formlist.object.version[u_to_open[li_tab].ii_formrow] =u_to_open[li_tab].is_cversion

IF lb_web_connect THEN
	u_to_open[li_tab].dw_defaultw.trigger event ue_update()
	lb_save = TRUE
ELSE
ls_tform = get_pathname(ls_filename) + ls_fname + ls_copy +".mpf"
li_file = FileOpen(ls_tform, LineMode!, Write!, Shared!, Replace!)

u_to_open[li_tab].dw_defaultw.Sort()
FOR li = 1 to Integer(u_to_open[li_tab].dw_defaultw.Object.DataWindow.Column.Count)
	ls_field = u_to_open[li_tab].dw_defaultw.Describe("#" + string(li) + ".Name")
	ls_ctype = u_to_open[li_tab].dw_defaultw.Describe("#" + string(li) + ".ColType")
	FOR ly = 1 to u_to_open[li_tab].dw_defaultw.rowcount()
		CHOOSE CASE UPPER(Left(ls_ctype,4))
		CASE "DATE"
			ls_item = string(u_to_open[li_tab].dw_defaultw.object.data[ly,li],"mm/dd/yy")
		CASE "CHAR"
			CHOOSE CASE Left(ls_field,6)
			CASE "photo_" 
				ls_item = get_filename(string(u_to_open[li_tab].dw_defaultw.object.data[ly,li]))
				IF len(ls_item) > 0 THEN
					this.trigger event ue_zipadd(ls_item)
					IF FileExists(Left(ls_item,len(ls_item) - 3) + ".rs") THEN
						this.trigger event ue_zipadd(Left(ls_item,len(ls_item) - 3) + ".rs")
					END IF
				END IF
			CASE "tabrte"
//				ls_new = Left(ls_tform, len(ls_tform) - 4)
//				ls_new += string(li_tab) + ".rtf"
//				ls_item = get_filename(ls_new)
//				rtn = u_to_open[li_tab].rte_control.SaveDocument(ls_new, FileTypeRichText!)
//				u_to_open[li_tab].ls_rtename = ls_new
			CASE "tabske"
				ls_item = get_filename(string(u_to_open[li_tab].dw_defaultw.object.data[ly,li]))
				this.trigger event ue_zipadd(ls_item)
			CASE ELSE
				ls_item = string(u_to_open[li_tab].dw_defaultw.object.data[ly,li])
			END CHOOSE
		CASE ELSE
			CHOOSE CASE ls_field
			CASE "tabphotos"
				//ls_item = string(li_photos)
			CASE ELSE
				ls_item = string(u_to_open[li_tab].dw_defaultw.object.data[ly,li])
			END CHOOSE
		END CHOOSE
		IF ls_ctype = "char(32766)" THEN
			ls_item = string(u_to_open[li_tab].dw_defaultw.object.data[ly,li])
			IF ls_field = "tabsketch" THEN
				ls_item = this.trigger event ue_save_memo(ls_field,ls_item,u_to_open[li_tab].ii_formrow)
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
			ls_save = this.trigger event ue_save_memo(ls_field,ls_item,u_to_open[li_tab].ii_formrow)
		END IF
		IF FileWrite(li_file, ls_ctype + "<" + ls_field + "." + string(ly) + ">" + ls_save) < 0 THEN
			lb_save = FALSE
			Messagebox("FileWrite","Error writing " + ls_field)
		END IF
	NEXT
NEXT

FileClose(li_file)
this.trigger event ue_zipadd(ls_tform)
END IF
END IF
RETURN lb_save
end event

event type integer ue_load_zip(string ls_fname, string ls_tabname, integer li_tab);Integer li, rtncode, li_pos
String dwsyntax, errorbuffer, ls_formlib

ls_formlib =  this.trigger event ue_unzip_mfz(ls_Fname)

IF ls_formlib = "" THEN RETURN 0
ls_formlib = ii_templates + ls_formlib
dwsyntax = this.trigger event ue_get_syntax(ls_formlib,ls_fname,FALSE,TRUE)
IF dwsyntax <> "" THEN
//	li = this.trigger event ue_open_tab(li_tab)
//	ii_pages[li] = li
//	u_to_open[li].ls_formname = ls_fname
//	u_to_open[li].li_formnum = li
//	u_to_open[li].ls_formlibrary = ls_formlib
//	u_to_open[li].is_cversion = ProfileString(is_formini,ls_fname,"CVersion","")
//	rtncode = u_to_open[li].dw_defaultw.create(dwsyntax,ErrorBuffer)
//	IF rtncode = 1 THEN
//	     u_to_open[li].lb_ok = TRUE
//		ls_tabname = u_to_open[li].dw_defaultw.trigger event ue_set_defaults(ls_tabname)
//		IF ls_tabname <> "" THEN u_to_open[li].Text = ls_tabname
//			u_to_open[li].dw_defaultw.height = &
//				(this.height - u_to_open[li].dw_defaultw.y) - 500
//			u_to_open[li].dw_defaultw.width = &
//				(this.width - u_to_open[li].dw_defaultw.x) - 150
//	ELSE
//		Messagebox("Load Zip File","Error creating " + ls_fname)
//	END IF
//	IF li = 1 THEN 
//		ls_form = ls_fname
//		ls_library = ls_formlib
//	END IF
//	RETURN li
END IF
RETURN 0
		
end event

event type integer ue_load_dups(string ls_fname, integer li_formid, integer li_order);Boolean lb_done = FALSE
String ls_formname,dwsyntax, ls_clibrary
//String ls_formletters = " abcdefghijklmnopqrstuvwxyz"
Integer li_count = 1
ls_clibrary = ProfileString(is_formini,ls_fname,"Form","")
DO UNTIL lb_done
	li_count += 1
	li_order += 1
	li_formid += 1
	ls_formname = ls_fname + string(li_count)
	dwsyntax = this.trigger event ue_get_syntax(ls_clibrary,ls_formname,FALSE,FALSE)
//	IF dwsyntax = "" THEN 
//		ls_formname = ls_fname + mid(ls_formletters,li_count,1)
//		dwsyntax = this.trigger event ue_get_syntax(ls_clibrary,ls_formname,FALSE,FALSE)
//	END IF
	IF dwsyntax = "" THEN 
		lb_done = TRUE
		li_formid -= 1
	ELSE
		SetProfileString(is_formini,ls_formname,"Load",ls_fname)
		dw_formlist.trigger event ue_addnew()
		dw_formlist.object.formid[dw_formlist.rowcount()] = li_formid
		dw_formlist.object.form[dw_formlist.rowcount()] = ls_formname
		dw_formlist.object.lorder[dw_formlist.rowcount()] = li_order
		//dw_formlist.object.tabid[dw_formlist.rowcount()] = li_count
		//this.trigger event ue_load_zip(ls_formname,ls_formname,Upperbound(u_to_open) + 1)
	END IF		
LOOP
RETURN li_formid 
end event

event type integer ue_spellcheck();integer lx, li_count = 0

dw_formlist.trigger event ue_loadall()

FOR lx = 1 to dw_formlist.rowcount()
	IF dw_formlist.object.loaded[lx] = "Y" THEN
		u_to_open[lx].dw_defaultw.trigger event ue_spellcheck()
		li_count += 1
	END IF
NEXT

RETURN li_count
end event

event type integer ue_print_jpeg(n_cst_printer adobe_reader, string ls_pdfname, boolean lb_close);Integer li, li_count = 0, li_tab

IF lb_close THEN w_forms_main.i_active_sheet.visible = FALSE
//li_count = Upperbound(u_to_open)
//FOR li = 1 to Upperbound(u_to_open)
//	IF u_to_open[li].dw_defaultw.rowcount() > 0 THEN
//		u_to_open[li].dw_report.trigger event ue_print_job(-2)
//		adobe_reader.of_print2pdf(u_to_open[li].dw_report,ls_pdfname + string(li) + ".pdf")
//		adobe_reader.ue_addfile(ls_pdfname + string(li) + ".pdf",TRUE)
//	END IF
//NEXT

open(w_waiting)
open(w_forms_print)
w_forms_main.i_active_sheet.trigger event ue_print()
//w_forms_print.cb_5.trigger event clicked()
//Yield()
//li_count = w_forms_print.dw_report.trigger event ue_print_pdf(ls_pdfname)

//w_forms_print.dw_report.trigger event ue_setup(w_forms_print.dw_report)
//adobe_reader.of_print2pdf(w_forms_print.dw_report,ls_pdfname + "1.pdf")
//adobe_reader.ue_addfile(ls_pdfname + "1.pdf",TRUE)

IF w_forms_print.dw_report.trigger event ue_setup(w_forms_print.dw_report) THEN
	li_count = adobe_reader.ue_zvprt(w_forms_print.dw_report,ls_pdfname)
	
ELSE
	FOR li = 1 to w_forms_print.lb_list.totalitems()
		li_tab = w_forms_main.i_active_sheet.dw_formlist.trigger event ue_setup_form(li,TRUE)
		w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report.trigger event ue_print_all(-2)
		li_count += adobe_reader.ue_zvprt(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_report,ls_pdfname + string(li) )
	NEXT
END IF
		
IF lb_close THEN 
	close(w_forms_print)
	close(w_forms_new)
	close(w_forms_main)
END IF
RETURN li_count

end event

event type string ue_get_syntax(string ls_formlib, string ls_fname, boolean lb_print, boolean lb_ask);string dwsyntax = "",  ls_ptype = "dw_"
IF lb_print THEN ls_ptype = "pw_"
	
IF ls_formlib = "" THEN 
	ls_formlib = Profilestring(is_formini,Profilestring(is_formini,ls_fname,"Load",ls_fname),"Form","")
END IF
IF pos(ls_formlib,"SRD") > 0 OR ProfileString(is_formini,ls_fname,"SRD","") = "Yes" THEN
	IF FileExists(ii_templates + "\sscgsrd\" + ls_ptype + ls_fname + ".srd") THEN
		dwsyntax = get_dwsyntax(ii_templates + "\sscgsrd\" + ls_ptype + ls_fname + ".srd")
	ELSE
		IF lb_print THEN
			IF lb_ask THEN
				IF FileExists(ii_templates + "\sscgsrd\dw_" + ls_fname + ".srd") THEN
					dwsyntax = get_dwsyntax(ii_templates + "\sscgsrd\dw_" + ls_fname + ".srd")
				ELSE
					Messagebox("Load Form-Get Syntax","Library can not find form " + ii_templates + "\sscgsrd\dw_" + ls_fname + ".srd")
					RETURN ""
				END IF
			ELSE
				RETURN ""
			END IF
		ELSE
			IF lb_ask THEN
				Messagebox("Load Form-Get Syntax","Library can not find form " + ii_templates + "\sscgsrd\" + ls_ptype + ls_fname + ".srd")
				RETURN ""
			END IF
		END IF
	END IF
	IF ISNULL(dwsyntax) THEN RETURN ""
	RETURN dwsyntax
END IF

IF pos(ls_formlib,"\") = 0 THEN ls_formlib = ii_templates + ls_formlib
IF NOT FIleExists(ls_formlib) THEN 
	IF lb_ask THEN
		SetProfileString(is_formini,ls_fname,"Update","Yes")
		this.trigger event ue_unzip_mfz(ls_fname)
		//Messagebox("Get Syntax","Form library not found for " + ls_formlib)
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
			SetProfileString(is_formini,ls_fname,"Update","Yes")
			SetProfileString(is_formini,ls_fname,"Form",ls_formlib)
			ls_formlib = this.trigger event ue_unzip_mfz(ls_Fname)
			lb_ask = FALSE
			IF ls_formlib = "" THEN RETURN ""
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

event ue_parse_form();integer li, li_count = 0, lx, li_form = 1
string ls_return, ls_parsename, ls_pfile[], ls_formname, ls_sform, ls_main
boolean lb_found = FALSE

ls_main = get_filename(ls_zipfile)
IF pos(ls_main,"_") > 0 THEN
	ls_main = Left(ls_main,pos(ls_main,"_"))
ELSE
	ls_main = Left(ls_main,pos(ls_main,".") - 1)
END IF
dw_formlist.trigger event ue_loadall()
ls_parsename = Left(ls_zipfile,len(ls_zipfile) - 4)
FOR li = 1 to Upperbound(u_to_open)
	ls_sform =  ls_main + string(li,"00") + u_to_open[li].ls_formname
	ls_return =  u_to_open[li].dw_defaultw.trigger event ue_parse_form(ls_sform,li, li_count, li_form)
	ls_formname = Left(u_to_open[li].text,25)
	lb_found = FALSE
	FOR lx = 1 to Upperbound(ls_pfile)
		IF ls_return = ls_pfile[lx] THEN lb_found = TRUE
	NEXT
	IF lb_found THEN
		li_form += 1
	ELSE
		li_form = 1
		li_count += 1
		is_pfname[li_count] = ls_formname
		ls_pfile[li_count] = ls_return
	END IF
NEXT

FOR li = 1 TO upperbound(ls_pfile)
	ls_return =	this.trigger event ue_zipup(ls_pfile[li],get_pathname(ls_zipfile) + get_filename(ls_pfile[li]))
	IF ls_return <> "N/F" THEN is_pforms[Upperbound(is_pforms) + 1] = ls_return
NEXT
end event

event type integer ue_load_pictures_tab(integer li_tab);Integer li, lz, ly, li_count = 0
string ls_field, ls_ctype

//IF lb_close THEN w_forms_new.visible = FALSE


lz = li_Tab
 FOR li = 1 to Integer(u_to_open[lz].dw_defaultw.Object.DataWindow.Column.Count)
	ls_field = u_to_open[lz].dw_defaultw.Describe("#" + string(li) + ".Name")
	FOR ly = 1 to u_to_open[lz].dw_defaultw.rowcount()
		CHOOSE CASE Left(ls_field,6)
		CASE "photo_" 
			IF FileExists(u_to_open[lz].dw_defaultw.object.data[ly,li]) THEN
				li_count += 1
				ls_photos[li_count] = string(u_to_open[lz].dw_defaultw.object.data[ly,li])
			END IF
		END CHOOSE
	NEXT
 NEXT

//IF lb_close THEN close(w_forms_new)
RETURN li_count

end event

event type integer ue_print_all(boolean lb_close, boolean lb_preview);Integer li, li_count = 1

IF lb_close THEN w_forms_main.i_active_sheet.visible = FALSE

open(w_forms_print)
w_forms_print.lb_setup = FALSE
w_forms_main.i_active_sheet.trigger event ue_print()

w_forms_print.lb_list.setstate(0,TRUE)
IF lb_preview THEN
	w_forms_print.cb_4.trigger event clicked()
ELSE
	w_forms_print.cb_1.trigger event clicked()
END IF	
IF lb_close THEN 
	close(w_forms_print)
	close(w_forms_new)
	close(w_forms_main)
END IF
RETURN li_count

end event

event ue_word_form();integer li, li_count = 1, lx
string ls_wordname, ls_return, ls_rarray[]

ls_wordname = Left(ls_zipfile,len(ls_zipfile) - 4)
dw_formlist.trigger event ue_loadall()
openwithparm(w_waiting,"Converting Word Forms-" + string(upperbound(u_to_open)))
FOR li = 1 to Upperbound(u_to_open)
	w_waiting.trigger event ue_step()
	ls_return =  u_to_open[li].dw_defaultw.trigger event ue_create_word(ls_wordname + string(li_count,"000"))
	IF ls_return <> "N/F" THEN
		is_pforms[li_count] = ls_return
		is_pfname[li_count] = left(u_to_open[li].text,25)
		li_count += 1
	ELSE
		ls_rarray =  u_to_open[li].dw_report.trigger event ue_jpeg_word(ls_wordname + string(li_count,"000"))
		FOR lx = 1 TO Upperbound(ls_rarray)
			IF ls_rarray[lx] <> "N/F" THEN
				is_pforms[li_count] = ls_rarray[lx]
				is_pfname[li_count] =left( u_to_open[li].text,25)
				li_count += 1
			END IF
		NEXT
	END IF
NEXT
close(w_waiting)

end event

event ue_parse_form_old();Integer li, li_count = 0, li_file = 0, li_cfile = 0, lx
string ls_tform, ls_fname, ls_tpath, ls_apath, ls_tdir, ls_pform[], ls_source, ls_copy
ls_tpath = Profilestring(is_formini,"MAIN","Tempdir","C:\sscgtemp")

//ls_template = ProfileString(is_formini,"Main","Templates"

FOR li = 1 to Upperbound(u_to_open)
	ls_fname = u_to_open[li].ls_formname
	ls_tdir = get_pathname(ls_filename) 
	IF FileExists(ii_templates + "\" + ls_fname + ".mfz") THEN
		li_cfile = 1
		li_count += 1
		ls_apath = ls_tpath + "\" +  ls_fname + string(li_count,"00") + ".mpz"
		CreateDirectory(ls_apath)
		ls_pform[li_count] = ls_apath
		IF li_file <> 0 THEN FileClose(li_file)
		li_file = FileOpen(ls_apath + "\main.mpf",LineMode!,Write!,LockReadWrite!,Replace!)
	END IF		
//	FileWrite(li_file, "00" + string(li,"00") + "TABNM" + ls_tabname[li] )
//	FileWrite(li_file, "00" + string(li,"00") + "VERSN" + ls_tversion[li] )
	ls_source = ls_tdir + string(li,"00") + ls_fname + ".mpf"
	ls_copy = ls_apath + "\" +string(li_cfile,"00") + ls_fname + ".mpf"
	FileWrite(li_file,  get_filename(ls_copy))
	IF FileCopy(ls_source,ls_copy ,TRUE) <> 1 THEN
		Messagebox("Copying Error", "Problem copying " + ls_source +  " to  " + ls_copy)
	END IF
	FOR lx = 1 to this.trigger event ue_load_pictures_tab(li)
		ls_source =  ls_photos[lx]
		ls_copy = ls_apath + "\" + get_filename(ls_photos[lx])
		IF FileCopy(ls_source,ls_copy ,TRUE) <> 1 THEN
			Messagebox("Copying Error", "Problem copying " + ls_source +  " to  " + ls_copy)
		END IF
	NEXT
	li_cfile += 1
NEXT
IF li_file <> 0 THEN FileClose(li_file)

FOR li = 1 to Upperbound(ls_pform)
	is_pforms[li] = get_pathname(ls_zipfile) + "\" + get_filename(ls_pform[li])
	Delete_file(get_pathname(ls_zipfile) + "\" + get_filename(ls_pform[li]),TRUE)
	openwithparm(w_simplezip,get_pathname(ls_zipfile) + "\" + get_filename(ls_pform[li]))
	w_simplezip.sle_path.text = ls_pform[li]
	w_simplezip.zipall(FALSE,TRUE)
	Close(w_simplezip)
NEXT
end event

event ue_word_parse();integer li, li_count = 0, lx, li_form = 1, li_fcount = 0
string ls_return, ls_parsename, ls_pfile[], ls_formname, ls_pfname[]
boolean lb_found = FALSE

//open(w_waiting)
ls_parsename = Left(ls_zipfile,len(ls_zipfile) - 4)
FOR li = 1 to Upperbound(u_to_open)
	ls_return =  u_to_open[li].dw_defaultw.trigger event ue_create_word(ls_parsename + string(li_count,"00"))
	ls_formname = Left(u_to_open[li].text,25)
	IF ls_return <> "N/F" THEN
		li_count += 1
		is_pforms[Upperbound(is_pforms) + 1] = ls_return
		is_pfname[Upperbound(is_pfname) + 1] = ls_formname
	ELSE
		ls_return =  u_to_open[li].dw_defaultw.trigger event ue_parse_form(ls_parsename,li, li_count, li_form)
	
		lb_found = FALSE
		FOR lx = 1 to Upperbound(ls_pfile)
			IF ls_return = ls_pfile[lx] THEN lb_found = TRUE
		NEXT
		IF lb_found THEN
			li_form += 1
		ELSE
			li_fcount += 1
			li_form = 1
			li_count += 1
			ls_pfile[li_fcount] = ls_return
			ls_pfname[li_fcount] = ls_formname
	END IF
	END IF
NEXT

FOR li = 1 TO upperbound(ls_pfile)
	ls_return =	this.trigger event ue_zipup(ls_pfile[li],get_pathname(ls_zipfile) + get_filename(ls_pfile[li]))
	IF ls_return <> "N/F" THEN 
		is_pforms[Upperbound(is_pforms) + 1] = ls_return
		is_pfname[Upperbound(is_pfname) + 1] = ls_pfname[li]
	END IF
NEXT
//close(w_waiting)
end event

event type string ue_zipup(string ls_path, string ls_newzip);IF FileExists(ls_newzip) THEN delete_file(ls_newzip,TRUE)
openwithparm(w_simplezip,ls_newzip)
w_simplezip.sle_path.text = ls_path
w_simplezip.zipall(FALSE,TRUE)
close(w_simplezip)
IF FileExists(ls_newzip) THEN RETURN ls_newzip
RETURN "N/F"
end event

event ue_zipadd(string ls_zipname);Integer li
Boolean lb_fzip = FALSE

FOR li = 1 to upperbound(ls_zipfiles)
	IF ls_zipfiles[li] = ls_zipname THEN lb_fzip = TRUE
NEXT

IF NOT lb_fzip THEN
	ls_zipfiles[upperbound(ls_zipfiles) + 1] = ls_zipname
END IF
end event

event ue_delete_print(string ls_file);Integer li
String ls_options = "abcdefghijklmnopqrstuv"
string ls_foptions 

IF pos(ls_file,"pw_") > 0 THEN
	ls_foptions = get_filename(ls_file)
	ls_foptions = Mid(ls_foptions,4,len(ls_foptions) - 7)
	FOR li = 1 to len(ls_options)
		// Messagebox("Delete",get_pathname(ls_file) + ls_foptions + mid(ls_options,li,1) + ".srd")
		 FileDelete(get_pathname(ls_file) + ls_foptions + mid(ls_options,li,1) + ".srd")
	NEXT
END IF

end event

event type boolean ue_web_connect();string ls_dsn

ls_dsn = set_ini("Enter Web DSN Name","WEB","DSN","mini-sql",FALSE)

websource = CREATE transaction
websource.DBMS = "ODBC"
websource.dbparm = "Connectstring='DSN=" + ls_dsn

CONNECT USING websource;

IF websource.sqlcode <> 0 THEN
	RETURN FALSE
END IF
RETURN TRUE
end event

public subroutine ue_retrieve_help (string ls_helpname);
end subroutine

on w_forms_new.create
if this.MenuName = "menu_form_new" then this.MenuID = create menu_form_new
this.dw_formlist=create dw_formlist
this.dw_rec_list=create dw_rec_list
this.dw_help=create dw_help
this.tab_main=create tab_main
this.Control[]={this.dw_formlist,&
this.dw_rec_list,&
this.dw_help,&
this.tab_main}
end on

on w_forms_new.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_formlist)
destroy(this.dw_rec_list)
destroy(this.dw_help)
destroy(this.tab_main)
end on

event open;//IF ProfileString(gs_ini,"Utilities","Form","") = "" THEN
IF ProfileString(gs_ini,"Utilities","FormError","NO") = "YES" THEN 
	menu_forms_main.m_internal.visible = TRUE
END IF

w_forms_main.i_active_sheet = this
is_formini = Profilestring(gs_ini,"Main","Forms",gs_ini)
SetProfileString(is_formini,"MAIN","InspectOpen","Yes")
IF ProfileString(is_formini,"MAIN","SpellCheck","FALSE") = "TRUE" THEN
 	menu_form_new.m_options.m_mode-spellcheck.checked = TRUE
END IF

ii_templates = ""
IF ProfileString(gs_ini,"Forms","Test","FALSE") = "TRUE" THEN
	ii_templates = set_ini("Testing Location","Forms","TestLocation","",FALSE)
	IF Not FileExists(ii_Templates) THEN
		ii_templates = ""
	ELSE
		w_forms_main.title = "[TESTING MODE]"
		is_formini = set_ini("Testing Ini","Forms","TestIni","",FALSE)
	END IF
END IF
IF ii_templates = "" THEN ii_templates = ProfileString(gs_ini,"Main","Templates","c:\minipro\template") 
IF right(ii_templates,1) <> "\"  THEN ii_templates += "\"

//open(w_forms_about)
lb_errors = TRUE
ls_zipfile = message.stringparm

IF Upper(ProfileString(is_formini,"FORMS","Pictures","YES")) = "YES" THEN
	menu_form_new.m_options.m_showpictures.checked = TRUE
	lb_photo = TRUE
ELSE
	menu_form_new.m_options.m_showpictures.checked = FALSE
	lb_photo = FALSE
END IF

//IF NOT FileExists(ls_zipfile) THEN 
//	Messagebox("Form Module",ls_zipfile + " does not exist")
//	close(w_forms_new)
//ELSE
IF ls_zipfile = "NONE" OR ls_zipfile = "WEB" THEN
	IF ls_zipfile = "WEB" THEN 
		IF NOT this.trigger event ue_web_connect() THEN lb_errors = TRUE
	END IF
	lb_ready = TRUE
ELSE
IF NOT lockfile(ls_zipfile,ProfileString(gs_ini,"Defaults","User",ProfileString(gs_ini,"Main","Username","<NONE>")),"Lock") THEN RETURN
	
openwithparm(w_simplezip,ls_zipfile)

//w_simplezip.lb_list.additem(ls_filename)
//IF FileExists(ls_zipfile) THEN 
w_simplezip.ue_unzipall(ls_zipfile,"")
ls_filename = w_simplezip.ue_findfile("main.mpf")
IF NOT FileExists(ls_Filename) THEN
	ls_filename = w_simplezip.ue_findfile("mpf")
END IF
Close(w_simplezip)
IF FileExists(ls_Filename) THEN
	lb_errors = FALSE
	timer(.2,this)
ELSE
	Messagebox("Forms File","File not found " + ls_zipfile)
END IF
END IF
//END IF
end event

event resize;Integer li
tab_main.height = this.height - tab_main.y
tab_main.width = this.width - tab_main.x
FOR li = 1 to Upperbound(u_to_open)
//	IF u_to_open[li].rte_control.visible THEN
//		u_to_open[li].rte_control.height = &
//			(this.height - u_to_open[li].rte_control.y) - 500
//		u_to_open[li].rte_control.width = &
//			(this.width - u_to_open[li].rte_control.x) - 150
//	ELSE
		u_to_open[li].dw_defaultw.height = &
			(this.height - u_to_open[li].dw_defaultw.y) - 500
		u_to_open[li].dw_defaultw.width = &
			(this.width - u_to_open[li].dw_defaultw.x) - 150
//	END IF
NEXT
end event

event closequery;Integer li
Boolean lb_changed 

lb_changed = ib_changed
FOR li = 1 to Upperbound(u_to_open)
	u_to_open[li].dw_defaultw.accepttext()
	IF u_to_open[li].lb_changed = TRUE THEN lb_changed = TRUE
NEXT
IF lb_changed THEN
	CHOOSE CASE Messagebox("Form Changed","Do you wish to save changes", Question!, YesNoCancel!,3)
	CASE 1
		IF NOT this.trigger event ue_save() THEN
			IF Messagebox("Form Changed","Some required fields are not filled out, do you wish to exit anyway", &
			  Question!,YesNo!,2) = 1 THEN
				this.trigger event ue_zip(TRUE)
			ELSE
				RETURN 1
			END IF
		ELSE
			this.trigger event ue_zip(TRUE)
		END IF
	CASE 2
		this.trigger event ue_zip(FALSE)
	CASE 3
		RETURN 1
	END CHOOSE
ELSE
	this.trigger event ue_zip(lb_zip)
END IF
//IF lb_zip THEN 
//IF lb_photo THEN this.trigger event ue_delete_photos()
RETURN 0
		
end event

event timer;li_timer += 1

IF li_timer = 3 THEN
	IF pos(ls_filename,"main.mpf") > 0 THEN
		this.trigger event ue_retrieve_zip()
	ELSE
		this.trigger event ue_retrieve()
	END IF
END IF

end event

event close;SetProfileString(is_formini,"MAIN","InspectOpen","No")
lockfile(ls_zipfile,ProfileString(gs_ini,"Defaults","User",ProfileString(gs_ini,"Main","Username","<NONE>")),"UnLock") 

end event

event activate;w_forms_main.i_active_sheet = this
end event

type dw_formlist from uo_datawindow within w_forms_new
event type integer ue_setup_form ( integer li_row,  boolean lb_temp )
event ue_close_tab ( integer li_formid )
event ue_delete_form ( )
event ue_addform ( string ls_formname,  string ls_locname,  string ls_buildname,  string ls_tabname,  integer li_formpos )
event ue_delete_tab ( integer li_tabid )
event ue_rename_tab ( integer li_formid )
event type integer ue_get_recs ( )
event type integer ue_get_last ( string ls_type )
event type string ue_tabname ( string ls_tabname,  string ls_locname,  string ls_buildname )
event ue_loadall ( )
event ue_filter ( boolean lb_filter )
event ue_parse_changed ( )
event type integer ue_check_print ( integer li_row )
event ue_parse_selected ( )
event ue_cleanup ( )
event type boolean ue_multiple ( string ls_mname )
event ue_retrieve_form ( string ls_formname,  long ll_control,  long ll_formid )
boolean visible = false
integer x = 18
integer y = 36
integer width = 2057
integer height = 1424
integer taborder = 30
boolean titlebar = true
string title = "Form List"
string dataobject = "dw_formlist"
boolean controlmenu = true
boolean minbox = true
boolean hscrollbar = true
boolean resizable = true
boolean livescroll = false
end type

event type integer ue_setup_form(integer li_row, boolean lb_temp);integer li_tab, li_formid, rtncode, li, li_norder
string ls_formlib, ls_fname, dwsyntax, errorbuffer, ls_mainform, ls_tabname

IF li_row > this.rowcount() THEN
	Messagebox("Setup Form","Unable to setup" + string(li_row))
	RETURN 0
END IF
li_tab = dw_formlist.object.tabid[li_row]
IF li_tab > 0 THEN 
	IF NOT lb_temp THEN u_to_open[li_tab].visible = TRUE
	RETURN li_tab
END IF
	ls_fname = this.object.form[li_row]
	ls_formlib =  parent.trigger event ue_unzip_mfz(ls_Fname)
	IF ls_formlib = "" THEN
		Messagebox("Load Form","Unable to load " + ls_fname)
	ELSE
	li_tab = parent.trigger event ue_open_tab(0)
	IF li_tab > 0 THEN
		li_formid = this.object.formid[li_row]
		ls_mainform = ProfileString(is_formini,ls_fname,"Load",ls_fname)
		dw_formlist.object.tabid[li_row] = li_tab
		u_to_open[li_tab].ls_formname = ls_fname
		IF this.object.tabname[li_row] = "" THEN 
			ls_tabname = u_to_open[li_tab].text
			IF pos(ls_tabname,"[") > 0 THEN ls_tabname = Left(ls_tabname,pos(ls_tabname,"[") - 1)
			this.object.tabname[li_row] = ls_tabname
			u_to_open[li_tab].text = this.trigger event ue_tabname(this.object.tabname[li_row], &
				this.object.location[li_row],this.object.building[li_row])
		END IF
		u_to_open[li_tab].ii_formrow = this.object.formid[li_row]
		IF ls_formlib = "" THEN RETURN 0
		dwsyntax = parent.trigger event ue_get_syntax(ls_formlib,ls_fname,FALSE,TRUE)		
		IF dwsyntax <> "" THEN
			rtncode = u_to_open[li_tab].dw_defaultw.create(dwsyntax,ErrorBuffer)
			IF rtncode = 1 THEN
				u_to_open[li_tab].lb_ok = TRUE
				IF lb_web_connect THEN
					IF u_to_open[li_tab].trigger event ue_setup(ls_fname,"web_",il_control, il_id, websource) <> "SUCCESS" THEN
						lb_errors = TRUE
					END IF
				ELSE
					li_tab = parent.trigger event ue_import_zip(string(li_formid,"000") + ls_fname + ".mpf", li_tab)
				END IF
				u_to_open[li_tab].dw_defaultw.height = &
					(parent.height - u_to_open[li_tab].dw_defaultw.y) - 500
				u_to_open[li_tab].dw_defaultw.width = &
					(parent.width - u_to_open[li_tab].dw_defaultw.x) - 150
			ELSE
				Messagebox("Problem Loading Form " + ls_fname, ErrorBuffer)				
			END IF
			IF this.object.tabname[li_row] <> "" THEN 
				ls_tabname = this.object.tabname[li_row]
				//20170101 SB  add rowcount to tabname
				IF u_to_open[li_tab].dw_defaultw.rowcount() > 1 THEN ls_tabname += "[" + string(u_to_open[li_tab].dw_defaultw.rowcount()) + "]"
				u_to_open[li_tab].text = this.trigger event ue_tabname(ls_tabname, &
					this.object.location[li_row],this.object.building[li_row])
			ELSE
				ls_tabname =  u_to_open[li_tab].text
				IF pos(ls_tabname,"[") > 0 THEN ls_tabname = Left(ls_tabname,pos(ls_tabname,"[") - 1)
				this.object.tabname[li_row] = ls_tabname
			END IF
			IF this.object.tabname[li_row] = "RECOMMENDATIONS" THEN this.object.recs[li_row] = "Y"
			IF this.object.tabname[li_row] = "APEX" THEN u_to_open[li_tab].li_rsketch = 99
			u_to_open[li_tab].lb_temp = lb_temp
			u_to_open[li_tab].is_location = this.object.location[li_row]
			u_to_open[li_tab].is_building = this.object.building[li_row]
			u_to_open[li_tab].is_version = this.object.version[li_row]
			u_to_open[li_tab].is_cversion = ProfileString(is_formini,ls_mainform,"Version5","")
			IF lb_temp THEN 
				u_to_open[li_tab].visible = FALSE
			ELSE
				u_to_open[li_tab].visible = TRUE
				dw_formlist.object.loaded[li_row] = "Y"
			END IF			
		END IF
	END IF
	END IF
IF this.object.lorder[li_row] = -1 THEN 
	FOR li =1 to this.rowcount()
		IF this.object.lorder[li] > 0 THEN li_norder = this.object.lorder[li]
	NEXT
	this.object.lorder[li_row] = li_norder + 1
END IF
RETURN li_tab
end event

event ue_close_tab(integer li_formid);integer li_tab, lx

IF li_formid = 0 THEN RETURN
FOR lx = 1 to this.rowcount()
	IF this.object.tabid[lx] = li_formid THEN li_tab = this.object.tabid[lx]
NEXT

IF li_tab > 0 THEN
	//u_to_open[li_tab].trigger event ue_save_all()
	//tab_main.CloseTab(u_to_open[li_tab])
	u_to_open[li_tab].visible = FALSE
	this.object.loaded[li_tab] = "N"
END IF

end event

event ue_addform(string ls_formname, string ls_locname, string ls_buildname, string ls_tabname, integer li_formpos);integer li, li_order = 0, li_formid = 0, li_tab, li_count = 0, li_total


open(w_waiting)

this.trigger event ue_filter(FALSE)
FOR li = 1 to this.rowcount()
	IF this.object.lorder[li] > li_order THEN li_order = this.object.lorder[li]
	IF li_formpos > 0 THEN
		IF this.object.formid[li] = li_formpos AND this.object.lorder[li] > 0 THEN li_formid = li_formpos
	ELSE
		IF this.object.formid[li] > li_formid THEN li_formid = this.object.formid[li]
	END IF	
NEXT
this.trigger event ue_filter(TRUE)

IF li_formpos = 0 THEN
	li_formid += 1
	li_order += 1
ELSE
	IF li_formid > 0 THEN
		Messagebox("Add New Form","Form " + string(li_formid) + " already exists")
		RETURN
	ELSE
		li_formid = li_formpos
		li_order += 1
	END IF
END IF
this.trigger event ue_addnew()
this.object.form[this.rowcount()] = ls_formname
this.object.location[this.rowcount()] = ls_locname
this.object.building[this.rowcount()] = ls_buildname
this.object.lorder[this.rowcount()] = li_order
this.object.formid[this.rowcount()] = li_formid
this.object.tabname[this.rowcount()] = UPPER(ls_tabname)
li_tab = this.trigger event ue_setup_form(this.rowcount(),FALSE)
IF li_tab > 0 THEN
	li_count = 0
	FOR li = 1 to this.rowcount()
		IF this.object.form[li] = ls_formname THEN li_count += 1
	NEXT
	//IF ls_tabname = ls_formname
	IF pos(ls_tabname,"main_") > 0 THEN ls_tabname = Right(ls_tabname,len(ls_tabname) - 5)
	IF li_count > 1 THEN ls_tabname =ls_tabname + "^" + string(li_count)
	ls_tabname = u_to_open[li_tab].dw_defaultw.trigger event ue_set_defaults(ls_tabname)
	u_to_open[li_tab].lb_changed = TRUE
	u_to_open[li_tab].dw_defaultw.trigger event ue_add_locations(ls_locname,ls_buildname)
	IF ls_tabname <> "" THEN u_to_open[li_tab].Text = this.trigger event ue_tabname(ls_tabname, ls_locname, ls_buildname)
	IF ls_tabname = "RECOMMENDATIONS" THEN this.object.recs[this.rowcount()] = "Y"
	this.object.tabname[this.rowcount()] = ls_tabname
END IF

//Load other pages
li_total = parent.trigger event ue_load_dups(ls_formname,li_formid, li_order)

IF li_total > li_formid + 1 THEN	dw_formlist.visible = TRUE

close(w_waiting)

this.setfilter("lorder > 0")
this.filter()

end event

event ue_delete_tab(integer li_tabid);integer li_tab, lx, li_loc
boolean lb_form = FALSE
string ls_tab_name

IF li_tabid < 0 THEN 
	li_tabid = abs(li_tabid)
	lb_form = TRUE
END IF
IF li_tabid = 0 THEN RETURN
FOR lx = 1 to this.rowcount()
	IF lb_form THEN
		IF this.object.formid[lx] = li_tabid THEN
			li_tab = this.object.tabid[lx]
			li_loc = lx
		END IF
	ELSE
		IF this.object.tabid[lx] = li_tabid THEN 
			li_tab = this.object.tabid[lx]
			li_loc = lx
		END IF
	END IF
NEXT

//IF li_tab > 0 THEN
	//u_to_open[li_tab].trigger event ue_save_all()
//	tab_main.CloseTab(u_to_open[li_tab])
	ls_tab_name = this.object.tabname[li_loc]
	IF ISNULL(ls_tab_name) THEN ls_tab_name = ""
	IF Messagebox("Delete Tab","Do you wish to delete " + ls_tab_name, Question!, YesNo!,2) = 1 THEN
		IF li_tab > 0 THEN 
			u_to_open[li_tab].visible = FALSE
			u_to_open[li_tab].lb_ok = FALSE
		END IF
		this.object.loaded[li_loc] = "N"
		this.object.lorder[li_loc] = -1
		//this.object.formid[li_loc] = -1
		ib_changed = TRUE
		this.trigger event ue_filter(TRUE)
	END IF
//END IF
end event

event ue_rename_tab(integer li_formid);integer li_tab, lx, li_row
string ls_name

IF li_formid = 0 THEN RETURN
FOR lx = 1 to this.rowcount()
	IF this.object.tabid[lx] = li_formid THEN 
		li_tab = this.object.tabid[lx]
		ls_name = this.object.tabname[lx]
		li_row = lx
	END IF
NEXT

IF li_tab > 0 THEN
	//u_to_open[li_tab].trigger event ue_save_all()
//	tab_main.CloseTab(u_to_open[li_tab])
	openwithparm(w_ask,"Rename Tab/" + ls_name)
	ls_name = message.stringparm
	this.object.tabname[li_row] = ls_name
	u_to_open[li_tab].text = ls_name
END IF
end event

event type integer ue_get_recs();Integer li
FOR li = 1 to this.rowcount()
	IF this.object.recs[li] = "Y" THEN 
		IF this.object.tabid[li] > 0 THEN 
			RETURN this.object.tabid[li]
		ELSE
			Messagebox("Recommendations","Recommendations page not loaded")
			RETURN 0
		END IF
	END IF
NEXT
Messagebox("Recommendations","No Recommendations page found")
RETURN 0
end event

event type integer ue_get_last(string ls_type);Integer li, li_order = 0, li_formid = 0
this.trigger event ue_filter(TRUE)
FOR li = 1 to this.rowcount()
	this.object.lorder[li] = li
NEXT

this.trigger event ue_filter(FALSE)

FOR li = 1 to this.rowcount()
	IF this.object.lorder[li] > li_order THEN li_order = this.object.lorder[li]
	IF this.object.formid[li] > li_formid THEN li_formid = this.object.formid[li]
NEXT

this.trigger event ue_filter(TRUE)

IF ls_type = "Order" THEN RETURN li_order
RETURN li_formid
end event

event type string ue_tabname(string ls_tabname, string ls_locname, string ls_buildname);integer lpos
string ls_newname
IF ISNULL(ls_tabname) THEN ls_tabname = "Unknown"
IF ls_tabname = "recommendations" THEN ls_tabname = "RECOMMENDATIONS"
//lpos = pos(ls_tabname,"^") 
//IF lpos > 0 THEN
//	ls_newname = Left(ls_tabname,lpos - 1)
//	ls_newname += " " + Right(ls_tabname,len(ls_tabname) - lpos)
//	ls_tabname = ls_newname
//END IF


//IF len(ls_locname) > 0 AND len(ls_buildname) > 0 THEN
//	ls_tabname += "[" + ls_locname + "-" + ls_buildname + "]"
//ELSE
//	IF len(ls_locname) > 0 THEN ls_tabname += "[" + ls_locname + "]"
//END IF
RETURN ls_tabname
end event

event ue_loadall();integer lx
	open(w_waiting)
	this.trigger event ue_filter(TRUE)
	FOR lx = 1 to this.rowcount()
		IF dw_formlist.object.loaded[lx] <> "Y" THEN
			this.trigger event ue_setup_form(lx,FALSE)
		END IF
	NEXT
	close(w_waiting)
end event

event ue_filter(boolean lb_filter);IF lb_filter THEN
	this.setfilter("lorder > 0")
	ib_deleted = FALSE
ELSE
	this.setfilter("")
	ib_deleted = TRUE
END IF
this.filter()
end event

event ue_parse_changed();integer li, li_count = 1, lx, li_form = 0, li_tab
string ls_return, ls_parsename, ls_pfile[], ls_formname
boolean lb_found = FALSE

ls_parsename = Left(ls_zipfile,len(ls_zipfile) - 4)
DO UNTIL Not FileExists(ls_parsename + string(li_count,"00") + ".mpz")
	li_count += 1
LOOP
open(w_waiting)
FOR li = 1 to this.rowcount()
	IF this.object.freview[li] = "Y" THEN
		IF this.object.loaded[li] <> "Y" THEN	this.trigger event ue_setup_form(li,FALSE)
		li_tab = this.object.tabid[li]
		li_form += 1
		ls_return =  u_to_open[li_tab].dw_defaultw.trigger event ue_parse_form(ls_parsename,li, li_count * -1, this.object.formid[li])
	END IF
NEXT

ls_return =	parent.trigger event ue_zipup(ls_return,get_pathname(ls_zipfile) + get_filename(ls_return))
close(w_waiting)
end event

event type integer ue_check_print(integer li_row);integer li_tab

li_tab = dw_formlist.object.tabid[li_row]
IF li_tab > 0 THEN 
	IF this.object.lprint[li_row] = "Y" THEN RETURN li_tab
END IF
RETURN 0
end event

event ue_parse_selected();integer li, li_count = 1, lx, li_form = 0, li_tab
string ls_return, ls_parsename, ls_pfile[], ls_formname
boolean lb_found = FALSE

ls_parsename = Left(ls_zipfile,len(ls_zipfile) - 4)
DO UNTIL Not FileExists(ls_parsename + string(li_count,"00") + ".mpq")
	li_count += 1
LOOP
open(w_waiting)
FOR li = 1 to this.rowcount()
	IF this.isselected(li) THEN
		IF this.object.loaded[li] <> "Y" THEN	this.trigger event ue_setup_form(li,FALSE)
		li_tab = this.object.tabid[li]
		li_form += 1
		ls_return =  u_to_open[li_tab].dw_defaultw.trigger event ue_parse_form(get_filename(ls_parsename) + string(li_count,"00"),li, li_count, this.object.formid[li])
	END IF
NEXT

ls_return =	parent.trigger event ue_zipup(ls_return,get_pathname(ls_zipfile) + get_filename(ls_return))
close(w_waiting)
end event

event ue_cleanup();integer lx, li_tab, li_count = 0
open(w_waiting)
this.trigger event ue_filter(FALSE)
FOR lx = 1 to this.rowcount()
	IF this.object.lorder[lx] < 0 THEN
		this.deleterow(lx)
		lx -= 1
	ELSE
		li_count += 1
		IF dw_formlist.object.loaded[lx] <> "Y" THEN
			li_tab = this.trigger event ue_setup_form(lx,FALSE)
		ELSE
			li_tab = this.object.tabid[lx]
		END IF
		IF li_tab > 0 THEN
			u_to_open[li_tab].lb_changed = TRUE
			u_to_open[li_tab].ii_formrow = li_count
			this.object.formid[li_tab] = li_count
		END IF
	END IF
NEXT
this.trigger event ue_loadall()
close(w_waiting)
end event

event type boolean ue_multiple(string ls_mname);Integer li
String ls_mform = ""
FOR li = 1 to this.rowcount()
	IF this.object.tabname[li] = ls_mname THEN ls_mform = this.object.form[li]
NEXT
IF ls_mform <> "" THEN
	FOR li = 1 to this.rowcount()
		IF this.object.form[li] = ls_mform + "2" THEN RETURN TRUE
	NEXT
END IF
RETURN FALSE
end event

event ue_retrieve_form(string ls_formname, long ll_control, long ll_formid);integer li, li_order = 0, li_formid = 0, li_tab, li_count = 0, li_total, li_formpos = 0
string ls_locname, ls_buildname, ls_tabname


open(w_waiting)

this.trigger event ue_filter(FALSE)
FOR li = 1 to this.rowcount()
	IF this.object.lorder[li] > li_order THEN li_order = this.object.lorder[li]
	IF li_formpos > 0 THEN
		IF this.object.formid[li] = li_formpos AND this.object.lorder[li] > 0 THEN li_formid = li_formpos
	ELSE
		IF this.object.formid[li] > li_formid THEN li_formid = this.object.formid[li]
	END IF	
NEXT
this.trigger event ue_filter(TRUE)

IF li_formpos = 0 THEN
	li_formid += 1
	li_order += 1
ELSE
	IF li_formid > 0 THEN
		Messagebox("Add New Form","Form " + string(li_formid) + " already exists")
		RETURN
	ELSE
		li_formid = li_formpos
		li_order += 1
	END IF
END IF
this.trigger event ue_addnew()
this.object.form[this.rowcount()] = ls_formname
this.object.location[this.rowcount()] = ls_locname
this.object.building[this.rowcount()] = ls_buildname
this.object.lorder[this.rowcount()] = li_order
this.object.formid[this.rowcount()] = li_formid
this.object.tabname[this.rowcount()] = UPPER(ls_tabname)
li_tab = this.trigger event ue_setup_form(this.rowcount(),FALSE)
IF li_tab > 0 THEN
	li_count = 0
	FOR li = 1 to this.rowcount()
		IF this.object.form[li] = ls_formname THEN li_count += 1
	NEXT
	//IF ls_tabname = ls_formname
	IF pos(ls_tabname,"main_") > 0 THEN ls_tabname = Right(ls_tabname,len(ls_tabname) - 5)
	IF li_count > 1 THEN ls_tabname =ls_tabname + "^" + string(li_count)
	ls_tabname = u_to_open[li_tab].dw_defaultw.trigger event ue_set_defaults(ls_tabname)
	u_to_open[li_tab].lb_changed = TRUE
	u_to_open[li_tab].dw_defaultw.trigger event ue_add_locations(ls_locname,ls_buildname)
	IF ls_tabname <> "" THEN u_to_open[li_tab].Text = this.trigger event ue_tabname(ls_tabname, ls_locname, ls_buildname)
	IF ls_tabname = "RECOMMENDATIONS" THEN this.object.recs[this.rowcount()] = "Y"
	this.object.tabname[this.rowcount()] = ls_tabname
END IF

//Load other pages
li_total = parent.trigger event ue_load_dups(ls_formname,li_formid, li_order)

IF li_total > li_formid + 1 THEN	dw_formlist.visible = TRUE

close(w_waiting)

this.setfilter("lorder > 0")
this.filter()

end event

event ue_update;string ls_mainfilename
integer li_ret, li
ls_mainfilename = get_pathname(ls_filename) + "mainform.def"

this.setfilter("")
this.filter()

FOR li = 1 to this.rowcount()
	IF ISNULL(this.object.form[li]) THEN 
		this.deleterow(li)
		li -= 1
	END IF
NEXT

uo_files uo_load
uo_load = CREATE uo_files

li_ret = uo_load.trigger event save_file(ls_mainfilename,this)

DESTROY uo_files
this.setfilter("lorder >= 0")
this.filter()

parent.trigger event ue_zipadd(ls_mainfilename)
end event

event ue_reretrieve;call super::ue_reretrieve;string ls_mainfilename, ls_test
integer li_ret, li
ls_mainfilename = get_pathname(ls_filename) + "mainform.def"

IF NOT Fileexists(ls_mainfilename) THEN RETURN
uo_files uo_load
uo_load = CREATE uo_files
uo_load.ii_limit = 1000
uo_load.trigger event load_file(ls_mainfilename,this)
DESTROY uo_files

FOR li = 1 to this.rowcount()
	this.object.tabid[li] = 0
	this.object.loaded[li] = "N"
	IF this.object.formid[li] = 0 THEN
		this.object.lorder[li] = li
		this.object.formid[li] = li
	END IF
	ls_test = this.object.form[li]
	IF pos(ls_test,".mpf") > 0 THEN
		this.object.form[li] = Left(ls_test,len(ls_test) - 4)
	END IF
	IF ls_test = "" OR ISNULL(ls_test) THEN
		this.object.loaded[li] = "N"
		this.object.lorder[li] = -1
	END IF
NEXT

this.trigger event ue_filter(TRUE)
//this.visible = TRUE
end event

event doubleclicked;call super::doubleclicked;integer li_tab, li_row
//IF this.object.tabid[row] = 0 THEN

li_row = row
open(w_waiting)
this.trigger event ue_setup_form(row,FALSE)
close(w_waiting)


//ELSE
	//u_to_open[this.object.tabid[row]].visible = TRUE
//END IF

end event

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_sort.visible = TRUE

end event

event rbuttondown;lm_list = create menu_formoptions
lm_list.dw_parent = this
this.trigger event ue_rightbutton()
lm_list.m_listview.PopMenu(PointerX(),PointerY())
destroy lm_list

end event

event ue_advanced;call super::ue_advanced;integer lx, li_row, li_corder,li, li_count = 0
string ls_ptype
//integer li_lock = 1
CHOOSE CASE li_no
CASE 0,2
this.setsort("IF(lorder = -1,9999,lorder)")
this.sort()

FOR lx = 1 to this.rowcount()
	IF this.object.lorder[lx] > 0 THEN 
		li_count += 1
		this.object.lorder[lx] = li_count
	END IF
	IF this.Isselected(lx) THEN li_row = lx
//	IF this.object.tabname[lx] = "RECOMMENDATIONS" THEN li_lock = lx
NEXT

IF li_row > 0 THEN
	ib_changed = TRUE
	li_corder = this.object.lorder[li_row]
	IF li_corder < 0 THEN
		Messagebox("Move Location","Deleted form can not be moved")
	ELSE
	CHOOSE CASE li_no
	CASE 0  //move up
		IF li_corder > 1 THEN
//		IF li_corder > li_lock THEN
			FOR lx = 1 to this.rowcount()
				IF this.object.lorder[lx] = li_corder THEN
					this.object.lorder[lx] = li_corder - 1
				ELSE
					IF this.object.lorder[lx] = li_corder - 1 THEN
						this.object.lorder[lx] = li_corder
					END IF
				END IF
			NExT
		END IF
	CASE 2  //move down
		//IF li_corder < this.rowcount() and li_corder > li_lock THEN
		IF li_corder < this.rowcount() THEN
			FOR lx =  1 TO this.rowcount() 
				IF this.object.lorder[lx] = li_corder THEN
					this.object.lorder[lx] = li_corder + 1
				ELSE
					IF this.object.lorder[lx] = li_corder + 1 THEN
						this.object.lorder[lx] = li_corder
					END IF
				END IF
			NExT
		END IF
	END CHOOSE
	this.sort()
	this.scrolltorow(li_row)
	END IF
END IF
CASE 3
	this.trigger event ue_loadall()
CASE 4
	SetProfileString(gs_ini,"Forms","ListWidth",string(this.width))
	SetProfileString(gs_ini,"Forms","ListHeight",string(this.height))
	SetProfileString(gs_ini,"Forms","ListX",string(this.x))
	SetProfileString(gs_ini,"Forms","ListY",string(this.y))
CASE 5
	IF ib_deleted THEN
		this.trigger event ue_filter(TRUE)
	ELSE
		this.trigger event ue_filter(FALSE)
	END IF
CASE 6
	this.trigger event ue_parse_selected()
CASE 7,8
	ls_ptype = "N"
	IF li_no = 7 THEN ls_ptype = "Y"
	FOR li = 1 to this.rowcount()
		this.object.lprint[li] = ls_ptype
	NEXT
CASE 99
	this.trigger event ue_cleanup()
END CHOOSE
end event

event clicked;call super::clicked;This.SelectRow(0, false)
This.SelectRow(row, true)
end event

event resize;call super::resize;//SetProfileString(is_formini,"Forms","ListWidth",string(newwidth))
//SetProfileString(is_formini,"Forms","ListHeight",string(newheight))
end event

event constructor;call super::constructor;this.height = Integer(ProfileString(gs_ini,"Forms","ListHeight",string(this.height)))
this.width = Integer(ProfileString(gs_ini,"Forms","ListWidth",string(this.width)))
this.x = Integer(ProfileString(gs_ini,"Forms","ListX",string(this.x)))
this.y = Integer(ProfileString(gs_ini,"Forms","ListY",string(this.y)))


end event

event ue_delete;integer li_row
li_row = this.getselectedrow(0)
IF li_row > 0 THEN
	this.trigger event ue_delete_tab(this.object.formid[li_row] * -1)
END IF

end event

event getkey;call super::getkey;CHOOSE CASE key
CASE KeyUpArrow!
		this.trigger event ue_advanced(0)
CASE KeyDownArrow!
		this.trigger event ue_advanced(2)
END CHOOSE
end event

type dw_rec_list from uo_datawindow within w_forms_new
boolean visible = false
integer x = 151
integer y = 224
integer width = 2533
integer height = 1424
integer taborder = 20
boolean titlebar = true
string title = "Recommendations"
string dataobject = "dw_help_list"
boolean controlmenu = true
boolean hscrollbar = true
end type

event ue_commit;call super::ue_commit;string ls_name, ls_help
integer li_ret
ls_name = set_ini("Location of Templates","MAIN","Templates","",FALSE)
ls_help = profilestring(is_formini,ls_form,"Recs","recs")
ls_name += "\" + ls_help + ".hlp"

uo_files uo_load
uo_load = CREATE uo_files

li_ret = uo_load.trigger event save_file(ls_name,this)

DESTROY uo_files

end event

event ue_reretrieve;call super::ue_reretrieve;string ls_name, ls_help
ls_name = set_ini("Location of Templates","MAIN","Templates","",FALSE)
ls_help = profilestring(is_formini,ls_form,"Recs","recs")
ls_name += "\" + ls_help + ".hlp"
dw_rec_list.title = "Recommendations Items " + ls_name

IF FileExists(ls_name) THEN
	uo_files uo_load
	uo_load = CREATE uo_files

	uo_load.trigger event load_file(ls_name,this)

	DESTROY uo_files
ELSE
	//Messagebox("Help FIle", ls_name + " not found")
END IF

Integer li
FOR li = 1 to dw_help.rowcount()
	IF Left(dw_help.object.topic[li],1) = "<" THEN
		//dw_defaultw.trigger event ue_setup_ddw(dw_help.object.topic[li])
	END IF
NEXT
		
this.sort()
	
end event

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_add.enabled = TRUE
lm_list.m_listview.m_delete.enabled = TRUE
lm_list.m_listview.m_retrieverecords.enabled = TRUE
lm_list.m_listview.m_importexport.visible = TRUE
lm_list.m_listview.m_advanced.visible = TRUE
lm_list.m_listview.m_advanced.text = "Reset Recs List"
end event

event constructor;call super::constructor;//this.trigger event ue_reretrieve()
end event

event ue_update;this.trigger event ue_commit()
end event

event ue_importfile;IF this.rowcount() > 0 THEN
	IF Messagebox("Records Found","Do you wish to replace", Question!,YesNo!,1) = 1 THEN
		this.reset()
	END IF
END IF
string ls_error = "", ls_path
long ll_rec

IF ls_file = "" THEN
	GetFileOpenName("Import File Name", ls_path, ls_file)
END IF
IF ls_file = "" THEN RETURN -99
ll_rec = this.importfile(ls_file)
CHOOSE CASE ll_rec
CASE 0
	ls_error = "End of file; too many rows"
CASE -1
	ls_error = "No rows to import"
CASE -2
	ls_error = "Empty file"
CASE -3
	ls_error = "Invalid argument"
CASE -4
	ls_error = "Invalid input"
CASE -5
	ls_error = "Could not open the file"
CASE -6
	ls_error = "Could not close the file"
CASE -7
	ls_error = "Error reading text"
CASE -8
	ls_error = "Not a TXT file"
CASE -9
	ls_error = "The user canceled the import"
CASE -10
	ls_error = "Unsupported dBase file format (not version 2 or 3)"
END CHOOSE

IF ls_error <> "" THEN
	Messagebox("Import File Error","Error importing " + ls_file + "-" + ls_error)
END IF
RETURN ll_rec
end event

event ue_print_report;this.trigger event ue_dataobject("pw_help_list")
this.trigger event ue_reretrieve()
this.Modify("DataWindow.Print.Preview = Yes")
this.trigger event ue_print()
end event

event ue_advanced;call super::ue_advanced;integer li, li_num
decimal li_id

CHOOSE CASE li_no
CASE 0
	String ls_recs
	ls_recs = ProfileString(is_formini,ls_form,"Recs","recs")
	openwithparm(w_ask,"Recommendations file/" + ls_recs)
	setprofileString(is_formini,ls_form,"Recs",message.stringparm)
	this.trigger event ue_reretrieve()
CASE ELSE
	FOR li = 1 to this.rowcount()
		li_id = this.object.topicid[li]
		li_num = integer(li_id)
		li_id -= li_num
		li_id = li_id / 10
		li_id = li_num + li_id
		this.object.topicid[li] = li_id
	NEXT
END CHOOSE
	
	
	
end event

type dw_help from uo_datawindow within w_forms_new
event ue_retrieve_help ( string ls_helpname )
boolean visible = false
integer x = 133
integer y = 120
integer width = 2533
integer height = 1488
integer taborder = 10
boolean titlebar = true
string title = "Help Items"
string dataobject = "dw_help_list"
boolean controlmenu = true
end type

event ue_retrieve_help(string ls_helpname);string ls_name
IF is_helpname = ls_helpname THEN RETURN
this.reset()
ls_name = set_ini("Location of Templates","MAIN","Templates","",FALSE)

IF FileExists(ls_name + "\" + ls_helpname + ".hlp" ) THEN
	ls_name += "\" + ls_helpname + ".hlp"
	is_helpname = ls_helpname
ELSE
	ls_name += "\" + ls_form + ".hlp"
	is_helpname = ls_form
END IF

dw_help.title = "Help Items " + ls_name

IF FileExists(ls_name) THEN
	uo_files uo_load
	uo_load = CREATE uo_files

	uo_load.trigger event load_file(ls_name,this)

	DESTROY uo_files
ELSE
	//Messagebox("Help FIle", ls_name + " not found")
END IF

Integer li
FOR li = 1 to dw_help.rowcount()
	IF Left(dw_help.object.topic[li],1) = "<" THEN
		//dw_defaultw.trigger event ue_setup_ddw(dw_help.object.topic[li])
	END IF
NEXT
		
this.sort()
end event

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_add.enabled = TRUE
lm_list.m_listview.m_delete.enabled = TRUE
lm_list.m_listview.m_retrieverecords.enabled = TRUE
lm_list.m_listview.m_importexport.visible = TRUE

end event

event ue_reretrieve;call super::ue_reretrieve;string ls_name
ls_name = set_ini("Location of Templates","MAIN","Templates","",FALSE)
ls_name += "\" + ls_form + ".hlp"
dw_help.title = "Help Items " + ls_name

IF FileExists(ls_name) THEN
	uo_files uo_load
	uo_load = CREATE uo_files

	uo_load.trigger event load_file(ls_name,this)

	DESTROY uo_files
ELSE
	//Messagebox("Help FIle", ls_name + " not found")
END IF

Integer li
FOR li = 1 to dw_help.rowcount()
	IF Left(dw_help.object.topic[li],1) = "<" THEN
		//dw_defaultw.trigger event ue_setup_ddw(dw_help.object.topic[li])
	END IF
NEXT
		
this.sort()
	
end event

event ue_commit;string ls_name
integer li_ret
ls_name = set_ini("Location of Templates","MAIN","Templates","",FALSE)
ls_name += "\" + ls_form + ".hlp"

uo_files uo_load
uo_load = CREATE uo_files

li_ret = uo_load.trigger event save_file(ls_name,this)

DESTROY uo_files

end event

event ue_update;this.trigger event ue_commit()
end event

type tab_main from tab within w_forms_new
integer x = 5
integer y = 40
integer width = 2779
integer height = 1676
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean multiline = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean showpicture = false
integer selectedtab = 1
end type

event rightclicked;IF index >= 1 THEN
	menu_form_sheet im_menu
	im_menu = create menu_form_sheet
	ii_id = u_to_open[index].ii_tab
	im_menu.m_listview.PopMenu(PointerX(), PointerY())
	destroy im_menu
END IF

end event

event selectionchanged;//integer li
IF oldindex > 0 THEN
//	li = ii_pages[oldindex]
	IF lb_photo THEN u_to_open[oldindex].dw_defaultw.trigger event ue_display_pictures(FALSE)
END IF
//li = ii_pages[newindex]
IF lb_photo THEN u_to_open[newindex].dw_defaultw.trigger event ue_display_pictures(TRUE)
end event

