::TESTED good

@ECHO off

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
set _chrome=0
ECHO 22 chrome is !_chrome! should 0
pause
) else (
set _chrome=1
ECHO 26 chrome is !_chrome! should be 1
pause
)


::checks if backup dir for chrome exists
:_BACKUPEXIST
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
set /a "_check=_chrome+_backup"
echo check is %_check%
pause


::   chrome + backup, is chrome=1 if exist (else 0) AND backup=3 if exist (else 0)
::		the running var is T is chrome has any current processes
:: = 1+3 =  4 (both exist)
::       -> 1 -> HasRun (if running T -> kill || else if F) -> HasBackup is 3-> FirstRun -> SetDefault ->EOF

:: = 1+0 =  1 (chrome exists AND backup not exists)
::       -> 1 -> HasRun (if running T -> kill || else if F) -> HasBackup is 0-> RestoreBackup -> RestoreSession->EOF

:: = 0+3 =  3 (chrome not exist AND backup exist)
::       -> RestoreBackup  -> RestoreSession->EOF
::    OR
:: = 0+0 =  0 (neither exist)
::       -> setDEFAULT -> EOF
for %%I in (0 1 3 4) do if #%_check%==#%%I goto _%%ISTATE

:_4STATE
echo _4STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
pause
GOTO:_HASRUN

:_0STATE
echo _0STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
pause
GOTO:_SETDEFAULT

:_1STATE
echo _1STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
pause
GOTO:_HASRUN

:_3STATE
echo _3STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
pause
GOTO:_RESTOREBACKUP

::checks to see if chrome is runnning
:_HASRUN
ECHO in HasRun && pause   
set "_proc=tasklist.exe /FI "IMAGENAME eq chrom*" /NH "
echo proc return is %_proc%
pause
for /F "delims=*" %%p in ('!_proc! ^| findstr "chrome.exe" ') do (
  echo found %%p
  set _running=Y
  GOTO:_KILL
)
GOTO:_HASBACKUP

:: the process has already been confirmed to be running
:_KILL
ECHO ---in KILL
ECHO is running is %_running% 
pause
IF %_running% == Y (
echo in running check if statement
pause
CALL taskkill /IM chrome.exe
)
EXIT /B 0


:: Function is simply a conditional since  performing AND OR if statements isnt supported
:_HASBACKUP
echo ---in :_HASBACKUP
ECHO backup is !_backup! 
pause
IF !_backup! == 3 (
echo checking backing equals 3 is %_backup%
pause
GOTO:_RESTOREBACKUP
) 
IF !_backup! == 0 (
echo checking backing equals 0 is %_backup%
pause
CALL v:\VDImproved\OnExit\backup.bat "C" 
GOTO:_FIRSTRUN
)

:: ROBOCOPY options --/NJH : No Job Header and /NJS : No Job Summary.
:_RESTOREBACKUP
::copies from VDImproved backup location to chrome default location in APPDATA
echo in restore
pause
ROBOCOPY "V:\VDImproved\backup_restore\chrome" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome" *.* /E /NJH /NJS
IF %ERRORLEVEL% GTR 7 (
ECHO copy Chrome failed
pause
Call :_LOG "failed to restore default folder" "F"
CALL :_RESTORSESSION
GOTO _EOF
)
:: TODO prompt user for option to restore previous session is possible
:: auto try to restore previous session. 
CALL :_LOG "chrome sucessfully restored from backup" "P"
CLS
ECHO Attempting to restore previous Chrome session
CALL :_RESTORSESSION
GOTO _EOF

:__FIRSTRUN
ECHO in Firstrun 
CALL v:\VDImproved\writeEvent.bat %0 "First backup created" "P"
ECHO write to log firstrun
PAUSE

:: below conditional not req'd as this function only entered if chrome has never run and no backups exists
::IF %_chrome% == 1 (
::	CALL :_RESTORSESSION 
	::fall thru
::)
GOTO:_SETDEFAULT

::event logging
:_LOG
ECHO in LOG 
CALL v:\VDImproved\writeEvent.bat "Login-Chrome" %1 %2
ECHO write to log event 0=%0d 1=%1 2=%2:
PAUSE
EXIT /B 0


::restore chromes previous session with tabs if it wass running and sets it as default
:_RESTORSESSION
ECHO in Restoretabs
pause
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "--restore-last-session"
EXIT /B 0


:: TODO just test if there is a default setting switch or file??? similar to existance of a firstrun file
::Sets chrome as default browser, launches browser
:_SETDEFAULT
 ECHO in setdefault && pause
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "-silent -nosplash -setDefaultBrowser" "--restore-last-session"
GOTO:_EOF



:_EOF
ENDLOCAL
::EOF