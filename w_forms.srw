HA$PBExportHeader$w_forms.srw
forward
global type w_forms from window
end type
type dw_help from uo_datawindow within w_forms
end type
type dw_info from uo_datawindow within w_forms
end type
type ole_zip from olecustomcontrol within w_forms
end type
type st_status from statictext within w_forms
end type
type st_pages from statictext within w_forms
end type
type htb_zoom from htrackbar within w_forms
end type
type htb_pages from htrackbar within w_forms
end type
type st_2 from statictext within w_forms
end type
type dw_print from uo_datawindow within w_forms
end type
type dw_defaultw from uo_datawindow within w_forms
end type
type dw_page3 from uo_datawindow within w_forms
end type
type dw_page2 from uo_datawindow within w_forms
end type
type dw_page5 from uo_datawindow within w_forms
end type
type dw_page4 from uo_datawindow within w_forms
end type
end forward

global type w_forms from window
integer x = 96
integer y = 24
integer width = 3205
integer height = 4004
boolean titlebar = true
string title = "Untitled"
string menuname = "menu_form"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 12639424
event ue_zip ( )
dw_help dw_help
dw_info dw_info
ole_zip ole_zip
st_status st_status
st_pages st_pages
htb_zoom htb_zoom
htb_pages htb_pages
st_2 st_2
dw_print dw_print
dw_defaultw dw_defaultw
dw_page3 dw_page3
dw_page2 dw_page2
dw_page5 dw_page5
dw_page4 dw_page4
end type
global w_forms w_forms

type prototypes
FUNCTION long filesize(string f) LIBRARY "FUNCky32.DLL" alias for "filesize;Ansi"
end prototypes

type variables
string ls_filename, ls_form, ls_Library, ls_flibrary, ls_cdir
menu_form m_session
integer li_page = 1, li_total = 1
boolean lb_changed = FALSE, lb_ready
end variables

forward prototypes
public subroutine copy_picture (string ls_field, integer li_row, uo_datawindow ldw)
public function boolean validate_all ()
end prototypes

event ue_zip();Integer li_result, nErr
String ls_error
integer xvtError

ole_zip.object.ZipFilename = Left(ls_filename, len(ls_filename) - 3) + "mpz"
ole_zip.object.FilesToProcess = Left(ls_filename, len(ls_filename) - 3) + "*"
li_result = ole_zip.Object.Zip()

If li_result <> 0 Then 
	ls_error = ole_zip.object.GetErrorDescription(xvtError, li_result)
	Messagebox("Zip", "Unsuccessful Error#" + string(li_result) + "-" + ls_error)
Else 
	//Messagebox("Zip","File(s) successfully zipped.")
End If

end event

public subroutine copy_picture (string ls_field, integer li_row, uo_datawindow ldw);string ls_photo, ls_new
long ll_size
ll_size = long(ProfileString(gs_ini,"MAIN","PhotoSize","1000")) * 1000
ls_new = Left(ls_filename, len(ls_filename) - 4)
ls_new += "p" + Right(ls_field,len(ls_field) - 6) + string(li_row)
ls_photo = ldw.trigger event ue_copypicture("",ls_new)
IF filesize(ls_photo) > ll_size THEN
		Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
ELSE
	IF ls_photo <> "" THEN
		ldw.setitem(li_row,Right(ls_field,len(ls_field) -2),ls_photo)
	END IF
END IF
end subroutine

public function boolean validate_all ();Boolean lb_ok=TRUE
IF dw_defaultw.trigger event ue_validate(dw_defaultw,"Main Page") THEN
	lb_ok = FALSE
ELSE
	IF	dw_defaultw.trigger event ue_validate(dw_page2,"Page 2") THEN 
		lb_ok = FALSE
	ELSE
		IF	dw_defaultw.trigger event ue_validate(dw_page3,"Page 3") THEN 
			lb_ok = FALSE
		ELSE
			IF	dw_defaultw.trigger event ue_validate(dw_page4,"Page 4") THEN 
				lb_ok = FALSE
			ELSE
				IF	dw_defaultw.trigger event ue_validate(dw_page5,"Page 5") THEN 
					lb_ok = FALSE
				END IF
			END IF
		END IF
	END IF
END IF

RETURN lb_ok

end function

on w_forms.create
if this.MenuName = "menu_form" then this.MenuID = create menu_form
this.dw_help=create dw_help
this.dw_info=create dw_info
this.ole_zip=create ole_zip
this.st_status=create st_status
this.st_pages=create st_pages
this.htb_zoom=create htb_zoom
this.htb_pages=create htb_pages
this.st_2=create st_2
this.dw_print=create dw_print
this.dw_defaultw=create dw_defaultw
this.dw_page3=create dw_page3
this.dw_page2=create dw_page2
this.dw_page5=create dw_page5
this.dw_page4=create dw_page4
this.Control[]={this.dw_help,&
this.dw_info,&
this.ole_zip,&
this.st_status,&
this.st_pages,&
this.htb_zoom,&
this.htb_pages,&
this.st_2,&
this.dw_print,&
this.dw_defaultw,&
this.dw_page3,&
this.dw_page2,&
this.dw_page5,&
this.dw_page4}
end on

on w_forms.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_help)
destroy(this.dw_info)
destroy(this.ole_zip)
destroy(this.st_status)
destroy(this.st_pages)
destroy(this.htb_zoom)
destroy(this.htb_pages)
destroy(this.st_2)
destroy(this.dw_print)
destroy(this.dw_defaultw)
destroy(this.dw_page3)
destroy(this.dw_page2)
destroy(this.dw_page5)
destroy(this.dw_page4)
end on

event resize;dw_defaultw.height = (this.height - dw_defaultw.y) - 250
dw_defaultw.width = (this.width - dw_defaultw.x) - 50
dw_page2.height = (this.height - dw_defaultw.y) - 250
dw_page2.width = (this.width - dw_defaultw.x) - 50
dw_page3.height = (this.height - dw_defaultw.y) - 250
dw_page3.width = (this.width - dw_defaultw.x) - 50
dw_page4.height = (this.height - dw_defaultw.y) - 250
dw_page4.width = (this.width - dw_defaultw.x) - 50
dw_page5.height = (this.height - dw_defaultw.y) - 250
dw_page5.width = (this.width - dw_defaultw.x) - 50
dw_print.height = (this.height - dw_print.y) - 250
dw_print.width = (this.width - dw_print.x) - 50

end event

event open;this.title = ls_form + "!" + ls_filename
dw_help.trigger event ue_reretrieve()
IF ProfileString(gs_ini,"MAIN","SpellCheck","FALSE") = "TRUE" THEN
	menu_form.m_options.m_mode-spellcheck.checked = TRUE
END IF

end event

event activate;m_session = this.menuid
m_session.w_parent = this
end event

event closequery;IF lb_changed THEN
	CHOOSE CASE Messagebox("Form Modified","Changes are not saved.  Do you wish to save changes?", &
		Question!, YesNoCancel!,3)
	CASE 1
		dw_defaultw.trigger event ue_update()
	CASE 3
		RETURN 1
	END CHOOSE
