HA$PBExportHeader$w_photos.srw
forward
global type w_photos from window
end type
type cb_3 from commandbutton within w_photos
end type
type cb_2 from commandbutton within w_photos
end type
type cbx_thumbnails from checkbox within w_photos
end type
type st_status from multilineedit within w_photos
end type
type cb_1 from commandbutton within w_photos
end type
type tv_list from treeview within w_photos
end type
type uo_pict from uo_pictures within w_photos
end type
type sle_dir from singlelineedit within w_photos
end type
type lb_dir from listbox within w_photos
end type
end forward

global type w_photos from window
integer width = 2295
integer height = 1532
boolean titlebar = true
string title = "Photo Manager"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
event type integer ue_check_field ( datawindow ldw,  string ls_field )
event ue_load_all ( )
cb_3 cb_3
cb_2 cb_2
cbx_thumbnails cbx_thumbnails
st_status st_status
cb_1 cb_1
tv_list tv_list
uo_pict uo_pict
sle_dir sle_dir
lb_dir lb_dir
end type
global w_photos w_photos

type prototypes

end prototypes

type variables
integer li_timer, li_dir, ii_ecount, ii_ecurrent = 0
long li_current
string ls_directory[], ls_thumbnail[]
boolean lb_emage_error = FALSE 

end variables

forward prototypes
public function string get_height (datawindow ldw, integer li_row, string ls_field, integer li_owidth, integer li_oheight)
end prototypes

event type integer ue_check_field(datawindow ldw, string ls_field);string ls_bfield
integer li, li_found, li_count

IF ls_field = "?" THEN 
	Messagebox("Field Error","Problem loading field")
	RETURN 0
END IF
//IF ldw.rowcount() = 0 THEN RETURN 0
FOR li = 1 to Integer(ldw.Object.DataWindow.Column.Count)
	ls_bfield = ldw.Describe("#" + string(li) + ".Name")
	IF ls_field = ls_bfield THEN li_found = li
NEXT

IF li_found = 0 AND ProfileString(gs_ini,"Utilities","FormError","NO") = "YES" THEN
	Messagebox("Field Error","Problem checking field " + ls_field)
END IF


RETURN li_found
end event

public function string get_height (datawindow ldw, integer li_row, string ls_field, integer li_owidth, integer li_oheight);long li_awidth, li_aheight, li_height, li_width, ll_size, ll_fsize
Decimal ld_perc
string ls_field2, ls_fname, ls_compress
Boolean lb_found = FALSE
integer li

ls_fname = uo_pict.st_desc.text
ls_compress = get_pathname(ls_fname) + "compress\" + get_filename(ls_fname)
IF FileExists(ls_compress) THEN 
	ls_fname = ls_compress
END IF
	
IF NOT uo_pict.trigger event ue_check_size(ls_fname,TRUE) THEN RETURN ""

st_status.text = "Calculating size...."

//FOR li = 1 TO Upperbound(ls_pic)
//	IF ls_pic[li] = ls_field THEN
//		li_owidth = li_wpic[li]
//		li_oheight = li_hpic[li]
//		lb_found = TRUE
//	END IF
//NEXT
//
//IF NOT lb_found THEN
//	li = Upperbound(ls_pic) + 1
//	ls_pic[li] = ls_field
//	li_owidth = Integer(ldw.Describe(ls_field + ".Width"))
//	li_oheight = Integer(ldw.Describe(ls_field + ".Height"))
//	li_wpic[li] = li_owidth
//	li_hpic[li] = li_oheight
//END IF
//
open(w_picture_set)
ls_fname = w_picture_set.set_picture(ldw,li_row,ls_field,ls_fname,li_owidth, li_oheight)
close(w_picture_set)

RETURN ls_fname
end function

on w_photos.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cbx_thumbnails=create cbx_thumbnails
this.st_status=create st_status
this.cb_1=create cb_1
this.tv_list=create tv_list
this.uo_pict=create uo_pict
this.sle_dir=create sle_dir
this.lb_dir=create lb_dir
this.Control[]={this.cb_3,&
this.cb_2,&
this.cbx_thumbnails,&
this.st_status,&
this.cb_1,&
this.tv_list,&
this.uo_pict,&
this.sle_dir,&
this.lb_dir}
end on

