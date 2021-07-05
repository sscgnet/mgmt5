HA$PBExportHeader$w_forms_document.srw
forward
global type w_forms_document from window
end type
type rte_document from richtextedit within w_forms_document
end type
end forward

global type w_forms_document from window
integer width = 2432
integer height = 1428
boolean titlebar = true
string title = "Document"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
rte_document rte_document
end type
global w_forms_document w_forms_document

on w_forms_document.create
this.rte_document=create rte_document
this.Control[]={this.rte_document}
end on

on w_forms_document.destroy
destroy(this.rte_document)
end on

event close;rte_document.SelectTextAll()
CloseWithReturn(this,rte_document.CopyRtf())
end event

event open;rte_document.PasteRTF(message.stringparm)
end event

type rte_document from richtextedit within w_forms_document
integer x = 37
integer y = 40
integer width = 2309
integer height = 1236
integer taborder = 10
boolean init_toolbar = true
borderstyle borderstyle = stylelowered!
end type

