HA$PBExportHeader$w_recs.srw
forward
global type w_recs from w_list_ddw
end type
type uo_1 from uo_locations within w_recs
end type
type lb_titles from listbox within w_recs
end type
end forward

global type w_recs from w_list_ddw
integer width = 3104
integer height = 1880
string title = "Recommendation Selections"
boolean controlmenu = false
windowtype windowtype = child!
uo_1 uo_1
lb_titles lb_titles
end type
global w_recs w_recs

type variables
integer li_tab, li_id, li_current, li_col
string ls_help
boolean lb_new = TRUE
end variables

on w_recs.create
int iCurrent
call super::create
this.uo_1=create uo_1
this.lb_titles=create lb_titles
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.lb_titles
end on

on w_recs.destroy
call super::destroy
destroy(this.uo_1)
destroy(this.lb_titles)
end on

event open;string ls_options, ls_item = "", ls_title = "N/F", ls_mandatory
Integer lx

ls_options = message.stringparm

IF ls_options = "ALL" THEN
	lb_titles.trigger event ue_setup()
ELSE
IF pos(ls_options,"|") > 0 THEN ls_title = ""
FOR lx = 1 to len(ls_options)
	IF ls_title = "" THEN
		IF mid(ls_options,lx,1) <> "|" THEN
			ls_item += mid(ls_options,lx,1)
		ELSE
			ls_title = ls_item
			ls_item = ""
		END IF
	ELSE
		IF mid(ls_options,lx,1) = "~~" THEN
			 dw_list.insertrow(0)
			 ls_mandatory = Right(ls_item,1)
			 ls_item = Left(ls_item,len(ls_item) -1 )
			 dw_list.setitem( dw_list.rowcount(),1,ls_item)
			 dw_list.setitem( dw_list.rowcount(),2,ls_mandatory)
			ls_item = ""
		ELSE
			ls_item += mid(ls_options,lx,1)
		END IF
	END IF
NEXT
 dw_list.insertrow(0)
 dw_list.setitem( dw_list.rowcount(),1,ls_item)

IF ls_title <> "N/F" THEN this.title = "Select from following choices for " + ls_title + ":"
END IF
//uo_1.multiple(TRUE)
end event

type cb_1 from w_list_ddw`cb_1 within w_recs
integer x = 1902
integer y = 1268
integer width = 823
end type

event cb_1::clicked;close(w_recs)
end event

type cb_ok from w_list_ddw`cb_ok within w_recs
event ue_add_item ( string ls_types,  string ls_location,  string ls_building,  string ls_mandatory )
integer x = 1902
integer y = 1152
integer width = 823
end type

event cb_ok::ue_add_item(string ls_types, string ls_location, string ls_building, string ls_mandatory);integer lrec, lfield
IF w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.rowcount() = 1 THEN
	IF w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event ue_check_field( &
		w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,"none") > 0 THEN
		IF w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.object.none[1] = "y" THEN
			lrec = 1
			w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.object.none[1] = "n"
		ELSE
			IF lb_new THEN w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger &
				event ue_addnew()
		END IF	
	ELSE
			IF lb_new THEN w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger &
				event ue_addnew()
	END IF
ELSE		
	IF lb_new THEN w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger &
		event ue_addnew()
END IF
w_forms_main.i_active_sheet.u_to_open[li_tab].lb_changed = TRUE
lrec = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.rowcount()
lfield = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
	ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,ls_help)
IF lfield = 0 THEN
lfield = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
	ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,"recommendations")
END IF	
IF lfield > 0 THEN &
	w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.setitem(lrec,lfield,ls_types)
lfield = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
	ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,"mandatory")