on w_photos.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cbx_thumbnails)
destroy(this.st_status)
destroy(this.cb_1)
destroy(this.tv_list)
destroy(this.uo_pict)
destroy(this.sle_dir)
destroy(this.lb_dir)
end on

event timer;string ls_direc
integer li, li_count = 0, lx
boolean lb_found = FALSE, lb_dup
li_timer += 1
IF li_timer = 4 THEN
	FOR li = 1 to 10
		ls_direc = ProfileString(gs_ini,"PhotoDir",string(li),"")
		IF FileExists(ls_direc) THEN 
			lb_found = TRUE
			li_count += 1
			lb_dup = FALSE
			FOR lx = 1 to Upperbound(ls_directory)
				IF ls_direc = ls_directory[lx] THEN lb_dup = TRUE
			NEXT
			IF NOT lb_dup THEN
				ls_directory[li_count] = ls_direc
				sle_dir.text = ls_direc
				sle_dir.trigger event ue_change()
			END IF
		END IF
	NEXT
	//lb_dir.trigger event ue_load_pictures("jp","Pictures")
	//lb_dir.trigger event ue_load_pictures("bmp","Bitmaps")
	Timer(0)
	IF NOT lb_found THEN
		openwithparm(w_find,"?" + ProfileString(gs_ini,"Photos","Dir",""))
		sle_dir.text = message.stringparm
		sle_dir.trigger event ue_change()
	END IF
END IF
end event

event close;Integer li

FOR li = 1 to Upperbound(ls_directory)
	SetProfileString(gs_ini,"PhotoDir",string(li),ls_directory[li])
NEXT
end event

event open;st_status.text = "Waiting..."

end event

type cb_3 from commandbutton within w_photos
boolean visible = false
integer x = 1102
integer y = 1216
integer width = 361
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset Picture"
end type

event clicked;sle_dir.trigger event ue_emage_filename("photo_th","thumbnails",uo_pict.st_desc.text,TRUE)

end event

type cb_2 from commandbutton within w_photos
boolean visible = false
integer x = 1778
integer y = 1216
integer width = 421
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Compress Picture"
end type

event clicked;string ls_file
this.text = "Compressing..."
ls_file = sle_dir.trigger event ue_emage_filename("photo_cmp","compress",uo_pict.st_desc.text,TRUE)
this.text = "Compress"
IF FIleExists(ls_File) THEN
	uo_pict.trigger event ue_load_picture(uo_pict.st_desc.text)
ELSE
	Messagebox("Compressed FIle",ls_file + " not found")
END IF


end event

event constructor;IF ProfileString(gs_ini,"MAIN","JPEG","") = "EMAGE" THEN this.visible = TRUE
end event

type cbx_thumbnails from checkbox within w_photos
integer x = 18
integer y = 1212
integer width = 494
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Load Thumbnails"
boolean checked = true
end type

event constructor;IF ProfileString(gs_ini,"PhotoDir","Thumbnails","YES") = "YES" THEN
	this.checked = TRUE
ELSE
	this.checked = FALSE
	cb_2.visible = FALSE
END IF
end event

event clicked;IF this.checked THEN
	SetProfileString(gs_ini,"PhotoDir","Thumbnails","YES")
	cb_2.visible = TRUE
ELSE
	SetProfileString(gs_ini,"PhotoDir","Thumbnails","NO")
	cb_2.visible = FALSE
END IF
end event

type st_status from multilineedit within w_photos
integer y = 1320
integer width = 2208
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Ready"
boolean border = false
boolean displayonly = true
end type

type cb_1 from commandbutton within w_photos
boolean visible = false
integer x = 1431
integer y = 1008
integer width = 672
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Directory"
end type

event clicked;openwithparm(w_find, "?" + sle_dir.text)
sle_dir.text = message.stringparm
sle_dir.trigger event ue_change()
end event

