@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION
IF not exist "v:\startup" mkdir "v:\startup"
IF not exist "v:\VDImproved\startup_VDImp.bat" (GOTO:_MISSING)
COPY /Y "v:\VDImproved\startup_VDImp.bat" "v:\startup\"
GOTO:_RUN

:_MISSING
ECHO Required file(s) missing, check log for more info
ECHO Check that all files were downloaded and extracted corectly
PAUSE
GOTO:_FAIL1


:_FAIL1
ECHO in _FAIL1 && pause

CALL v:\VDImproved\writeEvent.bat %0 "Install cancelled, Classque not found" "F"
GOTO:EOF

:_QUIT
ECHO in _QUIT && pause

CALL v:\VDImproved\writeEvent.bat %0 "Install failed. startup_VDImp.bat missing" "F"
GOTO:EOF

:_RUN
ECHO in _RUN && pause

CALL v:\VDImproved\writeEvent.bat "Install_VDImproved" "Install success." "P"
CALL v:\VDImproved\startup_VDImp.bat
GOTO:EOF