HA$PBExportHeader$uo_rapidsketch.sru
forward
global type uo_rapidsketch from nonvisualobject
end type
end forward

global type uo_rapidsketch from nonvisualobject
event type boolean ue_start ( string ls_fname )
event type integer ue_complete ( )
event ue_getdata ( )
event ue_savedata ( string ls_num )
event type integer ue_cancel ( )
event ue_register ( boolean lb_reg )
event type string ue_getregister ( string ls_tserial )
event type string ue_convertreg ( string ls_tserial )
end type
global uo_rapidsketch uo_rapidsketch

type variables
OLEObject oRapidSketch
String ls_filename, is_data, is_fdata
Boolean lb_save = FALSE

end variables

event type boolean ue_start(string ls_fname);integer result, li
string ls_path

this.trigger event ue_register(TRUE)
ls_filename = ls_fname
result = oRapidSketch.ConnectToNewObject("RSIntegration.RapidSketchIntegration.1")

	IF result < 0 THEN
		Messagebox("RapidSketch","Error loading object-Error#" + string(result))
	ELSE

		this.trigger event ue_getdata()
		IF ISNULL(is_data) THEN is_data = ""
		oRapidSketch.Data = is_data
		oRapidSketch.ApplicationName = "SSCG Software"
		IF oRapidSketch.OpenRapidSketch THEN 
			FOR li = 1 to Long(ProfileSTring(gs_ini,"RapidSketch","Timer","10000"))
				Yield()
			NEXT
			RETURN TRUE
		END IF
	END IF

RegistryGet ("HKEY_LOCAL_MACHINE\Software\Utilant, LLC\RapidSketch", "Path", RegString!, ls_path)
IF FileExists(ls_path) THEN
	Messagebox("Rapid Sketch",ls_path + " could not load")
ELSE
	IF ISNULL(ls_path) THEN ls_path = ""
	Messagebox("Rapid Sketch",ls_path + " could not be found")
END IF
	

RETURN FALSE
end event

event type integer ue_complete();Integer li, li_count = 0
Boolean lb_savefile = TRUE
OLEObject li_pages[]
li_pages[] = oRapidSketch.Pages

this.trigger event ue_register(FALSE)

FOR li = LowerBound(li_pages) TO Upperbound(li_pages)
	li_count += 1
	IF lb_savefile THEN
		IF FileExists(ls_filename + string(li) + ".jpg") THEN
			IF Messagebox("Rapid SKetch","File already exists, do you wish to overwrite", Question!, &
				YesNo!,2) = 2 THEN lb_savefile = FALSE
		END IF
		IF lb_savefile THEN
			IF ISNULL(ls_filename) THEN
				Messagebox("Rapid Sketch","No filename specified")
			ELSE
				IF ProfileString(gs_ini,"RapidSketch","SaveFile","YES") = "YES" THEN
					IF li_pages[li].SaveRapidSketchFile(ls_filename + string(li) + ".rs") <> - 1 THEN
						Messagebox("Rapid Sketch",ls_filename + string(li) + ".rs can not be saved")
					END IF				
				END IF
				IF ProfileString(gs_ini,"RapidSketch","SaveJPG","YES") = "YES" THEN
					IF li_pages[li].SaveImage(ls_filename + string(li) + ".jpg") <> - 1 THEN
						Messagebox("Rapid Sketch",ls_filename + string(li) + ".jpg can not be saved")
					END IF
				END IF
			END IF
		END IF
	END IF
	//IF li_pages[li].SaveRapidSketchFile(ls_filename + string(li) + ".rs") <> - 1 THEN
		//Messagebox("Rapid Sketch",ls_filename + string(li) + ".rs can not be saved")
	//END IF
NEXT
IF NOT lb_savefile THEN RETURN 0
IF li_count > 0 THEN this.trigger event ue_savedata("")

oRapidSketch.DIsconnectObject()
RETURN li_count
end event

event ue_getdata();integer li_file
string ls_new

IF lb_save THEN
IF FileExists(ls_filename + ".rsd") THEN
	li_file = FileOpen(ls_filename + ".rsd",StreamMode!,Read!)
	FileRead(li_file,ls_new)
	FileClose(li_file)
END IF

IF ISNULL(ls_new) THEN
	is_data = ""
ELSE
	is_data = ls_new
END IF
END IF
end event

event ue_savedata(string ls_num);long lstart, lend
integer li_file
string ls_new

is_data = oRapidSketch.Data

lstart = pos(is_data,"<IMAGEDATA>")
lend = pos(is_data,"</IMAGEDATA>")
ls_new = Left(is_data,lstart -1) + "<IMAGEDATA></IMAGEDATA>"
ls_new += Right(is_data,len(is_data) - (lend + 11))

is_fdata = Trim(ls_new)
IF lb_save THEN
	li_file = FileOpen(ls_filename + ls_num + ".rs",StreamMode!,Write!,LockWrite!,Replace!)
	FileWrite(li_file,ls_new)
	FileClose(li_file)
END IF

end event