END IF
RETURN 0

end event

type dw_help from uo_datawindow within w_forms
boolean visible = false
integer x = 27
integer y = 332
integer width = 2533
integer height = 1488
integer taborder = 50
boolean titlebar = true
string title = "Help Items"
string dataobject = "dw_help_list"
boolean controlmenu = true
end type

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_add.enabled = TRUE
lm_list.m_listview.m_delete.enabled = TRUE
lm_list.m_listview.m_retrieverecords.enabled = TRUE
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
		dw_defaultw.trigger event ue_setup_ddw(dw_help.object.topic[li])
	END IF
NEXT
		
	
end event

type dw_info from uo_datawindow within w_forms
boolean visible = false
integer x = 59
integer y = 328
integer width = 2345
integer height = 1272
integer taborder = 40
boolean titlebar = true
string dataobject = "dw_datawindow_info"
boolean controlmenu = true
end type

type ole_zip from olecustomcontrol within w_forms
event listingfile ( string sfilename,  string scomment,  long lsize,  long lcompressedsize,  integer ncompressionratio,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted,  long ldisknumber,  boolean bexcluded,  integer xreason )
event previewingfile ( string sfilename,  string ssourcefilename,  long lsize,  integer xattributes,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  boolean bexcluded,  integer xreason )
event insertdisk ( long ldisknumber,  ref boolean bdiskinserted )
event zippreprocessingfile ( ref string sfilename,  ref string scomment,  string ssourcefilename,  long lsize,  ref integer xattributes,  ref datetime dtlastmodified,  ref datetime dtlastaccessed,  ref datetime dtcreated,  ref integer xmethod,  ref boolean bencrypted,  ref string spassword,  ref boolean bexcluded,  integer xreason,  boolean bexisting )
event unzippreprocessingfile ( string sfilename,  string scomment,  ref string sdestfilename,  long lsize,  long lcompressedsize,  ref integer xattributes,  long lcrc,  ref datetime dtlastmodified,  ref datetime dtlastaccessed,  ref datetime dtcreated,  integer xmethod,  boolean bencrypted,  ref string spassword,  long ldisknumber,  ref boolean bexcluded,  integer xreason,  boolean bexisting,  ref integer xdestination )
event skippingfile ( string sfilename,  string scomment,  string sfilenameondisk,  long lsize,  long lcompressedsize,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted,  integer xreason )
event removingfile ( string sfilename,  string scomment,  long lsize,  long lcompressedsize,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted )
event testingfile ( string sfilename,  string scomment,  long lsize,  long lcompressedsize,  integer ncompressionratio,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted,  long ldisknumber )
event filestatus ( string sfilename,  long lsize,  long lcompressedsize,  long lbytesprocessed,  integer nbytespercent,  integer ncompressionratio,  boolean bfilecompleted )
event globalstatus ( long lfilestotal,  long lfilesprocessed,  long lfilesskipped,  integer nfilespercent,  long lbytestotal,  long lbytesprocessed,  long lbytesskipped,  integer nbytespercent,  long lbytesoutput,  integer ncompressionratio )
event disknotempty ( ref integer xaction )
event processcompleted ( long lfilestotal,  long lfilesprocessed,  long lfilesskipped,  long lbytestotal,  long lbytesprocessed,  long lbytesskipped,  long lbytesoutput,  integer ncompressionratio,  integer xresult )
event zipcomment ( ref string scomment )
event querymemoryfile ( ref long lusertag,  ref string sfilename,  ref string scomment,  ref integer xattributes,  ref datetime dtlastmodified,  ref datetime dtlastaccessed,  ref datetime dtcreated,  ref boolean bencrypted,  ref string spassword,  ref boolean bfileprovided )
event zippingmemoryfile ( long lusertag,  string sfilename,  ref any vadatatocompress,  ref boolean bendofdata )
event unzippingmemoryfile ( string sfilename,  any vauncompresseddata,  boolean bendofdata )
event warning ( string sfilename,  integer xwarning )
event invalidpassword ( string sfilename,  ref string snewpassword,  ref boolean bretry )
event replacingfile ( string sfilename,  string scomment,  long lsize,  integer xattributes,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  string sorigfilename,  long lorigsize,  integer xorigattributes,  datetime dtoriglastmodified,  datetime dtoriglastaccessed,  datetime dtorigcreated,  ref boolean breplacefile )
event zipcontentsstatus ( long lfilestotal,  long lfilesread,  integer nfilespercent )
event deletingfile ( string sfilename,  long lsize,  integer xattributes,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  ref boolean bdonotdelete )
event convertpreprocessingfile ( string sfilename,  ref string scomment,  ref string sdestfilename,  long lsize,  long lcompressedsize,  ref integer xattributes,  long lcrc,  ref datetime dtlastmodified,  ref datetime dtlastaccessed,  ref datetime dtcreated,  integer xmethod,  boolean bencrypted,  long ldisknumber,  ref boolean bexcluded,  integer xreason,  boolean bexisting )
event listingfile64 ( string sfilename,  string scomment,  long lsizelow,  long lsizehigh,  long lcompressedsizelow,  long lcompressedsizehigh,  integer ncompressionratio,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted,  long ldisknumber,  boolean bexcluded,  integer xreason )
event previewingfile64 ( string sfilename,  string ssourcefilename,  long lsizelow,  long lsizehigh,  integer xattributes,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  boolean bexcluded,  integer xreason )
event zippreprocessingfile64 ( ref string sfilename,  ref string scomment,  string ssourcefilename,  long lsizelow,  long lsizehigh,  ref integer xattributes,  ref datetime dtlastmodified,  ref datetime dtlastaccessed,  ref datetime dtcreated,  ref integer xmethod,  ref boolean bencrypted,  ref string spassword,  ref boolean bexcluded,  integer xreason,  boolean bexisting )
event unzippreprocessingfile64 ( string sfilename,  string scomment,  ref string sdestfilename,  long lsizelow,  long lsizehigh,  long lcompressedsizelow,  long lcompressedsizehigh,  ref integer xattributes,  long lcrc,  ref datetime dtlastmodified,  ref datetime dtlastaccessed,  ref datetime dtcreated,  integer xmethod,  boolean bencrypted,  ref string spassword,  long ldisknumber,  ref boolean bexcluded,  integer xreason,  boolean bexisting,  ref integer xdestination )
event skippingfile64 ( string sfilename,  string scomment,  string sfilenameondisk,  long lsizelow,  long lsizehigh,  long lcompressedsizelow,  long lcompressedsizehigh,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted,  integer xreason )
event removingfile64 ( string sfilename,  string scomment,  long lsizelow,  long lsizehigh,  long lcompressedsizelow,  long lcompressedsizehigh,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted )
event testingfile64 ( string sfilename,  string scomment,  long lsizelow,  long lsizehigh,  long lcompressedsizelow,  long lcompressedsizehigh,  integer ncompressionratio,  integer xattributes,  long lcrc,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  integer xmethod,  boolean bencrypted,  long ldisknumber )
event filestatus64 ( string sfilename,  long lsizelow,  long lsizehigh,  long lcompressedsizelow,  long lcompressedsizehigh,  long lbytesprocessedlow,  long lbytesprocessedhigh,  integer nbytespercent,  integer ncompressionratio,  boolean bfilecompleted )
event globalstatus64 ( long lfilestotal,  long lfilesprocessed,  long lfilesskipped,  integer nfilespercent,  long lbytestotallow,  long lbytestotalhigh,  long lbytesprocessedlow,  long lbytesprocessedhigh,  long lbytesskippedlow,  long lbytesskippedhigh,  integer nbytespercent,  long lbytesoutputlow,  long lbytesoutputhigh,  integer ncompressionratio )
event processcompleted64 ( long lfilestotal,  long lfilesprocessed,  long lfilesskipped,  long lbytestotallow,  long lbytestotalhigh,  long lbytesprocessedlow,  long lbytesprocessedhigh,  long lbytesskippedlow,  long lbytesskippedhigh,  long lbytesoutputlow,  long lbytesoutputhigh,  integer ncompressionratio,  integer xresult )
event replacingfile64 ( string sfilename,  string scomment,  long lsizelow,  long lsizehigh,  integer xattributes,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  string sorigfilename,  long lorigsizelow,  long lorigsizehigh,  integer xorigattributes,  datetime dtoriglastmodified,  datetime dtoriglastaccessed,  datetime dtorigcreated,  ref boolean breplacefile )
event deletingfile64 ( string sfilename,  long lsizelow,  long lsizehigh,  integer xattributes,  datetime dtlastmodified,  datetime dtlastaccessed,  datetime dtcreated,  ref boolean bdonotdelete )
event convertpreprocessingfile64 ( string sfilename,  ref string scomment,  ref string sdestfilename,  long lsizelow,  long lsizehigh,  long lcompressedsizelow,  long lcompressedsizehigh,  ref integer xattributes,  long lcrc,  ref datetime dtlastmodified,  ref datetime dtlastaccessed,  ref datetime dtcreated,  integer xmethod,  boolean bencrypted,  long ldisknumber,  ref boolean bexcluded,  integer xreason,  boolean bexisting )
event writingzipcontentsstatus ( integer nfilespercent )
event movingtempfilestatus ( integer nbytespercent )
boolean visible = false
integer x = 2665
integer y = 164
integer width = 146
integer height = 128
integer taborder = 30
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_forms.win"
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type st_status from statictext within w_forms
integer x = 1627
integer y = 32
integer width = 1170
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12639424
alignment alignment = center!
boolean focusrectangle = false
end type

