@ echo on
:: This will run the classque based on day and time(24hr)
:: NOTE! The VDI machines have been known to randomly change from 12hour to 24 hour. If there is a problem change the GOTO's
:: Need to make GOTO based on 12 and 24 hours

v:

if exist \classque\3443-1 cd \classque\3443-1
:: TIMEOUT /T 600 /NOBREAK

FOR %%F IN (Tue Thu) DO IF %DATE:~0,3% == %%F GOTO _gTIME
GOTO _WRONGDAY


:_gTIME
IF %TIME:~0,2% GEQ 14 GOTO _lTime
GOTO _WRONGTIME


:_lTime
IF %time:~0,2% LSS 16 GOTO _FINISH
GOTO _WRONGTIME


:_WRONGDAY
CALL v:\VDImproved\write_qlog.bat "3443" "ClassQue failed. Wrong day:Must be Tue, Thu. Today: %DATE:~0,3%"
GOTO _FAIL


:_WRONGTIME
CALL v:\VDImproved\write_qlog.bat "3443" "ClassQue failed:wrong time. Current time:%TIME%"
GOTO _FAIL


:_FAIL
CALL v:\VDImproved\write_qlog.bat "3443" "ClassQue failed"
GOTO _EOF

:_FINISH
ECHO finish
pause
CALL v:\VDImproved\write_qlog.bat "3843" "ClassQue Succeeded"
start "" java -jar classque-3443-1.jar
echo "classQ launched"
pause

:_EOF
