::check if dir T
::	call find classque
::		save list of classques
::		for each, copy file template to VDImp/start and rename


::	exit error level 2 indicates no classque files found
		
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT EXIST v:\classque GOTO:_NOTFOUND
CALL v:\VDImproved\install\find_classque.bat



:_NOTFOUND
CALL v:\VDImproved\writeEvent.bat "%0" "No clasque files found" "F"

:_EOF
ENDLOCAL