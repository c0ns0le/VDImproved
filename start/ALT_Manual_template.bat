:: template for all classque's, it is copied and renamed to match installed classque files
:: This will run the classque based on day and time(24hr)
:: The days and times of the class are stored in v:\VDImproved\profile\%_class%.txt

:: TODO MOve to install folder and create new script that copies registry entry schtasks
::      then queries to confirm entry. 
::https://ss64.com/nt/schtasks.html
@ECHO OFF
v:
SETLOCAL ENABLEDELAYEDEXPANSION
:: in the command time:~x,y tthe x,y indicate start position and number of positions to print
:: x is numeric value 0-9 of the position to start printing
:: y is numeric value 0-9 for number of positions to print
GOTO _RUN

ALGO
GET Class time
	Read from config file: either by line, or delim. RETHINK after changes made to define_daytime_calssque.bat
		could store times as single digit h1, h2, m1, m2 per entry then recombine 
		OR store as _hour=hh and another _minute=mm
		OR store as a whole hh:mm
		OR PREFERED store h1, h2, mm for the following:
			ADJUST24HR h1, h2 into single var to make easier to do _FORMATSHIFT if PM
				if h1=0 -> _hour=h2
				else _hour=h1h2
				_hour+=12
		
		:: Idealy use SCHTASKS command, however, with the the disk image always being reset, 
		:: there is no point scheduling when it would always have to create new schedule anyway
		:: simpler to just use TIME /T command and either compare for LEQ and GEQ,
		:: TODO still need to know if it returns a leading 0
		AM or PM definintly own var as SCHTASKS uses 24 hour format
			IF AM: do _hour=h1h2 MUST CHECK if SCHTASKS uses leading 0
			OR IF PM: CALL _FORMATSHIFT

CREATE SCHTASKS to run at class time 			
			
			
			
:_RUN
::SET _class=%~nx0
@ECHO OFF

SET _class=3773
CALL :_CHECKPROFILE
::saves the current system time
FOR /F "delims=" %%T IN ('TIME /T') DO SET _currTime=%%T	

SET _currHr=%_currTime:~0,2%
SET _currMin=%_currTime:~3,2%
:: genTime is AM or PM
SET _genTime=%_currTime:~6,2%
ECHO.
ECHO currTime = %_currTime% : currHour=%_currHr% : currmin=%_currMin% : genTime=%_genTime% -:
PAUSE
:: READS the %class%.txt except the first which is the class name
:: The 2nd loop uses a CAll to compare: 
::   -day of week (function CHECKDAY)
::   -class start am or pm (function CHECKAMPM)
::   -class start hour (function CHECKSTARTHOUR)
::   -class start min (function CHECKSTARTMIN)
::   -class end am or pm (function CHECKAMPM)
::   -class end hour (function CHECKENDHOUR)
::   -class end min (function CHECKENDMIN)

SET _varList=DAY STARTAMPM START ENDAMPM END SEAT
CALL :_READFILE s
CLS
ECHO BEGIN READ and COMPARE -:
PAUSE
CALL :_VERIFY
CLS
ECHO BEGIN CREATE TASK -:
PAUSE
CALL :_CREATETASK


:: reads the file and calls code block to store or read value to each name in varList
:: based on 1st parameter passed during call, s or r respectively
:_READFILE
REM ECHO.
REM ECHO.
REM ECHO ---%0 : para1-switch for save or read %2 : varList is %_varList% -:
REM PAUSE
SET _lineNumIn=1
FOR /F "SKIP=1 delims=;" %%G in (v:\VDImproved\profile\%_class%.txt) DO (
::TODO MOVE INSIDE func SAVE
		REM ECHO.
		REM ECHO.
		REM ECHO IN loop G-lineRead is %%G -:
		REM PAUse
		IF %1==s CALL :_VARS "%%G" s
		IF %1==r CALL :_VARS "%%G" r
		REM ECHO.
		REM ECHO.
		REM ECHO back in G
		REM PAUSE
		SET /a _lineNumIn=!_lineNumIn!+1
	)
EXIT /B 0

:: This code block uses the 2nd parameter 
:: paramters- 1st is the line read from file- 2nd is switch to either save value to, or read value from list
:: varList is the list of variables corresponding to a line from the file read which provides its value.
:: %%G var is the user defined var read from file
:: the lineNumIn and count are used to match appropriate var name with it's value
:: the exit /B 0 returns to previous loop G, 
:: NOTE-use of surrounding !'s causes delayed expansion of variable name, req'd inside loops 
::     -to properly display a vars value
:_VARS
SET _count=1
REM ECHO.
REM ECHO.
REM ECHO ---%0 : para1-lineRead is %1 : para2-switch for save or read is %2 : lineNumIn is %_lineNumIn% :
REM ECHO varList is %_varList% -:
REM PAUSE
FOR %%Y IN (%_varList%) DO (
		REM ECHO.
		REM ECHO.
		REM ECHO IN loop Y : p1 -lineRead is %1 : lineNumIn is %_lineNumIn% : count is !_count! : y is %%Y -:
		REM PAUSE
		IF %_lineNumIn% EQU !_count! (
			IF /I %2==s SET _%%Y=%~1
			IF /I %2==r CALL :_COMPARE %1 "!_%%Y!"
			REM ECHO.
			REM ECHO _%%Y is !_%%Y!  -:
			REM ECHO ABout to exit Y -:
			REM PAUSE
			EXIT /B
		)
	
			REM ECHO.
			REM ECHO Cont'ing to loop thru Y -:
			REM PAUSE
		
	SET /a _count=!_count!+1
)
REM echo.
REM ECHO.	
EXIT /B

