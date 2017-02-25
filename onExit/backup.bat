:: creates backup of Office and Chrome files
::TODO add cmd preferences, desktop shortcuts, recent, or way to check recent program activity and make dynamic backup

@echo off
::TODO add pass in para to differenttiate calling func
SETLOCAL ENABLEDELAYEDEXPANSION
V:
ECHO Current file = %0
IF DEFINED %1 ( SET _chrome=%1 ) else ( SET _chrome=N )
echo %0 %1 END VARS
pause

::if TRUE chrome has already been checked and killed if needed, only copy files
:_CHECK
ECHO in check
pause
IF _chrome == C ( GOTO:_CPCHROME )
::else fallthru
ECHO fell through check
pause


::else fallthru
:: the /T and /F flags are to terminate proc with all children and forcefully terminates, respectively
::_DIECHROME 
::(ECHO in DIECHROME) && pause

:_MS
ECHO in MS
pause
IF not exist "C:\Users\%USERNAME%\AppData\Local\Microsoft\Office\15.0\" GOTO:_CPCHROME
IF not exist "v:\VDImproved\backup_restore\Microsoft\Office\15.0\" mkdir "v:\VDImproved\backup_restore\\Microsoft\Office\15.0\"
ROBOCOPY "C:\Users\%USERNAME%\AppData\Local\Microsoft\Office\15.0" "v:\VDImproved\backup_restore\Microsoft\Office\15.0" *.* /E
::for error check chsnge to GTR 7
IF %ERRORLEVEL% GRT 7 (
ECHO copy MS failed
pause
set "_err=Microsoft"
Call _FAIL !_err!
)
::else fallthru

:_CPCHROME
ECHO in chrome
pause
set "_proc=tasklist.exe /FI "IMAGENAME eq chrome.exe" "

for /F "delims=*" %%p in ('!_proc! ^| findstr "chrome.exe" ') do (
  echo found %%p
  set _running=Y
  GOTO:_KILLCHROME
)
GOTO:_EXIST

:_KILLCHROME
::IF %_running% == Y (
echo in killchrome 
pause
CALL taskkill /FI "IMAGENAME eq chrome.exe" /T /F 
::)

:_EXIST
ECHO in exist
pause
IF not exist "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\" GOTO:_EOF
IF not exist "v:\VDImproved\backup_restore\chrome\" mkdir "v:\VDImproved\backup_restore\chrome\"
ROBOCOPY "C:\Users\%USERNAME%\AppData\Local\Google\Chrome" "v:\VDImproved\backup_restore\chrome" *.* /E
::for error check chsnge to GTR 7
IF %ERRORLEVEL% GTR 7 (
ECHO copy Chrome failed
pause
set "_err=_err + chrome"
Call _FAIL !_err!
)

ECHO finished cpchrome
pause
GOTO:_EOF

:_FAIL
::event logging
ECHO in FAIL & pause  
CALL v:\VDImproved\writeEvent.bat %0 "failed to copy !_err!" "F"

:_EOF
ENDLOCAL
::EXIT /B 0