type st_pages from statictext within w_forms
boolean visible = false
integer x = 1065
integer width = 206
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pages:"
alignment alignment = center!
boolean focusrectangle = false
end type

type htb_zoom from htrackbar within w_forms
integer x = 233
integer width = 453
integer height = 112
integer maxposition = 100
integer position = 100
integer tickfrequency = 10
htickmarks tickmarks = hticksontop!
end type

event moved;IF dw_defaultw.visible THEN dw_defaultw.trigger event ue_zoom(scrollpos)
IF dw_page2.visible THEN dw_page2.trigger event ue_zoom(scrollpos)
IF dw_page3.visible THEN dw_page3.trigger event ue_zoom(scrollpos)
IF dw_page4.visible THEN dw_page4.trigger event ue_zoom(scrollpos)
IF dw_page5.visible THEN dw_page5.trigger event ue_zoom(scrollpos)

end event

type htb_pages from htrackbar within w_forms
boolean visible = false
integer x = 1266
integer width = 315
integer height = 112
integer minposition = 1
integer maxposition = 10
integer tickfrequency = 1
htickmarks tickmarks = hticksontop!
end type

event moved;//IF scrollpos <> li_page THEN
	//IF li_total > 1 THEN dw_defaultw.trigger event ue_export_mpf(TRUE)
	//li_page = scrollpos
	//IF scrollpos > 1 THEN
		//dw_defaultw.trigger event ue_load_form(ls_form + string(scrollpos))
	//ELSE
		//dw_defaultw.trigger event ue_load_form(ls_form)
	//END IF
	CHOOSE CASE scrollpos
	CASE 1
		dw_defaultw.visible = TRUE
		dw_page2.visible = FALSE
		dw_page3.visible = FALSE
		dw_page4.visible = FALSE
		dw_page5.visible = FALSE
	CASE 2
		dw_defaultw.visible = FALSE
		dw_page2.visible = TRUE
		dw_page3.visible = FALSE
		dw_page4.visible = FALSE
		dw_page5.visible = FALSE
	CASE 3
		dw_defaultw.visible = FALSE
		dw_page2.visible = FALSE
		dw_page3.visible = TRUE
		dw_page4.visible = FALSE
		dw_page5.visible = FALSE
	CASE 4
		dw_defaultw.visible = FALSE
		dw_page2.visible = FALSE
		dw_page3.visible = FALSE
		dw_page4.visible = TRUE
		dw_page5.visible = FALSE
	CASE 5
		dw_defaultw.visible = FALSE
		dw_page2.visible = FALSE
		dw_page3.visible = FALSE
		dw_page4.visible = FALSE
		dw_page5.visible = TRUE
	CASE ELSE
		Messagebox("Scroll","Page cannot load")
	END CHOOSE
//END IF

end event

type st_2 from statictext within w_forms
integer x = 32
integer width = 206
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Zoom:"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_print from uo_datawindow within w_forms
event ue_load_form ( string ls_formname )
boolean visible = false
integer x = 165
integer y = 100
integer width = 2478
integer height = 1680
integer taborder = 20
boolean titlebar = true
string title = "Preview"
boolean controlmenu = true
boolean resizable = true
end type

event ue_load_form(string ls_formname);string pwsyntax, ErrorBuffer, dwsyntax, ls_name, ls_error = "",ls_return
integer rtncode, li, li_col, lx

dwsyntax = LibraryExport(ls_library, "dw_" + ls_formname, ExportDataWindow!)
pwsyntax = LibraryExport(ls_library, "pw_" + ls_formname, ExportDataWindow!)
IF ISNULL(pwsyntax) or pwsyntax = "" THEN pwsyntax = dwsyntax
IF ISNULL(pwsyntax) OR pwsyntax = "" THEN
	Messagebox("Form","Error loading " + ls_library  + " Form:pw_" + ls_form)
