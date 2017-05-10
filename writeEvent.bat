@ECHO off
:: provides formating for all success or failure events from various login and
::	and logout bat files. Includes the date and time of each event

:: Setlocal EnableDelayedExpansion will cause each variable to be expanded at execution time rather than at parse time
:: Scan from left if % found and 
:: 1st	 IF followed by a % (A double %% )then replace both with a single %
:: 2nd  Else if followed by * (%*)and command extensions are enabled then
:: Replace %* with the text of all command line arguments

:: 3rd Expansion of argument variables (%1, %2, etc.)
:: 3rd Expansion of %var%, if var does not exists replace it with nothing
SETLOCAL ENABLEDELAYEDEXPANSION
v:


if not exist \VDImproved\logs\ then mkdir \VDImproved\logs\
set _ctime=%DATE:~0,9%-%TIME:~0,5%
REM ECHO  current script is %*
REM echo %0 %1 %2 %3 %4 END VARS
REM PAUSE
::below is for debugging uncomment to use
::echo  Para = %3
if %3 == "P" GOTO:_PASS else GOTO:_FAIL  

:: Fail tells it to print the originating bat file operations failed
:_FAIL
set _F=F
set _P=  

::below is for debugging uncomment to use
::echo  FAIL = %_F% -- PASS= %_P%
GOTO:_PRINT
:: Tells it to print the originating bat file operations succeded

:_PASS
set _P=P
set _F=  
::below is for debugging uncomment to use
::echo  FAIL = %_F% -- PASS= %_P%
GOTO:_PRINT 


:_Print
echo START---------------------------------------------------->> "v:\VDImproved\logs\eventlog.txt"  
echo.>> "v:\VDImproved\logs\eventlog.txt"  
>>"v:\VDImproved\logs\eventlog.txt"  echo Day-Time		Success		Fail		File: MSG		 
>>"v:\VDImproved\logs\eventlog.txt"  echo %_ctime%		%_P%		%_F%		%1: %2
echo.>> "v:\VDImproved\logs\eventlog.txt"  
echo END------------------------------------------------ >> "v:\VDImproved\logs\eventlog.txt"  
::blank line
echo.>> "v:\VDImproved\logs\eventlog.txt"  
GOTO:_EOF

:_EOF 
ENDLOCAL&EXIT /B 0
:: EOF
