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
REM ECHO:---in has chrome 
REM PAUSE
::Checks for existing chrome dirs in appdata, creates if needed
IF not exist "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" (
mkdir "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\"
SET _chrome=0
REM ECHO 22 chrome is !_chrome! should 0
REM PAUSE
) else (
SET _chrome=1
REM ECHO 26 chrome is !_chrome! should be 1
REM PAUSE
)


::checks if backup dir for chrome exists
:_BACKUPEXIST
REM ECHO:in has backup
IF not exist "V:\VDImproved\backup_restore\chrome\User Data" (
mkdir "V:\VDImproved\backup_restore\chrome\User Data"  
SET _backup=0
REM ECHO 37 backup is !_backup! should be 0
REM PAUSE
) else (
SET _backup=3
REM ECHO 41 backup is !_backup! should be 3
REM PAUSE
)
SET /a "_check=_chrome+_backup"
REM ECHO check is %_check%
REM PAUSE


::   chrome + backup, is chrome=1 if exist (else 0) AND backup=3 if exist (else 0)
::		the running var is T is chrome has any current processes
:: = 1+3 =  4 (both exist)
::       -> 1 -> HasRun (if running T -> kill || else if F) -> HasBackup is 3-> FirstRun -> SETDefault ->EOF

:: = 1+0 =  1 (chrome exists AND backup not exists)
::       -> 1 -> HasRun (if running T -> kill || else if F) -> HasBackup is 0-> RestoreBackup -> RestoreSession->EOF

:: = 0+3 =  3 (chrome not exist AND backup exist)
::       -> RestoreBackup  -> RestoreSession->EOF
::    OR
:: = 0+0 =  0 (neither exist)
::       -> SETDEFAULT -> EOF
for %%I in (0 1 3 4) do if #%_check%==#%%I goto _%%ISTATE

:_4STATE
REM ECHO _4STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
REM PAUSE
GOTO:_HASRUN

:_0STATE
REM ECHO _0STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
REM PAUSE
GOTO:_SETDEFAULT

:_1STATE
REM ECHO _1STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
REM PAUSE
GOTO:_HASRUN

:_3STATE
REM ECHO _3STATE, chrome is !_chrome! , backup is !_backup! , check is %_check%
REM PAUSE
GOTO:_RESTOREBACKUP

::checks to see if chrome is runnning
:_HASRUN
REM ECHO in HasRun && PAUSE   
SET "_proc=tasklist.exe /FI "IMAGENAME eq chrom*" /NH "
REM ECHO proc return is %_proc%
REM PAUSE
for /F "delims=*" %%p in ('!_proc! ^| findstr "chrome.exe" ') do (
  REM ECHO found %%p
  SET _running=Y
  GOTO:_KILL
)
GOTO:_HASBACKUP

:: the process has already been confirmed to be running
:_KILL
REM ECHO ---in KILL
REM ECHO is running is %_running% 
REM PAUSE
IF %_running% == Y (
REM ECHO in running check if statement
REM PAUSE
CALL taskkill /IM chrome.exe
)
EXIT /B 0


:: Function is simply a conditional since  performing AND OR if statements isnt supported
:_HASBACKUP
REM ECHO ---in :_HASBACKUP
REM ECHO backup is !_backup! 
REM PAUSE
IF !_backup! == 3 (
	REM ECHO checking backing equals 3 is %_backup%
	REM PAUSE
	GOTO:_RESTOREBACKUP
) 
IF !_backup! == 0 (
	REM ECHO checking backing equals 0 is %_backup%
	REM PAUSE
	CALL v:\VDImproved\OnExit\backup.bat "C" 
	GOTO:_FIRSTRUN
)

:: ROBOCOPY options --/NJH : No Job Header and /NJS : No Job Summary.
:_RESTOREBACKUP
::copies from VDImproved backup location to chrome default location in APPDATA
REM ECHO in restore
REM PAUSE
ROBOCOPY "V:\VDImproved\backup_restore\chrome" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome" *.* /E /NJH /NJS
IF %ERRORLEVEL% GTR 7 (
REM ECHO copy Chrome failed
REM PAUSE
Call :_LOG "failed to restore default folder" "F"
CALL :_RESTORSESSION
GOTO _EOF
)
:: TODO prompt user for option to restore previous session is possible
:: auto try to restore previous session. 
CALL :_LOG "chrome sucessfully restored from backup" "P"
REM CLS
REM ECHO Attempting to restore previous Chrome session
CALL :_RESTORSESSION
GOTO _EOF

:__FIRSTRUN
REM ECHO in Firstrun 
CALL v:\VDImproved\writeEvent.bat %0 "First backup created" "P"
REM ECHO write to log firstrun
REM PAUSE

:: below conditional not req'd as this function only entered if chrome has never run and no backups exists
::IF %_chrome% == 1 (
::	CALL :_RESTORSESSION 
	::fall thru
::)
GOTO:_SETDEFAULT

::event logging
:_LOG
REM ECHO in LOG 
CALL v:\VDImproved\writeEvent.bat "Login-Chrome" %1 %2
REM ECHO write to log event 0=%0d 1=%1 2=%2:
REM PAUSE
EXIT /B 0


::restore chromes previous session with tabs if it wass running and SETs it as default
:_RESTORSESSION
REM ECHO in Restoretabs
REM PAUSE
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "--restore-last-session"
EXIT /B 0


:: TODO just test if there is a default SETting switch or file??? similar to existance of a firstrun file
::SETs chrome as default browser, launches browser
:_SETDEFAULT
 REM ECHO in SETdefault && PAUSE
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "-silent -nosplash -SETDefaultBrowser" "--restore-last-session"
GOTO:_EOF


:_EOF
ENDLOCAL&EXIT /B 0
::EOF