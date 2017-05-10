@ECHO OFF
:: starts Xming to be used with SSH. SSH must be configured for use with x11 tunneling
:: adds success or failure to log file
SETLOCAL ENABLE DELAYEDEXPANSION
C:

CLS
:CONFIRM
ECHO.
ECHO.
ECHO Would you like to run Xming? 
ECHO Y to run Xming
ECHO N to exit
ECHO.
set /P confirm="Enter Y or N: "
echo --------------------------------------------------------------------
for %%I in (Y N) do if /I #%confirm%==#%%I goto _%%I
IF NOT DEFINED %confirm% (GOTO:CONFIRM)
:: exits back to Install_VDImproved with errorlevel set to 0
:: this will continute with the install process
:_Y
REM ECHO confirm is %confirm% 
REM pause
EXIT /B 0

:: exits back to Install_VDImproved with errorlevel set to 1
:_N
REM ECHO confirm is %confirm% 
REM pause
EXIT /B 1

cd \Program Files (x86)\Xming\
START "" Xming.exe :0 -clipboard -multiwindow && (
GOTO:_PASS
)||(
GOTO:_FAIL
)

:_PASS
CALL v:\VDImproved\writeEvent.bat "login-Xming" "Xming started!" "P"
GOTO:_EOF

:_FAIL
CALL v:\VDImproved\writeEvent.bat "login-Xming" "failed to start" "F"


:_EOF