ELSE		
	rtncode = this.create(pwsyntax,ErrorBuffer)
	IF rtncode = 1 THEN
		this.insertrow(0)
		FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
			ls_name = this.Describe("#" + string(li) + ".Name")
			li_col = dw_defaultw.trigger event ue_check_field(dw_defaultw,ls_name)
			IF li_col > 0 THEN
				this.setitem(1,li,dw_defaultw.object.data[1,li_col])
			ELSE
				li_col = dw_defaultw.trigger event ue_check_field(dw_page2,ls_name)
				IF li_col > 0 THEN
					FOR lx = 1 to dw_page2.rowcount()
						IF lx > this.rowcount() THEN this.insertrow(0)
						this.setitem(lx,li,dw_page2.object.data[lx,li_col])
					NEXT
				ELSE
					li_col = dw_defaultw.trigger event ue_check_field(dw_page3,ls_name)
					IF li_col > 0 THEN
						FOR lx = 1 to dw_page3.rowcount()
							IF lx > this.rowcount() THEN this.insertrow(0)
							this.setitem(lx,li,dw_page3.object.data[lx,li_col])
						NEXT
					ELSE
						ls_error += "~r" + ls_name
					END IF
					li_col = dw_defaultw.trigger event ue_check_field(dw_page4,ls_name)
					IF li_col > 0 THEN
						FOR lx = 1 to dw_page4.rowcount()
							IF lx > this.rowcount() THEN this.insertrow(0)
							this.setitem(lx,li,dw_page4.object.data[lx,li_col])
						NEXT
					ELSE
						ls_error += "~r" + ls_name
					END IF
				END IF
			END IF
		NEXT
		this.GroupCalc()
	ELSE
		Messagebox("Form","Error loading " + ls_library  + "-pw_" + ls_form)
	END IF
END IF

IF ls_error <> "" THEN
	IF ProfileString(gs_ini,"Utilities","FormError","NO") = "YES" THEN
		Messagebox("Form","Error retrieving the following fields: " + ls_error)
	END IF
END IF
end event

type dw_defaultw from uo_datawindow within w_forms
event ue_values ( )
event ue_import_mpf ( )
event ue_export_mpf ( boolean lb_replace )
event type integer ue_check_field ( datawindow ldw,  string ls_field )
event type integer get_page_count ( string ls_type )
event ue_load_form ( string ls_formname )
event ue_zip ( )
event ue_form_error ( )
event ue_setitem ( datawindow ldw,  string ls_field,  string ls_item,  string ls_ctype,  integer li_row )
event ue_correct_form ( )
event ue_display_pictures ( boolean lb_show )
event type integer ue_print_pdf ( ref n_cst_printer adobe_reader,  string ls_pdfname,  string ls_pages )
event ue_set_page ( datawindow ldw )
event type boolean ue_validate ( datawindow ld_valid,  string ls_pagename )
event ue_setup_ddw ( string ls_field )
event ue_setup_helplist ( string ls_field )
integer x = 23
integer y = 132
integer width = 2592
integer height = 1732
integer taborder = 10
end type

event ue_values;Messagebox("Values","Library:  " + ls_library + "~r~nFlibrary:  " + ls_flibrary)

end event

event ue_import_mpf();integer li_file, li_length, lpos,rpos, li, rowpos
string ls_record, ls_item = "", ls_field, ls_ctype, ls_mpftype
boolean lb_continue = TRUE, lb_validate

this.insertrow(0)
ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + "mpf"
//IF li_total > 1 THEN
//	IF FileExists(Left(ls_filename,len(ls_filename) - 3) + string(li_page)) THEN
//		ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + string(li_page)
//	END IF
//END IF

st_status.text = "Opening " + ls_mpftype
ls_cdir = get_pathname(ls_mpftype)
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
		IF ls_ctype = "char(32766)" THEN
			FOR li = lpos + 1 to len(ls_record)
				CHOOSE CASE mid(ls_record,li,1)
					CASE "|"
						ls_item += "~r~n"
					CASE ELSE
						ls_item += mid(ls_record,li,1)
				END CHOOSE
			NEXT
		ELSE
			ls_item += Mid(ls_record, lpos + 1, len(ls_record) - lpos) 
		END IF			
	END IF
	IF Right(ls_item,1) = "~~" THEN
		ls_item = Left(ls_item,len(ls_item) - 1)
		rowpos = pos(ls_field,"@")
		IF rowpos > 0 THEN
			CHOOSE CASE Left(ls_field,5)
			CASE "form2"
				this.trigger event ue_setitem(dw_page2,Mid(ls_field,7,rowpos - 7),ls_item,ls_ctype,&
					integer(right(ls_field,len(ls_field) - rowpos)))
			CASE "form3"
				this.trigger event ue_setitem(dw_page3,Mid(ls_field,7,rowpos - 7),ls_item,ls_ctype,&
					integer(right(ls_field,len(ls_field) - rowpos)))
			CASE "form4"
				this.trigger event ue_setitem(dw_page4,Mid(ls_field,7,rowpos - 7),ls_item,ls_ctype,&
					integer(right(ls_field,len(ls_field) - rowpos)))
			END CHOOSE
		ELSE
			this.trigger event ue_setitem(this,ls_field,ls_item,ls_ctype,1)
		END IF
		lb_continue = TRUE
	ELSE
		lb_continue = FALSE
	END IF
	li_length = FileRead(li_file,ls_record)
LOOP
IF ls_record = "~~" THEN
	IF UPPER(Left(ls_ctype,4)) = "CHAR" THEN
		this.setitem(1,ls_field,ls_item)
	END IF
END IF
FileClose(li_file)
st_status.text = ls_mpftype
iF lb_validate THEN validate_all()
IF Right(ls_filename,3) = "XML" THEN
	FileDelete(ls_mpftype)
END IF
	

end event

event ue_export_mpf(boolean lb_replace);integer li_file, li_length, li, lx
string ls_record, ls_item, ls_field, ls_ctype, ls_memo, ls_mpftype, ls_problem
boolean lb_save = TRUE

IF NOT validate_all() THEN 
	ls_problem = "!"
ELSE
	ls_problem = ""
END IF

//IF li_total > 1 THEN
	//ls_mpftype = Left(ls_filename,len(ls_filename) - 3) + string(li_page)
//ELSE
	ls_mpftype = ls_filename
//END IF

st_status.text = "Saving " + ls_mpftype 

IF lb_replace THEN
	li_file = FileOpen(ls_mpftype,LineMode!,Write!,LockReadWrite!,Replace!)
ELSE
	li_file = FileOpen(ls_filename,LineMode!,Write!,LockReadWrite!,Replace!)
END IF

FileWrite(li_file,ls_problem)
FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_ctype = this.Describe("#" + string(li) + ".ColType")
	CHOOSE CASE UPPER(Left(ls_ctype,4))
		CASE "DATE"
			ls_item = string(this.object.data[1,li],"mm/dd/yy")
		CASE "CHAR"
			IF left(ls_field,6) = "photo_" THEN
				ls_item = get_filename(string(this.object.data[1,li]))
			ELSE
				ls_item = string(this.object.data[1,li])
			END IF
		CASE ELSE
			ls_item = string(this.object.data[1,li])
	END CHOOSE
	IF ls_ctype = "char(32766)" THEN
		ls_memo = ""
		FOR lx = 1 to len(ls_item)
			CHOOSE CASE asc(mid(ls_item,lx,1))
			   CASE 10
				CASE 12,13
					ls_memo += "|"
				CASE ELSE
					ls_memo += mid(ls_item,lx,1)
			END CHOOSE
		NEXT
		ls_item = ls_memo
	END IF
	IF FileWrite(li_file,ls_ctype + "<" + ls_field + ">" + ls_item + "~~") < 0 THEN
		lb_save = FALSE
		Messagebox("FileWrite","Error writing " + ls_field)
	END IF
