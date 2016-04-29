@echo on
echo tasklist /FI "IMAGENAME eq chrome.exe" | findstr "chrome.exe" > null
pause

tasklist /FI "IMAGENAME eq chrome.exe" | findstr "chrome.exe" > null

pause
if %ERRORLEVEL% NEQ 1 taskkill /FI "IMAGENAME eq chrome.exe" /T /F &&(
echo norun &goto _NORUN
)||(
echo run& goto _RUN
) 

:_NORUN
::pause
echo no killing
START "CAKE" cmd /k v:\VDImproved\write_qlog.bat "runtest" "chrome not running"
exit

:_RUN
::pause
echo killed it
START "DEATH" cmd /K  v:\VDImproved\write_qlog.bat "runtest" "killed chrome"
exit