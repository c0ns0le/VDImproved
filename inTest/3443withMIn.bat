v:
cd \classque\3443-1
:: TIMEOUT /T 600 /NOBREAK

SET  now = "%time /T time:~0,5%" 
SET target = "03:50" 
pause
echo %now%
echo "%target%"
pause
FOR %%F IN (Tue Thu) DO IF %DATE:~0,3% == %%F GOTO gTIME
GOTO FAIL

:gTIME
IF %time:~0,2% GEQ 2 GOTO lTime


:lTime
SET  now = "%time /T time:~0,5%" 
SET target = "03:50" 
pause
echo now
pause
IF "%time /T time:~0,5%" <= "03:50" GOTO FINISH

:FINISH
start /B java -jar classque-3443-1.jar
exit -b



:FAIL
echo failed
pause
exit -b