NEXT

IF lb_save THEN
	uo_files uo_load
	uo_load = CREATE uo_files
	st_status.text = "Saving form 2 " + ls_mpftype
	uo_load.trigger event save_dw(dw_page2,li_file,"form2",TRUE)
	st_status.text = "Saving form 3 " + ls_mpftype
	uo_load.trigger event save_dw(dw_page3,li_file,"form3",TRUE)
	st_status.text = "Saving form 4 " + ls_mpftype
	uo_load.trigger event save_dw(dw_page4,li_file,"form4",TRUE)
	st_status.text = "Saving form 5 " + ls_mpftype
	uo_load.trigger event save_dw(dw_page5,li_file,"form5",TRUE)
	DESTROY uo_files	
END IF
FileClose(li_file)

IF lb_save THEN
	urows = 1
	trows = 0
	this.ResetUpdate()
	IF NOT lb_replace THEN
		IF li_total > 1 THEN	FileDelete(ls_mpftype)
	END IF
END IF


st_status.text = "Complete " + ls_mpftype

IF ProfileString(gs_ini,"Utilities","FormInfo","") = "YES" THEN
	this.trigger event ue_form_error()
END IF


end event

event type integer ue_check_field(datawindow ldw, string ls_field);string ls_bfield
integer li, li_found, li_count

IF ls_field = "?" THEN 
	Messagebox("Field Error","Problem loading field")
	RETURN 0
END IF
IF ldw.rowcount() = 0 THEN RETURN 0
FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
	ls_bfield = ldw.Describe("#" + string(li) + ".Name")
	IF ls_field = ls_bfield THEN li_found = li
NEXT
RETURN li_found
end event

event type integer get_page_count(string ls_type);Boolean lb_done = FALSE
integer li_count = 1
string dwsyntax
DO UNTIL lb_done
	li_count += 1
	dwsyntax = LibraryExport(ls_library, &
		ls_type + "_" + ls_form + string(li_count), ExportDataWindow!)
	IF ISNULL(dwsyntax) OR dwsyntax = "" THEN lb_done = TRUE
LOOP
//em_pages.MinMax = ("1 ~~ " + string(li_count - 1))
IF ls_type = "dw" THEN
	IF li_count > 2 THEN
		htb_pages.MaxPosition = li_count - 1
		htb_pages.visible = TRUE
		st_pages.visible = TRUE
	END IF
END IF
RETURN li_count - 1

end event

event ue_load_form(string ls_formname);string dwsyntax, ErrorBuffer, ls_message
integer rtncode

dwsyntax = LibraryExport(ls_library, "dw_" + ls_formname, ExportDataWindow!)

IF ISNULL(dwsyntax) OR dwsyntax = "" THEN
	ls_flibrary = set_ini("Form Library Name",ls_formname,"Form",ls_formname,TRUE)
	//Messagebox("Form","Error loading " + ls_library  + " Form:dw_" + ls_form)
ELSE	
	//ls_message = setup_print_returns(dwsyntax)
	//print_error(ls_message)
	rtncode = this.create(dwsyntax,ErrorBuffer)
	//this.trigger event ue_correct_form()
	Boolean lb_done
	Integer li_count = 1
	DO UNTIL lb_done
		li_count += 1
		dwsyntax = LibraryExport(ls_library, "dw_" + ls_formname + string(li_count), ExportDataWindow!)
		IF ISNULL(dwsyntax) OR dwsyntax = "" THEN 
			lb_done = TRUE
		ELSE
			CHOOSE CASE li_count
			CASE 2
				rtncode = dw_page2.create(dwsyntax,ErrorBuffer)
				dw_page2.insertrow(0)
			CASE 3
				rtncode = dw_page3.create(dwsyntax,ErrorBuffer)
				dw_page3.insertrow(0)
			CASE 4
				rtncode = dw_page4.create(dwsyntax,ErrorBuffer)
				dw_page4.insertrow(0)
			CASE 5
				rtncode = dw_page5.create(dwsyntax,ErrorBuffer)
				dw_page5.insertrow(0)
			CASE ELSE
				Messagebox("Load Form", string(li_count) + " form not found")
			END CHOOSE
		END IF		
	LOOP

	IF rtncode = 1 THEN
		IF FileExists(ls_filename) THEN
			CHOOSE CASE UPPER(Right(ls_filename,3))
				CASE "MPF"
					this.trigger event ue_import_mpf()
				CASE ELSE
					this.importfile(ls_filename)
			END CHOOSE
		ELSE
			CHOOSE CASE UPPER(Right(ls_filename,3))
				CASE "XML"
					this.trigger event ue_import_mpf()
				CASE ELSE
					this.trigger event ue_addnew()
			END CHOOSE
		END IF
	ELSE
		Messagebox("Form","Error loading " + ls_library  + "-dw" + ls_form)
	END IF
	this.trigger event ue_zoom(100)
END IF


end event

event ue_zip();Openwithparm(w_simplezip,Left(ls_filename, len(ls_filename) - 3) + "mpz")
w_simplezip.lb_list.additem(ls_filename)
w_simplezip.zipfile(FALSE,TRUE)
Close(w_simplezip)
//IF w_simplezip.unzipfile(FALSE,FALSE) THEN 
//	IF w_simplezip.lb_list.totalitems() = 1 THEN
//		ls_afile = w_simplezip.lb_list.text(1)
//		Close(w_simplezip)
//	END IF
//END IF
end event

event ue_form_error();integer li_file, li_length, li, lx, li_count = 0
string ls_record, ls_item, ls_field, ls_ctype, ls_memo, ls_mpftype, ls_dtype, ls_error, ls_bfield
string ls_name

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

event ue_setitem(datawindow ldw, string ls_field, string ls_item, string ls_ctype, integer li_row);IF this.trigger event ue_check_field(ldw,ls_field) > 0 THEN
	IF li_row > ldw.rowcount() THEN ldw.insertrow(0)
	CHOOSE CASE UPPER(Left(ls_ctype,4))
	CASE "CHAR"
		IF left(ls_field,6) = "photo_" THEN
			ls_item = ls_cdir + ls_item
			IF NOT FileExists(ls_item) THEN
				Messagebox("Photo","Warning-file not found " + ls_item)
			ELSE
				ldw.setitem(li_row,ls_field,ls_item)
			END IF
		ELSE
			ldw.setitem(li_row,ls_field,ls_item)
		END IF
	CASE "DECI"
		ldw.setitem(li_row,ls_field,dec(ls_item))
	CASE "NUMB"
		ldw.setitem(li_row,ls_field,long(ls_item))
	CASE "DATE"
		ldw.setitem(li_row,ls_field,date(ls_item))
	CASE ELSE
		Messagebox("Form","Can not load type " + ls_ctype)
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
LibraryImport(ls_library, "test", ImportDataWindow!, &
	dwsyntax, ErrorBuffer)


end event

event ue_display_pictures(boolean lb_show);Integer lx
String ls_field, ls_answer
IF lb_show THEN
	ls_answer = "Yes"
ELSE
	ls_answer = "No"
