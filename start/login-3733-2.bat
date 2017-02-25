@ECHO OFF
:: CREATE template for all classque
:: take name is a parameter, CREATE NEW script to ask for time/day
::
:: This will run the classque based on day and time(24hr)
:: NOTE! The VDI machines have been known to randomly change from 12hour to 24 hour. If there is a problem change the GOTO's
:: Need to make GOTO based on 12 and 24 hours

v:
if exist \classque\3843 cd \classque\3843
:: add auto generate to search dir and copy names of clasque sub folders
:: add new .bat to open cmd to enter days M,T,W,Th,F and start end time
FOR %%F IN (Mon Wed) DO IF %DATE:~0,3% == %%F GOTO:_TIME
GOTO:_WRONGDAY


:_TIME
IF %time:~0,2% GEQ 15 GOTO:_PASS else GOTO:_WRONGTIME


:_PASS
IF %time:~0,2% LEQ 17 GOTO:_Fin else GOTO:_WRONGTIME


:_WRONGDAY
CALL v:\VDImproved\writeEvent.bat "3843 ClassQ" "Wrong day" "F"
GOTO:_FAIL


:_WRONGTIME
CALL v:\VDImproved\writeEvent.bat "3843 ClassQ" "Wrong time" "F"
GOTO:_FAIL


:_FAIL
CALL v:\VDImproved\writeEvent.bat "3843 ClassQ" "Attendance not recorded" "F"
GOTO:EOF


::below will end classque processes, forcibly if process is running
:_Fin  
START "DIE " "v:\VDImproved\start\DieJavaDie.bat" && GOTO:_RUNQ


:_RUNQ
CMD java -jar classque-3843.jar && CALL v:\VDImproved\writeEvent.bat "3843" "Attendance recorded" "P"


::EOF