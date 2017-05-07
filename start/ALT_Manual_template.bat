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
::saves the current system time
FOR /F "delims=" %%T IN ('TIME /T') DO SET _currTime=%%T	

SET _currHr=%_currTime:~0,2%
SET _currMin=%_currTime:~3,2%
:: genTime is AM or PM
SET _genTime=%_currTime:~6,2%
ECHO currTime = %_currTime%, currHour=%_currHr%, currmin=%_currMin%, genTime=%_genTime%:
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


:: to determine if calssque should be run by setting lower and upper bounds 
SET _count=1
FOR /F "SKIP=1 delims=;" %%G in (v:\VDImproved\profile\%_class%.txt) DO (
::TODO MOVE INSIDE func SAVE
	FOR %%Y IN (DAY STARTAMPM START ENDAMPM END SEAT) DO (
		ECHO IN for g is %%G, y is %%Y
		PAUSE
		CALL :_SAVE "%%G" %%Y
	)
	SET /a _count=!_count!+1
)

:: Days of the week saved to _DAY. %%G var is the user defined var read from file
:: the exit /B 0 returns to loop, current value is within user set range 
:_SAVE
ECHO ---%0, %1, %2 %_count% :
PAUSE
FOR /L %%T IN (1, 6, 1) DO (
	IF %_count% EQU %%T (
		PAUSE
		SET _%2=%1
		ECHO days is !_%2!  :
		EXIT /B 0
		PAUSE
		)
		echo fin if
		PAUSE
)
REM CALL :_EVENT "Mismatch day of week:%DATE:~0,3% req'd %%H" F
REM GOTO:_EOF

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


:_RUNCQ
CMD java -jar classque-3843.jar && CALL v:\VDImproved\writeEvent.bat "3843" "Attendance recorded" "P"


::EOF
:_EOF
EXIT /B 0