END IF
FOR lx = 1 to Integer(dw_page2.Object.Datawindow.Column.Count)
	ls_field = dw_page2.Describe("#" + string(lx) + ".Name")
	IF Left(ls_field,6) = "photo_" THEN
		dw_page2.Modify(ls_field + ".BitMapName = " + ls_answer)
	END IF
NEXT

FOR lx = 1 to Integer(dw_page3.Object.Datawindow.Column.Count)
	ls_field = dw_page3.Describe("#" + string(lx) + ".Name")
	IF Left(ls_field,6) = "photo_" THEN
		dw_page3.Modify(ls_field + ".BitMapName = " + ls_answer)
	END IF
NEXT

FOR lx = 1 to Integer(dw_page4.Object.Datawindow.Column.Count)
	ls_field = dw_page4.Describe("#" + string(lx) + ".Name")
	IF Left(ls_field,6) = "photo_" THEN
		dw_page4.Modify(ls_field + ".BitMapName = " + ls_answer)
	END IF
NEXT

end event

event type integer ue_print_pdf(ref n_cst_printer adobe_reader, string ls_pdfname, string ls_pages);//this.trigger event ue_zoom(100)
//IF li_total = 1 THEN
//	IF this.rowcount() > 0 THEN
//		IF printsetup() = 1 THEN dw_print.print()
//	ELSE
//		Messagebox("Print","No records to print")
//	END IF
//ELSE
Boolean lb_combine = FALSE

	IF ls_pdfname = "" THEN
		lb_combine = TRUE
		ls_pdfname = Left(ls_filename,len(ls_filename) - 4)
	ELSE
		w_forms.visible = FALSE		
	END IF
	integer li_count, li_start
	li_count = this.trigger event get_page_count("pw")
	//openwithparm(w_ask,"Print Page (" + string(li_count) + ")/ALL")
	CHOOSE CASE ls_pages
	CASE "ALL"
		li_start = 1
	CASE ELSE
		IF integer(message.stringparm) > 0 THEN
			IF integer(message.stringparm) <= li_count THEN
				li_start = integer(message.stringparm)
				li_count = li_start
			ELSE
				RETURN 0
			END IF
		ELSE
			RETURN 0
		END IF
	END CHOOSE
	//printsetup()
	long ll_job
	//ll_job = PrintOpen("Form " + ls_filename)
	FOR li_page = li_start to li_count
		st_status.text = "Printing " + string(li_page) + " of " + string(li_count)
		IF li_page = 1 THEN
			dw_print.trigger event ue_load_form(ls_form)
		ELSE
			dw_print.trigger event ue_load_form(ls_form + string(li_page))
		END IF			
		IF dw_print.rowcount() > 0 THEN
			adobe_reader.of_print2pdf(dw_print,ls_pdfname + string(li_page) + ".pdf")
			adobe_reader.ue_addfile(ls_pdfname + string(li_page) + ".pdf",TRUE)
			//dw_print.Print(FALSE)
		END IF
		//PrintDataWIndow(ll_job,dw_print)
	NEXT
	//PrintClose(ll_job)
IF lb_combine THEN 
	adobe_reader.ue_combine_pdf(ls_pdfname + ".pdf")
	st_status.text = "Printing Complete"
ELSE
	close(w_forms)
END IF
RETURN li_count
//END IF
end event

event ue_set_page(datawindow ldw);integer li_num
decimal ld_page
li_num = this.trigger event ue_check_field(ldw,"li_page")

IF li_num > 0 THEN
	IF ldw.rowcount() > 1 THEN
		ld_page = Dec(ldw.object.data[ldw.rowcount() -1, li_num])
		ldw.setitem(ldw.rowcount(),li_num,ld_page + .01)
	END IF
END IF
	

end event

event type boolean ue_validate(datawindow ld_valid, string ls_pagename);Integer li
String setting, ls_field
Boolean lb_found = FALSE
IF ld_valid.rowcount() = 0 THEN RETURN FALSE
FOR li = 1 to Integer(ld_valid.Object.DataWindow.Column.Count)
	ls_field = ld_valid.Describe("#" + string(li) + ".Name")
	setting = ld_valid.Describe(ls_field + ".Tag")
	IF pos(setting,"X") > 0 THEN
		IF ISNULL(this.object.data[1,li]) THEN 
			ld_valid.Modify(ls_field + ".Color=255")
			IF NOT lb_found THEN lb_found = TRUE
		ELSE
			ld_valid.Modify(ls_field + ".Color=0")
		END IF
	END IF
NEXT

IF lb_found THEN 
	Messagebox("Form is not complete","Required fields on " + ls_pagename + " not found." + &
		"  Missing items are in red.")
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

FOR li = 1 to dw_help.rowcount()
	IF dw_help.object.topic[li] = ls_field THEN
		ls_options = dw_help.object.description[li]
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

event ue_setup_helplist(string ls_field);integer li, rtncode, lx
long ll_customer
String ls_type, ls_options, ls_item = ""


ls_type = Mid(ls_field,2,len(ls_field) -2)

FOR li = 1 to dw_help.rowcount()
	IF dw_help.object.topic[li] = ls_field THEN
		ls_options = dw_help.object.description[li]
		openwithparm(w_list_ddw,ls_options)
	END IF
NEXT


end event

event ue_retrieve;call super::ue_retrieve;integer lpos, rpos
string ls_name
boolean lb_pdf

ls_name = message.stringparm
lb_ready = FALSE


lpos = pos(ls_name,"_")
rpos = pos(ls_name,"-",lpos)
IF rpos > 0 THEN
	rpos = rpos - lpos - 1
ELSE
	rpos = len(ls_name) - lpos - 4
END IF
ls_form = Mid(ls_name,lpos + 1, rpos)
ls_filename = ls_name

//dwsyntax = this.Describe("DataWindow.Syntax")
ls_library = set_ini("Location of Templates","MAIN","Templates","",FALSE)
IF Left(ls_library,1) <> "\" THEN ls_library += "\"
//ls_library += "dw" + ls_form + ".srd"

ls_flibrary = ProfileString(gs_ini,ls_form,"Form","")
IF ls_flibrary = "" THEN
	ls_flibrary = set_ini("Location of Form Library","MAIN","Form","",FALSE)
END IF
ls_library += ls_flibrary

IF FileExists(ls_library) THEN
	li_total = this.trigger event get_page_count("dw")	
	this.trigger event ue_load_form(ls_form)
	this.ResetUpdate()
ELSE
	Messagebox("Forms", "File " + ls_library + " does not exist.")
END IF

lb_ready = TRUE
//rtncode = LibraryImport(ls_library, "dw" + ls_form + ".srd", ImportDataWindow!, &
//	dwsyntax, ErrorBuffer )



end event