IF lfield > 0 THEN
	lfield = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
		ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,"zlocation_99")
	IF lfield > 0 THEN &
		w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.object.zlocation_99[lrec] = ls_location
	lfield = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
		ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,"zbuilding_99")
	IF lfield > 0 THEN &
		w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.object.zbuilding_99[lrec] = ls_building
	lfield = w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.trigger event &
		ue_check_field(w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw,"idno")
    IF lfield > 0 THEN &
	 	w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.object.idno[lrec] = string(li_id)
	w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.object.mandatory[lrec] = ls_mandatory
	w_forms_main.i_active_sheet.u_to_open[li_tab].dw_defaultw.groupcalc()
END IF


end event

event cb_ok::clicked;Integer li, li_count = 0, lpos = 0, rpos, lrec, lfield
String ls_types = "", ls_question, ls_mandatory, ls_sitem

FOR li = 1 to dw_list.rowcount()
	IF dw_list.IsSelected(li) THEN
		IF li_count > 0 THEN ls_types += " "
		ls_types = dw_list.object.options[li] 
		ls_mandatory = dw_list.object.mandatory[li] 
		IF pos(ls_types,"[") > 0 AND pos(ls_types,"]") > 0 THEN
			FOR li = 1 to len(ls_types)
				CHOOSE CASE mid(ls_types,li,1)
				CASE "["
					lpos = li 
				CASE "]"
					rpos = li
					openwithparm(w_ask,ls_question + "|" + ls_types)
					IF Len(message.stringparm) > 0 THEN
						ls_types = Replace(ls_types, lpos, rpos - lpos + 1, message.stringparm)
					END IF
					lpos = 0
				CASE ELSE
					IF lpos > 0 THEN ls_question += mid(ls_types,li,1)
						//ls_question += mid(ls_types,li,1)
				END CHOOSE			
			NEXT
		END IF
		this.trigger event ue_add_item(ls_types,uo_1.get_location(),uo_1.get_building(),ls_mandatory)
		li_count += 1
	END IF
NEXT
IF li_col > 0 AND li_current > 0 THEN
	ls_sitem = w_forms_main.i_active_sheet.u_to_open[li_current].dw_defaultw.object.data[1,li_col]
	IF ISNULL(ls_sitem) THEN ls_sitem = ""
	IF ls_sitem = ""   THEN
		w_forms_main.i_active_sheet.u_to_open[li_current].dw_defaultw.setitem(1,li_col,"See Recommendations")		
	END IF
END IF
w_forms_main.i_active_sheet.ib_changed = TRUE
close(w_recs)




end event

type dw_list from w_list_ddw`dw_list within w_recs
integer x = 0
integer y = 0
integer height = 1372
end type

type uo_1 from uo_locations within w_recs
integer x = 1714
integer y = 20
integer height = 1128
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call uo_locations::destroy
end on

type lb_titles from listbox within w_recs
event ue_setup ( )
boolean visible = false
integer x = 5
integer y = 1400
integer width = 1669
integer height = 344
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_setup();integer lx, ly
boolean lb_found
w_forms_main.i_active_sheet.dw_rec_list.trigger event ue_reretrieve()
FOR lx = 1 to w_forms_main.i_active_sheet.dw_rec_list.rowcount()
	lb_found = FALSE
	FOR ly = 1 to this.totalitems()
		IF this.text(ly) = w_forms_main.i_active_sheet.dw_rec_list.object.topic[lx] THEN lb_found = TRUE
	NEXT 
	IF NOT lb_found THEN this.additem(w_forms_main.i_active_sheet.dw_rec_list.object.topic[lx])
NEXT
this.visible = TRUE
end event

event doubleclicked;Integer li
string ls_title
ls_title = this.text(index)
dw_list.reset()
FOR li = 1 to w_forms_main.i_active_sheet.dw_rec_list.rowcount()
	IF w_forms_main.i_active_sheet.dw_rec_list.object.topic[li] = ls_title THEN
		dw_list.insertrow(0)
		dw_list.object.options[dw_list.rowcount()] = w_forms_main.i_active_sheet.dw_rec_list.object.description[li]
		dw_list.object.mandatory[dw_list.rowcount()] = w_forms_main.i_active_sheet.dw_rec_list.object.mandatory[li]
	END IF
NEXT
end event

