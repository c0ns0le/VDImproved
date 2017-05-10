@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

::opens cmd window asking user if they want to install without classque being installed
v:
CLS
:CONFIRM
ECHO.
ECHO.
ECHO CLassque should be installed first. 
ECHO To continue without installing Classque enter Y or N to exit
ECHO.
set /P confirm="Enter a choice: "
echo --------------------------------------------------------------------
for %%I in (Y N) do if /I #%confirm%==#%%I goto _%%I
IF NOT DEFINED %confirm% (GOTO:CONFIRM)

:: exits back to Install_VDImproved with errorlevel set to 0
:: this will continute with the install process
:_Y
REM ECHO confirm is %confirm% 
REM pause
LOCAL&EXIT /B 0

:: exits back to Install_VDImproved with errorlevel set to 1
:_N
REM ECHO confirm is %confirm% 
REM pause
ENDLOCAL&EXIT /B 1