event ue_update;this.accepttext()
String ls_file
ls_file = Left(ls_filename,len(ls_filename) - 4)
CHOOSE CASE UPPER(Right(ls_filename,3))
	CASE "DBF"
		IF this.trigger event ue_exportfile(ls_file,"DBASE") = 1 THEN
			urows = 1
			trows = 0
			this.ResetUpdate()
		ELSE
			IF dbrows > 0 THEN
				urows = 1
				trows = 0
			ELSE
				urows = -1
			END IF
		END IF
		ls_file = ls_file + ".dbf"
	CASE "XML"
		IF this.trigger event ue_exportfile(ls_file,"XML") = 1 THEN
			urows = 1
			trows = 0
			this.ResetUpdate()
		ELSE
			IF dbrows > 0 THEN
				urows = 1
				trows = 0
			ELSE
				urows = -1
			END IF
		END IF
		ls_file = ls_file + ".xml"
	CASE "MPF"
		//IF li_total = 1 THEN
			this.trigger event ue_export_mpf(TRUE)
		//ELSE
			//FOR li_page = 1 to li_total
				//this.trigger event ue_import_mpf()
				//this.trigger event ue_export_mpf(FALSE)
			//NEXT
		//END IF
		ls_file = ls_file + ".mpf"
END CHOOSE

IF NOT FileExists(ls_file) THEN
	Messagebox("Error","Could not save " + ls_file)
ELSE
	//Messagebox("Successful","Saved " + ls_file)
END IF
lb_changed = FALSE

//this.trigger event ue_zip()

end event

event ue_commit;this.trigger event ue_update()
end event

event ue_reretrieve;Integer li
String ls_item, ls_field
Date ld_date
ld_date = Today()

FOR li = 1 to Integer(this.Object.DataWindow.Column.Count)
	ls_field = this.Describe("#" + string(li) + ".Name")
	ls_item = ProfileString(gs_ini,"Forms",ls_field,"") 
	IF ls_item <> "" THEN this.setitem(1,li,ls_item)
	IF UPPER(left(ls_field,4)) = "DATE" THEN this.setitem(1,li,ld_date)
NEXT

end event

event ue_addnew;call super::ue_addnew;this.trigger event ue_reretrieve()
end event

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_retrieverecords.enabled = TRUE

end event

event clicked;call super::clicked;Integer li_yes, li_no, li
String ls_name
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
	string ls_photo, ls_new, ls_field
	long ll_size
	ll_size = long(ProfileString(gs_ini,"MAIN","PhotoSize","100")) * 1000
	ls_field = dwo.name
	ls_new = Left(ls_filename, len(ls_filename) - 4)
	ls_new += "p" + Right(ls_field,len(ls_field) - 6)
	ls_photo = this.trigger event ue_copypicture("",ls_new)
	IF filesize(ls_photo) > ll_size THEN
			Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
	ELSE
		IF ls_photo <> "" THEN
			this.setitem(row,dwo.name,ls_photo)
			this.accepttext()
		END IF
		this.setcolumn(0)
	END IF
CASE "docum_"
	openwithparm(w_forms_document,string(this.object.data[row,this.getcolumn()]))
	this.setitem(row,dwo.name,message.stringparm)
END CHOOSE
end event

event getfocus;call super::getfocus;//ShowPopupHelp ( "Help/my_app.hlp", this, 510)
end event

event itemchanged;call super::itemchanged;lb_changed = TRUE
IF dwo.tag = "spell" THEN RETURN this.trigger event ue_spell(dwo.name,row,data)
end event

event ue_print_report;//this.trigger event ue_zoom(100)
//IF li_total = 1 THEN
//	IF this.rowcount() > 0 THEN
//		IF printsetup() = 1 THEN dw_print.print()
//	ELSE
//		Messagebox("Print","No records to print")
//	END IF
//ELSE
	integer li_count, li_start
	li_count = this.trigger event get_page_count("pw")
	openwithparm(w_ask,"Print Page (" + string(li_count) + ")?/ALL")
	IF message.stringparm = "" THEN RETURN
	CHOOSE CASE message.stringparm
	CASE "ALL"
		li_start = 1
	CASE ELSE
		IF integer(message.stringparm) > 0 THEN
			IF integer(message.stringparm) <= li_count THEN
				li_start = integer(message.stringparm)
				li_count = li_start
			ELSE
				RETURN
			END IF
		ELSE
			RETURN
		END IF
	END CHOOSE
	printsetup()
	long ll_job
	ll_job = PrintOpen("Form " + ls_filename)
	FOR li_page = li_start to li_count
		st_status.text = "Printing " + string(li_page) + " of " + string(li_count)
		IF li_page = 1 THEN
			dw_print.trigger event ue_load_form(ls_form)
		ELSE
			dw_print.trigger event ue_load_form(ls_form + string(li_page))
		END IF			
		PrintDataWIndow(ll_job,dw_print)
	NEXT
	PrintClose(ll_job)
	st_status.text = "Printing Complete"
//END IF
end event

event buttonclicked;call super::buttonclicked;CHOOSE CASE Left(dwo.name,5)
CASE "b_pho"
	copy_picture(dwo.name,row,this)
CASE "help_"
	integer li_help, li, li_col
	string ls_help, ls_desc
	li_help = Integer(Right(dwo.name,len(string(dwo.name)) -pos(dwo.name,"_")))
	FOR li = 1 to dw_help.rowcount()
		IF li_help = dw_help.object.topicid[li] THEN
			IF pos(dw_help.object.topic[li],"<") = 1 THEN
				this.trigger event ue_setup_helplist(dw_help.object.topic[li])
				string(this.object.data[1,li])
				ls_help = dw_help.object.topic[li]
				ls_help = Mid(ls_help,2,len(ls_help) - 2)
				li_col = this.trigger event ue_check_field(this,ls_help)
				ls_desc = string(this.object.data[1,li_col])
				IF NOT ISNULL(ls_desc) OR ls_desc <> "" THEN
					ls_desc += "~r~n" + message.stringparm
				ELSE
					ls_desc = message.stringparm
				END IF
				this.setitem(1,ls_help,ls_desc)
			ELSE
				Messagebox(string(dw_help.object.topic[li]), &
					string(dw_help.object.description[li]))
			END IF
		END IF
	NEXT
CASE ELSE
	Messagebox("Button",string(dwo.name) + " not recognized")
END CHOOSE
end event

type dw_page3 from uo_datawindow within w_forms
boolean visible = false
integer x = 23
integer y = 128
integer width = 2592
integer height = 1732
integer taborder = 30
end type

event doubleclicked;call super::doubleclicked;CHOOSE CASE Left(dwo.name,6)
CASE "photo_"
	string ls_photo, ls_new, ls_field
	long ll_size
	ll_size = long(ProfileString(gs_ini,"MAIN","PhotoSize","100")) * 1000
	ls_field = dwo.name
	ls_new = Left(ls_filename, len(ls_filename) - 4)
	ls_new += "p" + Right(ls_field,len(ls_field) - 6) + string(row)
	ls_photo = this.trigger event ue_copypicture("",ls_new)
	IF filesize(ls_photo) > ll_size THEN
			Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
	ELSE
		IF ls_photo <> "" THEN
			this.setitem(row,dwo.name,ls_photo)
		END IF
		this.setcolumn(0)
	END IF
CASE "docum_"
	openwithparm(w_forms_document,string(this.object.data[row,this.getcolumn()]))
	this.setitem(row,dwo.name,message.stringparm)
