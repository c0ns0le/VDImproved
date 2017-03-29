::TESTED GOOD

::backups important chrome data to be restored on startup
::NOTE-- the EXIT /B inside labels ONLY returns to the line where it was called from
@ECHO ON
SETLOCAL ENABLEDELAYEDEXPANSION
::C:\Users\ahd227\AppData\Local\Microsoft\Office\15.0
V:
ECHO in %0
CALL :_ISRUNNING
GOTO _COPYCHROME


::checks to see if chrome is runnning
:_ISRUNNING
ECHO in IsRunning && pause   
set "_proc=tasklist.exe /FI "IMAGENAME eq chrom*" /NH "
echo proc return is %_proc%
pause
for /F "delims=*" %%p in ('!_proc! ^| findstr "chrome.exe" ') do (
  echo found %%p
  set _running=Y
  GOTO:_KILL
)
EXIT /B 0

:_KILL
ECHO is running is %_running% 
pause
IF %_running% == Y (
echo in running check if statement
pause
CALL taskkill /IM chrome.exe
)
GOTO _COPYCHROME

:: Copies all files and subfolders under default then copies files only in top dir level 
:_COPYCHROME
Echo About to robocopy chrome&PAUSE
::copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*" "v:\VDImproved\backup_restore\chrome\User Data\Default"
ROBOCOPY "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default" "v:\VDImproved\backup_restore\chrome\User Data\Default" /S
::copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data" "v:\VDImproved\backup_restore\chrome\User Data"
ROBOCOPY "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data" "v:\VDImproved\backup_restore\chrome\User Data" /LEV:1
ECHO finished copy&pause
GOTO _COPYMS


:_COPYMS
ROBOCOPY "C:\Users\%USERNAME%\AppData\Local\Microsoft\Office\15.0" "v:\VDImproved\backup_restore\Microsoft\Office\15.0" *.* /S
GOTO _FIN


:_FIN
ECHO 0=%0 1=%1: in fin&pause
ENDLOCAL

::shutdown -l




:: http://stackoverflow.com/questions/377407/detecting-how-a-batch-file-was-executed

:_EOF

::EOF