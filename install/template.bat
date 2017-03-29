:: template for all classque's, it is copied and renamed to match installed classque files
:: This will run the classque based on day and time(24hr)
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
			
			
			
SET _sysTimeHr=%time:~0,2%
SET _sysTimeMin=%time:~3,2%

SET "_days="
SET "_time="
FOR %%F IN (_days) DO (
	IF %DATE:~0,3% == %%F PAUSE&GOTO:_TIME
)
GOTO:_WRONGDAY


:_TIME
:: checks hour then minute

pause
IF %time:~0,2% GEQ 15 
GOTO:_PASS else GOTO:_WRONGTIME


:_PASS
IF %time:~0,2% LEQ 17 GOTO:_Fin else GOTO:_WRONGTIME


:_WRONGDAY
CALL v:\VDImproved\writeEvent.bat %~n0 "Wrong day" "F"
GOTO:_FAIL


:_WRONGTIME
CALL v:\VDImproved\writeEvent.bat %~n0 "Wrong time" "F"
GOTO:_FAIL


:_FAIL
CALL v:\VDImproved\writeEvent.bat %~n0 "Attendance not recorded" "F"
GOTO:EOF


::below will end classque processes, forcibly if process is running
:_Fin  
START "DIE " "v:\VDImproved\start\DieJavaDie.bat" && GOTO:_RUNQ


:_RUNQ
CMD java -jar classque-3843.jar && CALL v:\VDImproved\writeEvent.bat "3843" "Attendance recorded" "P"


::EOF