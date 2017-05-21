set datetimef=%date:~-4%%date:~4,2%%date:~7,2%
echo %datetimef%

md c:\projects\mgmt5\archives\s%datetimef%\
md c:\projects\mgmt5\archives\s%datetimef%\PBL\

copy c:\projects\mgmt5\mgmt.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtbill.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtcase.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtcon.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtdefault.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtexp.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtimpfile.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtinsured.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtmain.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtord.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtrpt2.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtrpt3.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtrpt.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtticket.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\mgmt5\mgmtweb.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\minipro5\auditdef.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\minipro5\audit.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\minipro5\auditrpt.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\minipro5\auditwork.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\sscglib5\sscg_comm.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\sscglib5\sscg.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\sscglib5\sscg_other.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\sscglib5\sscg_dyn.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\templates\mform.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\sscglib5\sscg_dyn3.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\sscglib5\sscg_dyn2.pbl c:\projects\mgmt5\archives\%datetimef%\PBL
copy c:\projects\sscglib5\sscg_util.pbl c:\projects\mgmt5\archives\%datetimef%\PBL

copy c:\projects\mgmt5\mgmt.exe c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtbill.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtcase.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtcon.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtdefault.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtexp.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtimpfile.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtinsured.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtmain.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtord.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtrpt2.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtrpt3.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtrpt.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtticket.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\mgmt5\mgmtweb.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\minipro5\auditdef.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\minipro5\audit.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\minipro5\auditrpt.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\minipro5\auditwork.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\sscglib5\sscg_comm.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\sscglib5\sscg.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\sscglib5\sscg_other.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\sscglib5\sscg_dyn_blank.pbd c:\projects\mgmt5\archives\%datetimef%\pbd\sscg_dyn_blank.pbd
copy c:\projects\templates\mform.pbd c:\projects\mgmt5\archives\%datetimef%\pbd
copy c:\projects\sscglib5\sscg_util.pbd c:\projects\mgmt5\archives\%datetimef%\pbd