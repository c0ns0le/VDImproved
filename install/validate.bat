:: Takes parameters and validates file data written by calling script
:: Having issue with previous define_daytime_classque.bat exiting on
:: this code block. Maybe it hasnt closed the write or the file so
:: it then cannot be opened, and then exits bat prematurely 
:: For debug, Im thinkingif I push the function out into its own script
:: It may close or delay it long enough. 
@ECHO ON
SETLOCAL ENABLEDELAYEDEXPANSION
v:
SET _class=%1
SET _days=%2
SET _startAP=%3
SET _startHour=%4
SET _startMin=%5
SET _endAP=%6
SET _endHour=%7
SET _endMin=%8
SET _seat=%9


ECHO VARS SET
PAUSE
ECHO %_class%
ECHO %_days%
ECHO %_startAP%
ECHO %_startHour%:%_startMin%
ECHO %_endAP%
ECHO %_endHour%:%_endMin%
ECHO %_seat%
PAUSE
IF NOT EXIST "v:\VDImproved\profile\%_class%.txt" (
	ECHO File to check not found&PAUSE
	GOTO _RETURN)
ECHO AT for loop
PAUSE
FOR /F %%X in ("V:\VDImproved\profile\%_class%.txt") DO (
ECHO in for
	PAUSE
	ECHO in chkwrite 1st loop Q=%%X
	PAUSE
	IF NOT "%_class%"=="%%X" (
		ECHO 1st if&PAUSE
		IF "%_days%"=="%%X" (
			ECHO 2 if&PAUSE
			IF "%_startAP%"=="%%X" (
							ECHO 3 if&PAUSE

				IF "%_startHour%:%_startMin%"=="%%X" (
						ECHO 4 if&PAUSE
	
					IF "%_endAP%"=="%%X" (
								ECHO 5 if&PAUSE

						IF "%_endHour%:%_endMin%"=="%%X" (
									ECHO 6 if&PAUSE

							IF "%_seat%"=="%%X" (
										ECHO 7 if&PAUSE

								SET _Msg1="Create Profile:%0"
								SET _Msg2="Profile data validated"
								SET _Msg3=P
								CALL :_EVENTLOG
								ECHO finished validation&PAUSE
								CALL _RETURN "been saved" "P" 0
							)
						)
					)
				)
			)
		)
	) 
	::END IF's
)	
ECHO TEST ME
PAUSE
IF %ERRORLEVEL%==5 ECHO FOR error fuck me&PAUSE
IF %ERRORLEVEL%==5 ECHO FOR error fuck me&PAUSE
SET _Msg1="Create Profile"
SET _Msg2="Profile data mismatch"
SET _Msg3=F
CALL :_EVENTLOG
)
CALL :_RETURN "NOT been saved" "F" 1

:: Expects 3 variables msg1, msg2, msg3 to be set elsewhere
:_EVENTLOG
ECHO ---EVENT LOG
ECHO     Msg1=%_Msg1%, Msg2=%_Msg2%, Msg3=%_Msg3% :
PAUSE
CALL v:\VDImproved\writeEvent.bat %_Msg1% %_Msg2% %_Msg3%
EXIT /B 0

:_RETURN
ECHO ---RETURN
ECHO %1 %2 %3
PAUSE