END CHOOSE
end event

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_add.enabled = TRUE
lm_list.m_listview.m_delete.enabled = TRUE
end event

event buttonclicked;call super::buttonclicked;CHOOSE CASE Left(dwo.name,8)
CASE "b_photo_"
	copy_picture(dwo.name,row,this)
CASE ELSE
	Messagebox("Button",string(dwo.name) + " not recognized")
END CHOOSE
end event

event ue_addnew;call super::ue_addnew;dw_defaultw.trigger event ue_set_page(this)
end event

event itemchanged;call super::itemchanged;IF dwo.tag = "spell" THEN RETURN this.trigger event ue_spell(dwo.name,row,data)
end event

type dw_page2 from uo_datawindow within w_forms
boolean visible = false
integer x = 23
integer y = 132
integer width = 2592
integer height = 1732
integer taborder = 30
end type

event doubleclicked;call super::doubleclicked;CHOOSE CASE Left(dwo.name,6)
CASE "photo_"
	string ls_photo, ls_new, ls_field
	long ll_size
	ll_size = long(ProfileString(gs_ini,"MAIN","PhotoSize","100")) * 1000
	ls_field = dwo.name
	ls_new = Left(ls_filename, len(ls_filename) - 4)
	ls_new += "p" + Right(ls_field,len(ls_field) - 6)
	ls_photo = this.trigger event ue_copypicture("",ls_new)
	IF filesize(ls_photo) > ll_size THEN
			Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
	ELSE
		IF ls_photo <> "" THEN
			this.setitem(row,dwo.name,ls_photo)
		END IF
		this.setcolumn(0)
	END IF
CASE "docum_"
	openwithparm(w_forms_document,string(this.object.data[row,this.getcolumn()]))
	this.setitem(row,dwo.name,message.stringparm)
END CHOOSE
end event

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_add.enabled = TRUE
lm_list.m_listview.m_delete.enabled = TRUE
end event

event buttonclicked;call super::buttonclicked;CHOOSE CASE Left(dwo.name,8)
CASE "b_photo_"
	copy_picture(dwo.name,row,this)
CASE ELSE
	Messagebox("Button",string(dwo.name) + " not recognized")
END CHOOSE
end event

event ue_addnew;call super::ue_addnew;dw_defaultw.trigger event ue_set_page(this)
end event

event itemchanged;call super::itemchanged;IF dwo.tag = "spell" THEN RETURN this.trigger event ue_spell(dwo.name,row,data)
end event

type dw_page5 from uo_datawindow within w_forms
boolean visible = false
integer x = 18
integer y = 128
integer width = 2592
integer height = 1732
integer taborder = 50
end type

event ue_addnew;call super::ue_addnew;dw_defaultw.trigger event ue_set_page(this)
end event

event itemchanged;call super::itemchanged;IF dwo.tag = "spell" THEN RETURN this.trigger event ue_spell(dwo.name,row,data)
end event

type dw_page4 from uo_datawindow within w_forms
boolean visible = false
integer x = 23
integer y = 132
integer width = 2592
integer height = 1732
integer taborder = 50
end type

event doubleclicked;call super::doubleclicked;CHOOSE CASE Left(dwo.name,6)
CASE "photo_"
	string ls_photo, ls_new, ls_field
	long ll_size
	ll_size = long(ProfileString(gs_ini,"MAIN","PhotoSize","100")) * 1000
	ls_field = dwo.name
	ls_new = Left(ls_filename, len(ls_filename) - 4)
	ls_new += "p" + Right(ls_field,len(ls_field) - 6)
	ls_photo = this.trigger event ue_copypicture("",ls_new)
	IF filesize(ls_photo) > ll_size THEN
			Messagebox("Photo","Photo Size is too large-must be under" + string(ll_size/1000) + " KB")
	ELSE
		IF ls_photo <> "" THEN
			this.setitem(row,dwo.name,ls_photo)
		END IF
		this.setcolumn(0)
	END IF
CASE "docum_"
	openwithparm(w_forms_document,string(this.object.data[row,this.getcolumn()]))
	this.setitem(row,dwo.name,message.stringparm)
END CHOOSE
end event

event ue_rightbutton;call super::ue_rightbutton;lm_list.m_listview.m_add.enabled = TRUE
lm_list.m_listview.m_delete.enabled = TRUE
end event

event buttonclicked;call super::buttonclicked;CHOOSE CASE Left(dwo.name,8)
CASE "b_photo_"
	copy_picture(dwo.name,row,this)
CASE ELSE
	Messagebox("Button",string(dwo.name) + " not recognized")
END CHOOSE
end event

event ue_addnew;call super::ue_addnew;dw_defaultw.trigger event ue_set_page(this)
end event

event itemchanged;call super::itemchanged;IF dwo.tag = "spell" THEN RETURN this.trigger event ue_spell(dwo.name,row,data)
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
04w_forms.bin 
2600000e00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000c01b642001c76a3500000003000002400000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000260000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000000f600000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004db79769011d240e06000d59b72e32a0800000000c01b642001c76a35c01b642001c76a35000000000000000000000000fffffffe000000020000000300000004fffffffe000000060000000700000008fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0049005a0036005000440030005700450043004100550038004300520048005000320034006700410070002000670061007300650061006d00200078002000290000030000020008000000000006000300080000000000020003000000000000001800030008000000000002000800000000000200070000000000004000000000000007924080000003414600000000000000030003000000000000ffff000b0000000b0000000b0000000b0000000b0000000b0002000800000000ffff000b0002000800000000000200080000000000020003000300000000000a0000000b0000000b0002000800000000000200080000000000020008000000000000000300080000000000020008000000000002000b000000080000000000020008000000000002000800000000000200080000000000020072000000750062007400740000030000020008000000000006000300080000000000020003000000000000001800030008000000000002000800000000000200070000000000004000000000000007924080000003414600000000000000030003000000000000ffff000b0000000b0000000b0000000b0000000b0000000b0002000800000000ffff000b0002000800000000000200080000000000020003000300000000000a0000000b0000000b00020008000000000002000800000000000200080000000000000003006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000005000000f6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000020008000000000002000b00000008000000000002000800000000000200080000000000020008000000000002006700000063002000720075006500720074006e006f0072002c0077006c0020006e006f002000670065006e007200770077006f00290020002000200065007200750074006e007200200073006f006c0067006e005b002000620070005f006d007700640072006e0077006f00680063006e0061006900670067006e0000005d00630073006f0072006c006c006f006800690072006f007a0074006e006c006100280020006c0020006e006f0020006700630073006f0072006c006c006f0070002c0073006900200074006e006700650072006500700020006e006100200065002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d00620064005f006e00770073006800720063006c006f005d006c0073000000720063006c006f0076006c0072006500690074006100630020006c00200028006f006c0067006e0073002000720063006c006f0070006c0073006f00290020002000200065007200750074006e007200200073006f006c0067006e005b002000620070005f006d007700640076006e00630073006f0072006c006c0000005d007100730070006c0065007200690076007700650028002000730020006c007100720070007600650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14w_forms.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
