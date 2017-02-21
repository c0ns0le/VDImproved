@ECHO off
::check for dir v:/startup and startup.bat was created by classque
::check that startup_VDImp exists
::copy the VDImproved/startup_VDImp.bat to the startup/ folder
::log success or fail

v:
:: Install Classque first
SETLOCAL ENABLEDELAYEDEXPANSION
IF not exist V:\classque (
ECHO classQ not exist && pause
GOTO:_CONFIRM
) else (
ECHO classQ exist && pause
GOTO:_CONTINUE
)

::Checks with user to install if classque is not installed
:_CONFIRM
ECHO in _CONFIRM && pause

CALL v:\VDImproved\install\no_classque.bat 
ECHO err level is %errorlevel%
PAUSE
IF %errorlevel% NEQ 0 (
GOTO:_QUIT
) || (
GOTO:_ALT
)

:_ALT
ECHO in ALT
pause
IF not exist "v:\startup" mkdir "v:\startup"
GOTO:_REQFILE

:_CONTINUE
ECHO in _CONTINUE && pause
IF not exist "v:\startup" (
ECHO Classque not installed properly, install will exit
PAUSE
GOTO:_QUIT
) 
GOTO:_REQFILE

:_REQFILE
ECHO in _REQFILE && pause
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