HA$PBExportHeader$w_view_photo.srw
forward
global type w_view_photo from window
end type
type st_1 from statictext within w_view_photo
end type
type p_1 from picture within w_view_photo
end type
type p_preview from picture within w_view_photo
end type
end forward

global type w_view_photo from window
integer width = 3195
integer height = 2188
boolean titlebar = true
boolean controlmenu = true
boolean resizable = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
st_1 st_1
p_1 p_1
p_preview p_preview
end type
global w_view_photo w_view_photo

type variables
string is_picture
end variables

on w_view_photo.create
this.st_1=create st_1
this.p_1=create p_1
this.p_preview=create p_preview
this.Control[]={this.st_1,&
this.p_1,&
this.p_preview}
end on

on w_view_photo.destroy
destroy(this.st_1)
destroy(this.p_1)
destroy(this.p_preview)
end on

event open;is_picture = message.stringparm
p_1.picturename = is_picture
Messagebox("",string(p_1.height) + " X " + string(p_1.width))
IF p_1.height > p_preview.height THEN
	p_preview.width = integer((p_preview.height/p_1.height) * p_1.width)
	w_view_photo.height = p_preview.height + 200
	w_view_photo.width = p_preview.width + 150
	p_1.picturename = ""
ELSE
	p_preview.height = integer((p_preview.width/p_1.width) * p_1.height)
	w_view_photo.height = p_preview.height + 200
	w_view_photo.width = p_preview.width + 150
	p_1.picturename = ""
END IF
this.title = message.stringparm
p_preview.picturename = is_picture

end event

event resize;p_preview.height = this.height - 200
p_preview.width = this.width - 150
end event

type st_1 from statictext within w_view_photo
integer x = 73
integer y = 32
integer width = 731
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 67108864
string text = "NOTE:  Doubleclick Photo to Edit"
boolean border = true
borderstyle borderstyle = StyleShadowBox!
boolean focusrectangle = false
end type

type p_1 from picture within w_view_photo
boolean visible = false
integer x = 73
integer y = 2072
integer width = 2048
integer height = 2016
boolean enabled = false
boolean originalsize = true
boolean border = true
boolean focusrectangle = false
end type

type p_preview from picture within w_view_photo
integer x = 73
integer y = 32
integer width = 2999
integer height = 2016
boolean border = true
boolean focusrectangle = false
end type

event doubleclicked;run_file(is_picture)
close(w_view_photo)

end event

