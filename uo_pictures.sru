HA$PBExportHeader$uo_pictures.sru
forward
global type uo_pictures from userobject
end type
type st_comment from statictext within uo_pictures
end type
type st_desc from statictext within uo_pictures
end type
type p_main from picture within uo_pictures
end type
type p_1 from picture within uo_pictures
end type
type p_2 from picture within uo_pictures
end type
type p_3 from picture within uo_pictures
end type
type p_4 from picture within uo_pictures
end type
type p_5 from picture within uo_pictures
end type
end forward

global type uo_pictures from userobject
integer width = 1513
integer height = 1196
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_add_picture ( integer li_picture,  string ls_picture )
event ue_clear_pictures ( )
event ue_load_picture ( string ls_name )
event type long ue_getsize ( string ls_filename )
event type boolean ue_check_size ( string ls_filename,  boolean lb_ask )
st_comment st_comment
st_desc st_desc
p_main p_main
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
p_5 p_5
end type
global uo_pictures uo_pictures

type prototypes
FUNCTION long filesize(string f) LIBRARY "FUNCky32.DLL" alias for "filesize;Ansi"
end prototypes

type variables
long ll_total = 0
boolean lb_thumbnails = FALSE
end variables

event ue_add_picture(integer li_picture, string ls_picture);String ls_thumb, ls_compress
Boolean lb_thumb = FALSE
long ll_size

ls_thumb = ls_picture
IF lb_thumbnails AND NOT w_photos.lb_emage_error THEN
	ls_thumb = get_pathname(ls_picture) + "thumbnails\" + get_filename(ls_picture)
	IF FileExists(ls_thumb) THEN 
		lb_thumb = TRUE
	ELSE
		//w_photos.sle_dir.trigger event ue_emage_filename("photo_th","thumbnails",ls_picture,FALSE)
		//Messagebox("Emage Processor",ls_thumb + " not found")
		//DO UNTIL FileExists(ls_thumb)
		//LOOP
		//lb_thumb = TRUE
		ls_thumb = ls_picture
	END IF
	//ls_compress = get_pathname(ls_picture) + "compress\" + get_filename(ls_picture)
	//IF FileExists(ls_compress) THEN 
		//Messagebox("Emage Processor",ls_thumb + " not found")
		//ls_picture = ls_compress
	//END IF
END IF

IF ls_picture = "" THEN
	ll_size = 0
ELSE
	ll_size = this.trigger event ue_getsize(ls_picture)
	ll_total += ll_size
END IF
IF ll_size > 0 THEN
	//ls_thumb = ls_picture + " [" + string(ll_size) + "]"
	//ls_thumb = ls_picture
	IF NOT lb_thumb THEN
		IF NOT this.trigger event ue_check_size(ls_picture,FALSE) THEN ls_picture = "Close!"
	END IF
ELSE
	//ls_thumb = ls_picture
END IF

//IF ll_total > 1500000 THEN RETURN
CHOOSE CASE li_picture
CASE 1
	p_1.PictureName = ls_thumb
	p_1.PowerTipText = ls_picture
CASE 2
	p_2.PictureName = ls_thumb
	p_2.PowerTipText = ls_picture
CASE 3
	p_3.PictureName = ls_thumb
	p_3.PowerTipText = ls_picture
CASE 4
	p_4.PictureName = ls_thumb
	p_4.PowerTipText = ls_picture
CASE 5
	p_5.PictureName = ls_thumb
	p_5.PowerTipText = ls_picture
END CHOOSE
end event

event ue_clear_pictures();Integer li

ll_total = 0
FOR li = 1 to 15
	this.trigger event ue_add_picture(li,"")
NEXT
end event

event ue_load_picture(string ls_name);String ls_size, ls_thumb, ls_compress
Boolean lb_compress = FALSE

