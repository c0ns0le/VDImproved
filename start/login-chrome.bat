@ECHO off

::checked = in prog sections with ::P or ::F, pass or fail
:: Restore chrome and adds success or failure to log file

:: Checks c:\....APPDATA\Local for existing file structure and creates if needed
:: Copies backup chrome data from previous sessions

:: IMPORTANT you must logout using the logout shortcut icon on the desktop, or updated profile info will
:: 	not be saved


SETLOCAL ENABLEDELAYEDEXPANSION
v:

::checks if chrome has been run
:_HASCHROME
ECHO:---in has chrome 
pause
::Checks for existing chrome dirs in appdata, creates if needed
IF not exist "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" (
mkdir "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\"
set _run=0
ECHO 22 run is !_run! should 0
pause
) else (
set _run=1
ECHO 26 run is !_run! should be 1
pause
)


::checks if backup dir for chrome exists
:_HASBACKUP
ECHO:in has backup
IF not exist "V:\VDImproved\backup_restore\chrome\User Data" (
mkdir "V:\VDImproved\backup_restore\chrome\User Data"  
set _backup=0
ECHO 37 backup is !_backup! should be 0
pause
) else (
set _backup=3
ECHO 41 backup is !_backup! should be 3
pause
)
set /a "_check=_run+_backup"
echo check is %_check%
pause
::  run + backup, run=1 if T, else 0, backup=3 if T, else 0
::  = 1+3 -> 4 both exist
::         -> IsRunning, restore
::  = 1+0 -> 1 chrome exists, backup not exists
::         -> IsRunning, FirstRun
::  = 0+3 -> 3 chrome not exist, backup exist
::         -> Restore,Setdefault
::  = 0+0 -> 0 neither exist
::         -> setDEFAULT
for %%I in (0 1 3 4) do if #%_check%==#%%I goto _%%ISTATE

:_4STATE
echo _4STATE, run is !_run! , backup is !_backup! , check is %_check%
pause
GOTO:_ISRUNNING

:_0STATE
echo _0STATE, run is !_run! , backup is !_backup! , check is %_check%
pause
GOTO:_SETDEFAULT

:_1STATE
echo _1STATE, run is !_run! , backup is !_backup! , check is %_check%
pause
GOTO:_ISRUNNING

:_3STATE
echo _3STATE, run is !_run! , backup is !_backup! , check is %_check%
pause
GOTO:_RESTORE


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
GOTO:_CHK

:_KILL
ECHO is running is %_running% 
pause
IF %_running% == Y (
echo in running check if statement
pause
CALL taskkill /IM chrome.exe
)

::may need to add /F at end of above if chrome wont shutdown in time CALL taskkill /FI "IMAGENAME eq chrome.exe" /T
:_CHK
echo killed chrome. backup is !_backup! 
pause
IF !_backup! == 3 (
echo checking backing equals 3 is %_backup%
pause
GOTO:_RESTORE
) 
IF !_backup! == 0 (
echo checking backing equals 0 is %_backup%
pause
CALL v:\VDImproved\OnExit\backup.bat "C" 
GOTO:_FIRSTRUN
)


:_RESTORE
::copies from VDImproved backup location to chrome default location
echo in restore
pause
ROBOCOPY "V:\VDImproved\backup_restore\chrome" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome" *.* /E 
IF %ERRORLEVEL% GTR 7 (
ECHO copy Chrome failed
pause
set "_err=_err + chrome"
Call _FAIL1 !_err!
)
echo success on copy
pause
IF %_run% == 1 ( GOTO:_RESTORETABS )
GOTO:_SETDEFAULT

::event logging
:_FAIL1
ECHO in FAIL1 && pause  
CALL v:\VDImproved\writeEvent.bat "login chrome" "failed to restore default folder" "F"
GOTO:_SETDEFAULT

:__FIRSTRUN
ECHO in Firstrun && pause  
CALL v:\VDImproved\writeEvent.bat "login-chrome" "First backup created" "P"
GOTO:_RESTORETABS

:_LOG
ECHO in LOG && pause
CALL v:\VDImproved\writeEvent.bat "login-chrome" "chrome sucessfully restored" "P"
GOTO:_SETDEFAULT

::Sets chrome as default browser, launches browser
:_SETDEFAULT
 ECHO in setdefault && pause
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "-silent -nosplash -setDefaultBrowser"
GOTO:_EOF

::restore chromes previous tabs if it wass running and sets it as default
:_RESTORETABS
ECHO in Restoretabs && pause
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "--restore-last-session"


:_EOF
ENDLOCAL
::EOF