set datetimef=%date:~-4%%date:~4,2%%date:~7,2%
echo %datetimef%

md c:\projects\mgmt5\archives\s%datetimef%\
md c:\projects\mgmt5\archives\s%datetimef%\PBL\
md c:\projects\minipro5\archives\s%datetimef%\
md c:\projects\minipro5\archives\s%datetimef%\PBL\
md c:\projects\sscglib5\archives\s%datetimef%\
md c:\projects\sscglib5\archives\s%datetimef%\PBL\

copy I:\program10\mgmt5\mgmt.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtbill.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtcase.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtcon.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtdefault.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtexp.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtimpfile.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtinsured.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtmain.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtord.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtrpt2.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtrpt3.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtrpt.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtticket.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mgmtweb.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL
copy I:\program10\mgmt5\mform.pbl c:\projects\mgmt5\archives\s%datetimef%\PBL

copy I:\program10\mgmtmini\auditdef.pbl c:\projects\minipro5\archives\s%datetimef%\PBL
copy I:\program10\mgmtmini\audit.pbl c:\projects\minipro5\archives\s%datetimef%\PBL
copy I:\program10\mgmtmini\auditrpt.pbl c:\projects\minipro5\archives\s%datetimef%\PBL
copy I:\program10\mgmtmini\auditwork.pbl c:\projects\minipro5\archives\s%datetimef%\PBL

copy I:\program10\sscg_comm.pbl c:\projects\sscglib5\archives\s%datetimef%\PBL
copy I:\program10\sscg.pbl c:\projects\sscglib5\archives\s%datetimef%\PBL
copy I:\program10\sscg_other.pbl c:\projects\sscglib5\archives\s%datetimef%\PBL
copy I:\program10\sscg_dyn.pbl c:\projects\sscglib5\archives\s%datetimef%\PBL
copy I:\program10\sscg_dyn3.pbl c:\projects\sscglib5\archives\s%datetimef%\PBL
copy I:\program10\sscg_dyn2.pbl c:\projects\sscglib5\archives\s%datetimef%\PBL
copy I:\program10\sscg_util.pbl c:\projects\sscglib5\archives\s%datetimef%\PBL