ls_thumb = ls_name
ls_compress = ls_name
IF lb_thumbnails THEN
	ls_thumb = get_pathname(ls_name) + "thumbnails\" + get_filename(ls_name)
	IF NOT FileExists(ls_thumb) THEN 
		//w_photos.sle_dir.trigger event ue_emage_filename("photo_th","thumbnails",ls_name,FALSE)
		//IF NOT FileExists(ls_thumb) THEN
			//Messagebox("Emage Processor",ls_thumb + " not found")
		ls_thumb = ls_name
		//END IF
	END IF
	ls_compress = get_pathname(ls_name) + "compress\" + get_filename(ls_name)
	IF FileExists(ls_compress) THEN 
		lb_compress = TRUE
	ELSE
		ls_compress = ls_name
	END IF
END IF

ls_size = string(Round(this.trigger event ue_getsize(ls_compress)/1000,0))
P_main.PowerTipText = "File Size:  " + ls_size + " KB"

//ls_thumb = get_pathname(ls_picture) + "thumbnails" + get_filename(ls_picture)

IF this.trigger event ue_check_size(ls_compress,FALSE) THEN
	p_main.PictureName = ls_thumb
	st_desc.Text = ls_name
	IF lb_compress THEN
		st_comment.text = "COMPRESSED"
		st_comment.visible = TRUE
	ELSE
		st_comment.visible = FALSE
	END IF
ELSE
	p_main.PictureName = ls_thumb
	st_desc.Text = ls_name
	IF lb_compress THEN
		st_comment.text = "COMPRESSED/LARGE"
	ELSE
		st_comment.text = "PHOTO TOO LARGE"
	END IF
	st_comment.visible = TRUE
END IF

end event

event type long ue_getsize(string ls_filename);long ll_file

IF ls_Filename = "" THEN RETURN 0
ll_file = FileSize(ls_filename)

RETURN ll_file
end event

event type boolean ue_check_size(string ls_filename, boolean lb_ask);long ll_size, ll_fsize

ll_size = long(ProfileString(gs_ini,"MAIN","PhotoSize","700")) * 1000
ll_fsize = this.trigger event ue_getsize(ls_filename)
IF ll_size >= ll_fsize THEN RETURN TRUE
IF lb_ask THEN
	Messagebox("Photo Size","Photo is too large, must be under " + string(ll_size/1000) + "kb " + &
		"current size is " + string(Round(ll_fsize / 1000,0)) + "kb")
END IF
RETURN FALSE

end event

on uo_pictures.create
this.st_comment=create st_comment
this.st_desc=create st_desc
this.p_main=create p_main
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.p_5=create p_5
this.Control[]={this.st_comment,&
this.st_desc,&
this.p_main,&
this.p_1,&
this.p_2,&
this.p_3,&
this.p_4,&
this.p_5}
end on

on uo_pictures.destroy
destroy(this.st_comment)
destroy(this.st_desc)
destroy(this.p_main)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_5)
end on

type st_comment from statictext within uo_pictures
boolean visible = false
integer x = 457
integer y = 88
integer width = 855
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type st_desc from statictext within uo_pictures
integer x = 343
integer y = 960
integer width = 1129
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type p_main from picture within uo_pictures
integer x = 338
integer y = 24
integer width = 1134
integer height = 920
string dragicon = "DataWindow5!"
boolean dragauto = true
boolean focusrectangle = false
end type

type p_1 from picture within uo_pictures
integer x = 9
integer y = 20
integer width = 288
integer height = 216
boolean focusrectangle = false
end type

event clicked;parent.trigger event ue_load_picture(this.PowerTipText)

end event

type p_2 from picture within uo_pictures
integer x = 9
integer y = 252
integer width = 288
integer height = 216
boolean focusrectangle = false
end type

event clicked;parent.trigger event ue_load_picture(this.PowerTipText)
end event

type p_3 from picture within uo_pictures
integer x = 9
integer y = 484
integer width = 288
integer height = 216
boolean focusrectangle = false
end type

event clicked;parent.trigger event ue_load_picture(this.PowerTipText)

end event

type p_4 from picture within uo_pictures
integer x = 9
integer y = 716
integer width = 288
integer height = 216
boolean focusrectangle = false
end type

event clicked;parent.trigger event ue_load_picture(this.PowerTipText)
end event

type p_5 from picture within uo_pictures
integer x = 9
integer y = 948
integer width = 288
integer height = 216
boolean focusrectangle = false
end type

event clicked;parent.trigger event ue_load_picture(this.PowerTipText)
end event