:: Validates that all information was stored correctly. 
:: calls the _READFILE, code block with the r switch 
:: which reads from file and compares each line to _varList values
:_VERIFY
REM ECHO.
REM ECHO.
REM ECHO ---%0 -:
REM PAUSE
SET _valid=T
CALL :_READFILE r
IF /I %_valid%==F (
	REM ECHO.
	REM ECHO.
	REM ECHO value mismatch in VERIFY  valid is %_valid% should be F -:
	REM PAUSE
	CALL :_EVENT "F"
	GOTO :_EOF
)
IF /I %_valid%==T (
	ECHO.
	ECHO.
	ECHO all values confirmed  valid is %_valid%  should T -:
	PAUSE
	CALL :_EVENT "Profile successfully read and saved" "P"
	)
ECHO.
ECHO.
ECHO END VERIFY~~~~ RETURN TO RUN -:
PAUSE	
EXIT /B 0		

:: compares string values. writes to _EVENT if mismatch(s) found
:: and on successful compare of all values. 
:: paramters- 1st is the line read from file- 2nd is value from _varList
:_COMPARE
REM ECHO.
REM ECHO.
REM ECHO ---%0 : para1-lineRead is %1 : para2-value from varList %2 -:
REM PAUSE
IF /I %1==%2 EXIT /B 0
IF /I NOT %1==%2 (
	SET _valid=F
	ECHO.
	ECHO.
	ECHO value mismatch from read/stored value %2: should be %1 -:
	PAUSE
	CALL :_EVENT "value mismatch from read/stored value %2: should be %1" "F"
	)
EXIT /B 0


:: DAY STARTAMPM START ENDAMPM END SEAT
:_CREATETASK
@ECHO ON
ECHO.
ECHO.
ECHO ---%0 -:
PAUSE
SET _task=SCHTASKS /Create /SC weekly /D %_DAY% /TN ClassQ%_class% /ST %_START% /TR v:\classque\%_class%-2\run%_class%-2.bat /ET %_END%
::SCHTASKS /Create /SC weekly /D TUE /TN ClassQ3773 /ST %_START% /TR v:\classque\%_class%-2\run%_class%-2.bat /ET %_END%
ECHO.
ECHO.
ECHO attempt to run cmd
PAUSE
CMD /C "%_task%"
PAUSE
:: TODO would like to add a check on the output of the schtask command. Having issue with it running in the for loop. 
REM FOR /F %%b IN ('%_task%') DO (
	REM ECHO.
	REM ECHO.
	REM ECHO in loop B
	REM PAUSE
	REM ECHO.
	REM ECHO Task output is %%b -:
	REM PAUSE
	REM IF /F %%b==error: CALL :_EVENT "Unknown error during scheduling:%%b" "F"
	REM IF /I %%b==success: CALL :_EVENT P
REM )
GOTO :_EOF

:_EVENT
REM ECHO ---%0
REM ECHO Param1= %1
REM ECHO Param2= %2
REM PAUSE
CALL v:\VDImproved\writeEvent.bat %~n0 %1 %2
IF %1==F CALL v:\VDImproved\writeEvent.bat %~n0 "Profile did not read or save correctly" "F"
IF %1==P CALL v:\VDImproved\writeEvent.bat %~n0 "ClassQ%_class% successfully sccheduled" "P"
EXIT /B 0

:: Must only be used with CALL
:_CHECKPROFILE
ECHO ---%0 or CHECKPROFILE?
PAUSE
IF NOT EXIST "v:\VDImproved\profile\%_class%.txt" (
	CALL :_PROFILE 
	EXIT /B 0
)
EXIT /B 1
ECHO DEBUG SHOULD NEVER DISPLAY
PAUSE
:_PROFILE
ECHO ---%0 or PROFILE?
PAUSE
CALL "v:\VDImproved\install\define*classque.bat" %_class%
IF %ERRORLEVEL% equ 15 (
	GOTO:_EVENT "There is an issue with the profile, please check logs" "F"  
)
IF %ERRORLEVEL% equ 0 (
	EXIT /B 0
)
ECHO DEBUG REMOVE SHOULD NEVER DISPLAY
PAUSE


::EOF
:_EOF
CLS
ECHO %~n0 EOF
PAUSE
EXIT /B 0
