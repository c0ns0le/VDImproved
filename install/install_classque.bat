::NOT NEEDED just call find_classque

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
:: in calling script CALL v:\VDImproved\writeEvent.bat "%0" "No clasque files found" "F"
EXIT /B 2
:_EOF
ENDLOCAL