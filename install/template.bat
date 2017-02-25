@ECHO OFF
:: template for all classque's
:: CREATE NEW script to ask for time/day
:: First parameter, provides check for CALL from install_VDImproved
:: 		if T -> set days and times of class. 



:: This will run the classque based on day and time(24hr)
:: NOTE! The VDI machines have been known to randomly change from 12hour to 24 hour. If there is a problem change the GOTO's
:: Need to make GOTO based on 12 and 24 hours

v:
IF %1 == I ( CALL _INSTALL)
:: add new .bat to open cmd to enter days M,T,W,Th,F and start end time
FOR %%F IN (_day) DO (
	IF %DATE:~0,3% == %%F GOTO:_TIME
	IF 
GOTO:_WRONGDAY

:: this block should only run during install to set valid run times and days

:_INSTALL
:: %2 is M, W, F
:: %3 is M, W
:: %4 is Tu, Th
:: %5 is M, T, W, Th, F
SET "_day=%2"
SET


:_TIME
IF %time:~0,2% GEQ 15 GOTO:_PASS else GOTO:_WRONGTIME


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