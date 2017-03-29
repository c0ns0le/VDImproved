::OLD REFERENCE OLNLY
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
set _run=F
) else (
set _run=T
)
ECHO 25 run is %_run%
pause

::checks if backup dir for chrome exists
:_HASBACKUP
ECHO:in has backup
IF not exist "V:\VDImproved\backup_restore\chrome\User Data" (
mkdir "V:\VDImproved\backup_restore\chrome\User Data"  
set _backup=F
) else (
set _backup=T
)
ECHO 37 backup is %_backup%
pause
::  run + backup
::  = T+T -> both exist
::         -> IsRunning, restore
::  = T+F -> chrome exists, backup not exists
::         -> IsRunning, FirstRun
::  = F+T ->  chrome not exist, backup exist
::         -> Restore,Setdefault
::  = F+F -> neither exist
::         -> setDEFAULT
IF (%_run% == "T") (
echo 49 run True and %_run%
pause
GOTO:_rT
) 

IF (%_run% =="F") (
echo 53 run False and %_run%
pause
GOTO:_rF
)

:_rT
IF (%_backup% == "T") (
echo  60 run true bckup True and %_run%, %_backup%
pause
GOTO:_rTbT
) 
IF (%_backup% == "F") (
echo 64 run True bckup False and %_run%, %_backup%
pause
GOTO:_rTbF
)

:_rF
IF (%_backup% == "T") (
echo 71 run False bckup True and %_run%, %_backup%
pause
GOTO:_rFbT
)
IF (%_backup% == "F") (
echo 75 run False bckup False and %_run%, %_backup%
pause
GOTO:_rFbF
)

:_rTbT
echo 81 run True and bckup True
pause
GOTO:_ISRUNNING

:_rTbF
echo 86 run T + backup F is !_run! + !_backup!
pause
GOTO:_ISRUNNING

:_rFbT
echo 91 run F + backup T is !_run! + !_backup!
pause
GOTO:_RESTORE

:_rFbF
echo 96 run F + backup F is !_run! + !_backup!
pause
GOTO:_SETDEFAULT

echo end if block
pause
:_RESTORE
::copies from VDImproved backup location to chrome default location
echo in restore
pause
COPY /Y "V:\VDImproved\backup_restore\chrome\User Data\Default\*" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" &&(
GOTO:_PASS
)||(
GOTO:_FAIL1
)

::Copies the FIRST RUN file, eliminating popups
:_PASS
ECHO in PASS && pause  
copy /Y "V:\VDImproved\backup_restore\chrome\User Data\FIRST RUN" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\" &&(
GOTO:_LOG 
)||(
GOTO:_FAIL2
)

::checks to see if chrome is runnning
:_ISRUNNING
ECHO in IsRunning && pause   
set "_proc=tasklist.exe /FI "IMAGENAME eq chrome.exe" "
for /F "delims=*" %%p in ('!_proc! ^| findstr "chrome.exe" ') do (
  echo found %%p
  set _running=Y
)
::tasklist /FI "IMAGENAME eq chrome.exe" /FI "STATUS eq running" &&(
::set _IsRunning=Y
::)||(
::set _IsRunning=N
::)
ECHO is running is %_running% 
pause
IF %_running% == "Y" (
	taskkill /FI "IMAGENAME eq chrome.exe" /T /F 
)
IF %_backup% == "T" (
	GOTO:_RESTORE
) ELSE ( 
	IF !_backup! == "F"	(
		CALL v:\VDImproved\OnExit\backup.bat "C" 
		GOTO:_FIRSTRUN
	)
)

::event logging
:_FAIL1
ECHO in FAIL1 && pause  
CALL v:\VDImproved\writeEvent.bat "login chrome" "failed to restore default folder" "F"
GOTO:_SETDEFAULT

:_FAIL2
ECHO in Fail2 && pause  
CALL v:\VDImproved\writeEvent.bat "login chrome" "failed to restore file FIRSTRUN" "F"
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
ECHO in Restore && pause
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "-silent -nosplash -setDefaultBrowser --restore-last-session"


:_EOF
ENDLOCAL
::EOF