@ECHO ON
:: provides formating for all success or failure events from various login and
::	and logout bat files. Includes the date and time of each event

:: Setlocal EnableDelayedExpansion

v:
pause 

if not exist \VDImproved\logs\ then mkdir \VDImproved\logs\
set _ctime=%DATE:~0,9%-%TIME:~0,5%
ECHO %*
echo %0 %1 %2 %3 %4
ECHO HI
PAUSE
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
PAUSE
GOTO:_EOF

:_EOF 
:: EOF
