:: checks for .gitconfig file in v:\VDImproved\backup_restore
:: copies to the user home directory. C:\Users\%USERNAME%

GOTO:EOF
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT EXIST "C:\Users\%USERNAME%\*gitconfig" (
		ROBOCOPY v:\VDImproved\ C:\Users\%USERNAME% *gitconfig
		REM ECHO copy return code: %ERRORLEVEL%
		REM pause
		::for error check on fail change to LEQ 7 else normal operation GTR 7
		IF %ERRORLEVEL% GTR 7 (
			REM ECHO copy gitconfig failed return code: %ERRORLEVEL%
			REM pause
			GOTO:_FAIL 
		)
		IF %ERRORLEVEL% EQU 0 (
			REM ECHO copy gitconfig failed return code: %ERRORLEVEL%
			REM pause
			GOTO:_FAIL 
		)
	)
GOTO :_EOF

:_FAIL
::event logging
REM ECHO in FAIL & pause  
CALL v:\VDImproved\writeEvent.bat %0 "failed to copy errcode:%ERRORLEVEL%" "F"

:_EOF
REM ECHO in EOF & pause 
ENDLOCAL&EXIT /B 0