event type integer ue_cancel();Integer li, li_count = 0
Boolean lb_savefile = TRUE
OLEObject li_pages[]
li_pages[] = oRapidSketch.Pages

this.trigger event ue_register(FALSE)

FOR li = LowerBound(li_pages) TO Upperbound(li_pages)
	li_count += 1
	IF lb_savefile THEN
		IF FileExists(ls_filename + string(li) + "bak.jpg") THEN
			IF Messagebox("Rapid SKetch","File already exists, do you wish to overwrite", Question!, &
				YesNo!,2) = 2 THEN lb_savefile = FALSE
		END IF
		IF lb_savefile THEN
			IF ISNULL(ls_filename) THEN
				Messagebox("Rapid Sketch","No filename specified")
			ELSE
				IF ProfileString(gs_ini,"RapidSketch","SaveFile","YES") = "YES" THEN
					IF li_pages[li].SaveRapidSketchFile(ls_filename + string(li) + "bak.rs") <> - 1 THEN
						Messagebox("Rapid Sketch",ls_filename + string(li) + "bak.rs can not be saved")
					END IF				
				END IF
				IF ProfileString(gs_ini,"RapidSketch","SaveJPG","YES") = "YES" THEN
					IF li_pages[li].SaveImage(ls_filename + string(li) + "bak.jpg") <> - 1 THEN
						Messagebox("Rapid Sketch",ls_filename + string(li) + "bak.jpg can not be saved")
					END IF
				END IF
			END IF
		END IF
	END IF
	//IF li_pages[li].SaveRapidSketchFile(ls_filename + string(li) + ".rs") <> - 1 THEN
		//Messagebox("Rapid Sketch",ls_filename + string(li) + ".rs can not be saved")
	//END IF
NEXT
IF NOT lb_savefile THEN RETURN 0
IF li_count > 0 THEN this.trigger event ue_savedata("BAK")

oRapidSketch.DIsconnectObject()
RETURN li_count
end event

event ue_register(boolean lb_reg);string ls_ruser = "", ls_rserial = ""
Integer li

IF ProfileString(gs_ini,"RapidSketch","User","") = "" THEN RETURN 
IF lb_reg THEN
	ls_ruser = set_ini("Rapid Sketch User Name","RapidSketch","User","", FALSE)
	ls_rserial = set_ini("Rapid Sketch Serial","RapidSketch","Serial","", FALSE)
	IF Left(ls_rserial,1) = "#" THEN
		ls_rserial = this.trigger event ue_getregister(ls_rserial)
		SetProfileString(gs_ini,"RapidSketch","Serial",ls_rserial)
	END IF
	ls_rserial = this.trigger event ue_convertreg(ls_rserial)
END IF


RegistrySet("HKEY_LOCAL_MACHINE\Software\Utilant, LLC\RapidSketch", "Username", RegString!, ls_ruser)
RegistrySet("HKEY_LOCAL_MACHINE\Software\Utilant, LLC\RapidSketch", "SerialNumber", RegString!, ls_rserial)
RegistrySet("HKEY_CURRENT_USER\Software\Utilant, LLC\RapidSketch", "Username", RegString!, ls_ruser)
RegistrySet("HKEY_CURRENT_USER\Software\Utilant, LLC\RapidSketch", "SerialNumber", RegString!, ls_rserial)



end event

event type string ue_getregister(string ls_tserial);string ls_rserial = ""
integer li

FOR li = 1 to len(ls_tserial)
	CHOOSE CASE Mid(ls_tserial,li,1)
	CASE "0"
		ls_rserial += "L"
	CASE "1"
		ls_rserial += "K"
	CASE "2"
		ls_rserial += "Q"
	CASE "3"
		ls_rserial += "S"
	CASE "4"			
		ls_rserial += "A"
	CASE "5"
		ls_rserial += "G"
	CASE "6"
		ls_rserial += "M"
	CASE "7"
		ls_rserial += "Z"
	CASE "8"
		ls_rserial += "0"
	CASE "9"			
		ls_rserial += "T"
	CASE "-"
		ls_rserial += "1"
	END CHOOSE
NEXT

RETURN ls_rserial
end event

event type string ue_convertreg(string ls_tserial);string ls_rserial = ""
integer li

FOR li = 1 to len(ls_tserial)
	CHOOSE CASE Mid(ls_tserial,li,1)
	CASE "L"
		ls_rserial += "0"
	CASE "K"
		ls_rserial += "1"
	CASE "Q"
		ls_rserial += "2"
	CASE "S"
		ls_rserial += "3"
	CASE "A"			
		ls_rserial += "4"
	CASE "G"
		ls_rserial += "5"
	CASE "M"
		ls_rserial += "6"
	CASE "Z"
		ls_rserial += "7"
	CASE "0"
		ls_rserial += "8"
	CASE "T"			
		ls_rserial += "9"
	CASE "1"
		ls_rserial += "-"
	END CHOOSE
NEXT
RETURN ls_rserial
end event

on uo_rapidsketch.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_rapidsketch.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;oRapidSketch = CREATE OLEObject

end event

event destructor;DESTROY oRapidSketch
end event