type tv_list from treeview within w_photos
integer width = 704
integer height = 1184
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string picturename[] = {"Custom007!","Custom014!","Custom059!","Custom050!"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event selectionchanged;TreeViewItem l_tvinew, l_tviold

This.GetItem(oldhandle, l_tviold)
This.GetItem(newhandle, l_tvinew)

Integer li, li_group, li_start, li_end, li_count = 0
String ls_new, ls_newname

ls_new = string(l_tvinew.Label)

IF cbx_thumbnails.checked THEN uo_pict.lb_thumbnails = TRUE

IF pos(ls_new,":") > 0 THEN 
	li_current = newhandle
ELSE
IF l_tvinew.PictureIndex = 4 THEN RETURN
IF ls_new = "Pictures" OR ls_new = "Bitmaps" THEN RETURN
IF Pos(ls_new,"Group") > 0 THEN
	li_start = newhandle + 1
	li_end = li_start + 5
	uo_pict.trigger event ue_clear_pictures()
	FOR li = li_start TO li_end
		IF This.GetItem(li, l_tvinew) = 1 THEN
			IF l_tvinew.Children = FALSE THEN
				li_count += 1	
				uo_pict.trigger event ue_add_picture(li_count,l_tvinew.Data)
			END IF
		END IF
	NEXT
ELSE
	li_start = newhandle
	li_end = li_start + 5
	uo_pict.trigger event ue_clear_pictures()
	ls_newname = string(l_tvinew.Data)
	FOR li = li_start TO li_end
		IF This.GetItem(li, l_tvinew) = 1 THEN
			IF l_tvinew.Children = FALSE THEN
				sle_dir.trigger event ue_emage_filename("photo_th","thumbnails",l_tvinew.Data,FALSE)
			END IF
		END IF
	NEXT
	uo_pict.trigger event ue_load_picture(ls_newname)
	FOR li = li_start TO li_end
		IF This.GetItem(li, l_tvinew) = 1 THEN
			IF l_tvinew.Children = FALSE THEN
				li_count += 1	
				IF cbx_thumbnails.checked THEN
					uo_pict.trigger event ue_add_picture(li_count,l_tvinew.Data)
				END IF
			END IF
		END IF
	NEXT
END IF
END IF	
end event

event rightclicked;rmenu_photos lm_list
lm_list = create rmenu_photos
lm_list.PopMenu(w_forms_main.i_active_sheet.PointerX(), w_forms_main.i_active_sheet.PointerY())
destroy lm_list
end event

type uo_pict from uo_pictures within w_photos
integer x = 722
integer width = 1504
integer height = 1208
integer taborder = 10
long backcolor = 0
string text = ""
long tabtextcolor = 0
long picturemaskcolor = 0
end type

on uo_pict.destroy
call uo_pictures::destroy
end on

type sle_dir from singlelineedit within w_photos
event ue_change ( )
event ue_remove ( )
event type string ue_emage ( string ls_profile,  string ls_dir )
event type string ue_emage_filename ( string ls_profile,  string ls_tpath,  string ls_filename,  boolean lb_overwrite )
boolean visible = false
integer x = 69
integer y = 452
integer width = 1778
integer height = 68
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "c:\attach"
borderstyle borderstyle = stylelowered!
end type

event ue_change();String pathname, filename, ls_path, ls_icon

//ls_path = sle_dir.text
//
//GetFileOpenName ( "Location of Picture", pathname, filename, "JPG", &
//	"JPEG files (*.JPG), *.JPG, *.BMP, Bitmap files (*.RLE), *.RLE," + &
//	"Windows Metafiles (*.WMF), *.WMF, Bitmap files (*.BMP), *.BMP," + &
//	"GIF Files (*.gif), *.gif",ls_path)
//

Integer li, lx = 0
Boolean lb_found = FALSE
ii_ecount = Integer(ProfileString(gs_ini,"EMAGE","Count","10"))
ii_ecurrent = 1

FOR li = 1 to Upperbound(ls_directory)
	IF ls_directory[li] = sle_dir.text THEN lb_found = TRUE
NEXT
IF NOT lb_found THEN
	FOR li = 1 to Upperbound(ls_directory)
		IF ls_directory[li] = "" THEN lx = li
	NEXT
	IF lx = 0 THEN 
		IF Upperbound(ls_directory) = 10 THEN
			lx = 10
		ELSE
			lx = Upperbound(ls_directory) + 1
		END IF
	END IF
	ls_directory[lx] = sle_dir.text
END IF

pathname = sle_dir.text
IF FileExists(pathname) THEN
	//sle_dir.text = get_pathname(pathname)
	//ls_icon = this.trigger event ue_emage("photo_th",sle_dir.text)
	//SetProfileString(gs_ini,"Photos","Dir",ls_icon)
	//lb_dir.trigger event ue_load_pictures("jp","Pictures")
	//lb_dir.trigger event ue_load_pictures("bmp","Bitmaps")
	
	lb_dir.trigger event ue_load_pictures()
END IF
ii_ecount = 1
ii_ecurrent = 1
end event

event ue_remove();Integer li
TreeViewItem l_tvinew
String ls_label

tv_list.GetItem(li_current, l_tvinew)
ls_label = l_tvinew.Label

IF Messagebox("Remove Directory", "This will remove " + &
	ls_label + " from your list.  Do you wish to continue", Question!, &
	YesNo!,2) = 1 THEN
	tv_list.DeleteItem(li_current)
	FOR li = 1 to Upperbound(ls_directory)
		IF ls_directory[li] = ls_label THEN	
			ls_directory[li] = ""
			EXIT
		END IF
	NEXT
END IF

end event

event type string ue_emage(string ls_profile, string ls_dir);string ls_prodir, ls_log, ls_new, ls_message, ls_exe, ls_options

IF	ProfileString(gs_ini,"MAIN","JPEG","") <> "EMAGE" THEN RETURN ls_dir
	
ls_exe = set_ini("Location of Emage Processor","EMAGE","CMD","C:\Program Files\E-Mage Processor\empc.exe",FALSE)
ls_prodir = ProfileString(gs_ini,"MAIN","Templates","") + "\" + ls_profile + ".emp"
ls_log = set_ini("Location of Emage Log","EMAGE","LOG","c:\minipro\emagelog.txt",FALSE)
ls_options = "-L:" + ls_log + " -Overwrite -D:"
ls_new = ls_dir + "\thumbnails\"
CreateDirectory(ls_new)

IF Not FileExists(ls_exe) THEN
	IF NOT lb_emage_error THEN
		Messagebox("Emage Processor", ls_exe + " does not exist")
		lb_emage_error = TRUE
	END IF
	RETURN ""
END IF
IF Not FileExists(ls_prodir) THEN
	IF NOT lb_emage_error THEN
		Messagebox("Profile",ls_prodir + " does not exist")
		lb_emage_error = TRUE
	END IF
	RETURN ls_dir
END IF
ls_message = "~"" + ls_exe + "~" " + ls_prodir + " ~"" + ls_dir + "~" " + ls_options + "~"" + ls_new + "~""
//Messagebox("",ls_message)
IF Run(ls_message) = 1 THEN RETURN ls_new
RETURN ""
//run_file(ls_log)

end event

event type string ue_emage_filename(string ls_profile, string ls_tpath, string ls_filename, boolean lb_overwrite);string ls_prodir, ls_log, ls_new, ls_message, ls_exe, ls_options
integer li

IF	ProfileString(gs_ini,"MAIN","JPEG","") <> "EMAGE" THEN RETURN ls_filename
IF NOT cbx_thumbnails.checked THEN RETURN ls_filename	
ls_exe = set_ini("Location of Emage Processor","EMAGE","CMD","C:\Program Files\E-Mage Processor\empc.exe",FALSE)
ls_prodir = ProfileString(gs_ini,"MAIN","Templates","") + "\" + ls_profile + ".emp"
ls_log = set_ini("Location of Emage Log","EMAGE","LOG","c:\minipro\emagelog.txt",FALSE)
ls_options = "-L:" + ls_log + " -Overwrite -D:"
ls_new = get_pathname(ls_filename) + ls_tpath + "\" 
IF NOT lb_overwrite THEN
	IF FileExists(ls_new + get_filename(ls_filename)) THEN 
		RETURN ls_new + get_filename(ls_filename)
	END IF
END IF
CreateDirectory(ls_new)

IF Not FileExists(ls_exe) THEN
	IF NOT lb_emage_error THEN
		Messagebox("Emage Processor", ls_exe + " does not exist")
		lb_emage_error = TRUE
	END IF
	RETURN ""
END IF
IF Not FileExists(ls_prodir) THEN
	IF NOT lb_emage_error THEN
		Messagebox("Profile",ls_prodir + " does not exist")
		lb_emage_error = TRUE
	END IF
	RETURN ls_filename
END IF
ls_message = "~"" + ls_exe + "~" " + ls_prodir + " ~"" + ls_filename + "~" " + ls_options + "~"" + ls_new + "~""
//Messagebox("",ls_message)
IF Run(ls_message,Minimized!) = 1 THEN 
	//Messagebox("",ls_new + get_filename(ls_Filename))
	IF ii_ecurrent = ii_ecount THEN
		DO UNTIL FileExists(ls_new + get_filename(ls_Filename))
			Yield()
		LOOP
		ii_ecurrent = 1
	ELSE
		ii_ecurrent += 1
	END IF
	RETURN ls_new + get_filename(ls_Filename)
END IF
RETURN ""
//run_file(ls_log)

end event

event modified;SetProfileString(gs_ini,"Photos","Dir1",this.text)
lb_dir.trigger event ue_load_pictures()
//lb_dir.trigger event ue_load_pictures("jp","Pictures")
//lb_dir.trigger event ue_load_pictures("bm","Bitmaps")
end event

event constructor;this.text = ProfileString(gs_ini,"Photos","Dir","")
Timer(.2)
//lb_dir.trigger event ue_load_pictures()

end event

type lb_dir from listbox within w_photos
event clilcked pbm_bnclicked
event ue_load_pictures ( )
event ue_load_pictures_old ( string ls_type,  string ls_name )
event ue_load_dir ( string ls_photodir,  treeviewitem ltvi_root,  long ll_root,  long ll_child,  long ll_main )
boolean visible = false
integer x = 2949
integer y = 32
integer width = 681
integer height = 1060
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_load_pictures();Integer li, li_count = 0, li_group = 1
string ls_sdir, ls_folders[]
boolean lb_add

Long				ll_Root, ll_Child, ll_Main
TreeViewItem	ltvi_Root

ltvi_Root.Label = sle_dir.text
ltvi_Root.PictureIndex = 1
ltvi_Root.SelectedPictureIndex = 1
ltvi_Root.Children = True
ll_Main = tv_list.InsertItemLast(0, ltvi_Root)

tv_list.ExpandItem(ll_Root)

// Setup Levels
this.trigger event ue_load_dir(sle_dir.text, ltvi_Root, ll_Root, ll_Child, ll_Main)

lb_dir.DirList(sle_dir.text + "\[*]",16)

FOR li = 1 to lb_dir.totalitems()
	ls_folders[li] = lb_dir.text(li)
NEXT

FOR li = 1 to Upperbound(ls_folders)
	lb_add = FALSE
	ls_sdir = Mid(ls_folders[li],2, len(ls_folders[li]) - 2) 
	lb_dir.DirList(sle_dir.text + "\" + ls_sdir + "\*.jpg",0)
	IF lb_dir.totalitems() > 0 THEN lb_add = TRUE
	lb_dir.DirList(sle_dir.text + "\" + ls_sdir + "\*.bmp",0)
	IF lb_dir.totalitems() > 0 THEN lb_add = TRUE
	CHOOSE CASE Upper(ls_sdir)
	CASE "THUMBNAILS","COMPRESS",".."
		lb_add = FALSE
	END CHOOSE
	IF lb_add THEN
		ltvi_Root.Label =  ls_sdir
		ltvi_Root.PictureIndex = 4
		ltvi_Root.SelectedPictureIndex = 4
		ltvi_Root.Children = True
		ll_Root = tv_list.InsertItemLast(ll_Main, ltvi_Root)
		tv_list.ExpandItem(ll_Root)
		this.trigger event ue_load_dir(sle_dir.text + "\" + ls_sdir, ltvi_Root, ll_Root, ll_Child, ll_Root)
	END IF
NEXT

st_status.text = "Ready"

end event

event ue_load_pictures_old(string ls_type, string ls_name);Integer li, li_count = 0, li_group = 1

lb_dir.DirList(sle_dir.text + "\*." + ls_type + "*",0)
//plb_1.DirList(sle_dir.text,16)

//uo_pict.trigger event ue_clear_pictures()

Long				ll_Root, ll_Child, ll_Main
TreeViewItem	ltvi_Root

ltvi_Root.Label = ls_name
ltvi_Root.PictureIndex = 1
ltvi_Root.SelectedPictureIndex = 1
ltvi_Root.Children = True
ll_Main = tv_list.InsertItemLast(0, ltvi_Root)

tv_list.ExpandItem(ll_Root)
//tv_list.SelectItem(ll_Root)

//tv_list.SelectItem(ll_Root)

For li = 1 to this.totalitems()
	IF li = 1 THEN
		ltvi_Root.Label = "Group " + string(li_group)
		ltvi_Root.PictureIndex = 2
		ltvi_Root.SelectedPictureIndex = 2
		ltvi_Root.Children = True
		ll_Root = tv_list.InsertItemLast(ll_Main, ltvi_Root)
		tv_list.ExpandItem(ll_Root)
	END IF

	li_count += 1
	IF li_group = 1 THEN
		//uo_pict.trigger event ue_add_picture(li,sle_dir.text + this.text(li))
	END IF

	ltvi_Root.Label = this.text(li)
	ltvi_Root.Data = sle_dir.text + this.text(li)
	ltvi_Root.PictureIndex = 3
	ltvi_Root.SelectedPictureIndex = 3
	ltvi_Root.Children = False
	ll_Child = tv_list.InsertItemLast(ll_root, ltvi_Root)

	//long ll_tvi, ll_tvparent

	//ll_tvi = tv_list.FindItem(currenttreeitem! , 0)
	//ll_tvparent = tv_list.FindItem(parenttreeitem!,ll_tvi)
	IF li_count = 5 THEN
		li_count = 0
		li_group += 1
		ltvi_Root.Label = "Group " + string(li_group)
		ltvi_Root.PictureIndex = 2
		ltvi_Root.SelectedPictureIndex = 2
		ltvi_Root.Children = True
		ll_Root = tv_list.InsertItemLast(ll_Main, ltvi_Root)
	END IF

	st_status.text = "Loading " + string(li) + "...."
Next 
uo_pict.p_1.trigger event clicked()
st_status.text = "Ready"

end event

event ue_load_dir(string ls_photodir, treeviewitem ltvi_root, long ll_root, long ll_child, long ll_main);Integer li, li_count = 0, li_group = 1

// Setup Levels
lb_dir.DirList(ls_photodir + "\*.jp*",0)

//sle_dir.trigger event ue_emage("photo_th",ls_photodir)

IF lb_dir.totalitems() > 0 THEN
	ltvi_Root.Label = "Pictures"
	ltvi_Root.PictureIndex = 2
	ltvi_Root.SelectedPictureIndex = 2
	ltvi_Root.Children = True
	ll_Root = tv_list.InsertItemLast(ll_Main, ltvi_Root)
	tv_list.ExpandItem(ll_Root)

	For li = 1 to this.totalitems()
		ltvi_Root.Label = this.text(li)
		ltvi_Root.Data = ls_photodir + "\" + this.text(li)
		ltvi_Root.PictureIndex = 3
		ltvi_Root.SelectedPictureIndex = 3
		ltvi_Root.Children = False
		ll_Child = tv_list.InsertItemLast(ll_root, ltvi_Root)
		IF ProfileString(gs_ini,"PhotoDir","Auto","YES") = "NO" THEN
			sle_dir.trigger event ue_emage_filename("photo_th","thumbnails",ls_photodir + "\" + this.text(li),FALSE)
		END IF
		st_status.text = "Loading " + string(li) + "...."
	Next
End if 

// Setup Levels
lb_dir.DirList(ls_photodir + "\*.bm*",0)

IF lb_dir.totalitems() > 0 THEN
	ltvi_Root.Label = "Bitmaps"
	ltvi_Root.PictureIndex = 2
	ltvi_Root.SelectedPictureIndex = 2
	ltvi_Root.Children = True
	ll_Root = tv_list.InsertItemLast(ll_Main, ltvi_Root)
	tv_list.ExpandItem(ll_Root)

	For li = 1 to this.totalitems()
		ltvi_Root.Label = this.text(li)
		ltvi_Root.Data = ls_photodir + this.text(li)
		ltvi_Root.PictureIndex = 3
		ltvi_Root.SelectedPictureIndex = 3
		ltvi_Root.Children = False
		ll_Child = tv_list.InsertItemLast(ll_root, ltvi_Root)
		st_status.text = "Loading " + string(li) + "...."
	Next
End If 


st_status.text = "Ready"

end event

