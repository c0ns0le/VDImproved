@ echo on
:: This will run the classque based on day and time(24hr)
:: NOTE! The VDI machines have been known to randomly change from 12hour to 24 hour. If there is a problem change the GOTO's
:: Need to make GOTO based on 12 and 24 hours

v:
if exist \classque\3443-1 cd \classque\3443-1
ECHO start & pause

FOR %%F IN (Tue Thu) DO IF %DATE:~0,3% == %%F GOTO:_gTIME
GOTO:_WRONGDAY


:_gTIME
IF %TIME:~0,2% GEQ 14 GOTO :_lTime
GOTO:_WRONGTIME


:_lTime
IF %time:~0,2% LSS 16 GOTO:_FIN
GOTO:_WRONGTIME


:_WRONGDAY
CALL v:\VDImproved\writeEvent.bat "3443 ClassQ" "Wrong day" "F"
GOTO:_FAIL


:_WRONGTIME
CALL v:\VDImproved\writeEvent.bat "3443 ClassQ" "Wrong time." "F"
pause
GOTO:_FAIL


:_FAIL
CALL v:\VDImproved\writeEvent.bat "3443 ClassQ" "Attendance not recorded" "F"
pause
GOTO:_EOF

:_FIN
START "DIE " "v:\VDImproved\start\DieJavaDie.bat" & GOTO:_RUNQ


:_RUNQ

CMD /C java -jar classque-3443-1.jar && 
pause
CALL v:\VDImproved\writeEvent.bat "3443" "Attendance recorded" "P"



:_EOF
::EOF