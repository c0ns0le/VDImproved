:: template for all classque's, it is copied and renamed to match installed classque files
:: This will run the classque based on day and time(24hr)
:: The days and times of the class are stored in v:\VDImproved\profile\%_class%.txt

:: NOTE! The VDI machines have been known to randomly change from 12hour to 24 hour. 
:: TODO If there is a problem change the GOTO's numbers to either 12 or 24 format
:: Need to make GOTO based on 12 and 24 hours
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
ECHO ON

SET _class=3773
CALL :_CHECKPROFILE
SET currTime=<<TIME /T	
SET _currHr=%currTime:~0,2%
SET _currMin=%currTime:~3,2%
::CURIOUS about the double quotes as compd to above
SET _tempDay=<<DATE /T
SET _currDay=%_tempDay:~0,3%

:: READS the %class%.txt except the first which is the class name
:: The 2nd loop uses a CAll to compare: day, class start(am or pm, time), class end(am or pm, time)
:: to determine if calssque should be run. 
FOR /F "SKIP=1,delims=;" %%G in (v:\VDImproved\profile\%_class%.txt) DO (
	
	FOR /L %%Y IN (1,7,1) DO (
		CALL :_CHECK%%Y
		IF %ERRORLEVEL%==1 GOTO 
	)
	
	
	
	"%_class%" "%_days%" "%_startAP%" "%_startHour%:%_startMin%" "%_endAP%" "%_endHour%:%_endMin%" "%_seat%") DO (
		ECHO in for's X=%%X, Y=%%Y, valid=!_valid!:
		PAUSE
		IF  "%%X"==%%Y (
			SET _valid=T
			ECHO valid=T
			PAUSE
			)
		
	)
	IF !_valid!==F (
		ECHO MISMATCH in valid=f
		PAUSE
		SET _Msg1="Create Profile"
		SET _Msg2="Profile data mismatch: %%X"
		SET _Msg3=F
		CALL :_EVENTLOG
		)
)
::END FILE READ and compare
IF %_valid%==T (
		ECHO File read valid=T
		pause		
		SET _Msg1="Create Profile:%0"
		SET _Msg2="Profile data validated"
		SET _Msg3=P
		CALL :_EVENTLOG
		ECHO finished validation&PAUSE
		CALL :_RETURN "been saved" "P" 0
		)
		
	
)

:: Compares for correct day of the week. 
:_CHECK1
FOR %%D in (%%Y) DO (
	If %DATE:~0,3%==%%D 
	EXIT /B 0
)
CALL :_EVENT "Mismatch day of week:%DATE:~0,3% req'd %%D" F


::LOGIC IS FLAWED SECOND FOR LOOPS thru everything on first loop pass, everything on second loop pass
FOR /F %%F IN (v:/) DO (
	IF %DATE:~0,3% == %%F PAUSE&GOTO:_TIME
)
GOTO:_EVENT


:_TIME
:: checks hour then minute

pause
IF %time:~0,2% GEQ 15 
GOTO:_PASS else GOTO:_WRONGTIME


:_PASS
IF %time:~0,2% LEQ 17 GOTO:_Fin else GOTO:_WRONGTIME


:_EVENT
ECHO ---%0
ECHO Param1= %1
ECHO Param2= %2
PAUSE
CALL v:\VDImproved\writeEvent.bat %~n0 %1 %2
IF %2==F CALL v:\VDImproved\writeEvent.bat %~n0 "Attendance not recorded" "F"
IF %2==P CALL v:\VDImproved\writeEvent.bat %~n0 "Attendance recorded" "P"
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
ECHO DEBUG REMOVE SHOULD NEVER DISPLAY
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


::below will end classque processes, forcibly if process is running
:_Fin  
START "DIE " "v:\VDImproved\start\DieJavaDie.bat" && GOTO:_RUNQ


:_RUNQ
CMD java -jar classque-3843.jar && CALL v:\VDImproved\writeEvent.bat "3843" "Attendance recorded" "P"


::EOF