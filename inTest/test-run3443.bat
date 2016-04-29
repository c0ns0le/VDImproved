@ echo on
:: This will run the classque based on day and time(24hr)
:: NOTE! The VDI machines have been known to randomly change from 12hour to 24 hour. If there is a problem change the GOTO's
:: Need to make GOTO based on 12 and 24 hours

v:
pause
if exist \classque\3443-1 cd \classque\3443-1
echo first
pause
:: TIMEOUT /T 600 /NOBREAK

FOR %%F IN (Tue Thu) DO IF %DATE:~0,3% == %%F echo "!!!!!!!!!two" & GOTO _gTIME
)||(
GOTO _FAIL
)
echo day
pause


:_gTIME
echo gtime
pause
IF %TIME:~0,2% GEQ 14 && (
echo g1
pause
GOTO _lTime
)||(
echo g2
pause
GOTO _FAIL
)


:_lTime
echo LTime
pause
IF %time:~0,2% LSS 16 GOTO _FINISH
echo L1
pause
GOTO _FAIL


:_FINISH
ECHO finish
pause
CALL v:\VDImproved\write_qlog.bat "3843" "ClassQue Succeeded"
start "" java -jar classque-3443-1.jar
echo "classQ launched"
pause
 


:_FAIL
echo FAIL
pause
CALL v:\VDImproved\write_qlog.bat "3443" "ClassQue failed"
echo "wrote to log"
pause

:: EOF
:: & GOTO _gTIME