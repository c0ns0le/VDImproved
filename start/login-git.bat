:: checks for .gitconfig file in v:\VDImproved\backup_restore
:: copies to the user home directory. C:\Users\%USERNAME%


@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT EXIST "C:\Users\%USERNAME%\*gitconfig" (
		ROBOCOPY v:\VDImproved\ C:\Users\%USERNAME% *gitconfig
		ECHO copy return code: %ERRORLEVEL%
		pause
		::for error check on fail change to LEQ 7 else normal operation GTR 7
		IF %ERRORLEVEL% GTR 7 (
			ECHO copy gitconfig failed return code: %ERRORLEVEL%
			pause
			GOTO:_FAIL 
		)
		IF %ERRORLEVEL% EQU 0 (
			ECHO copy gitconfig failed return code: %ERRORLEVEL%
			pause
			GOTO:_FAIL 
		)
	)
GOTO :_EOF

:_FAIL
::event logging
ECHO in FAIL & pause  
CALL v:\VDImproved\writeEvent.bat %0 "failed to copy errcode:%ERRORLEVEL%" "F"



:_EOF
ECHO in EOF & pause 
ENDLOCAL