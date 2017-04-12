
:: asks user to enter days and time of class for specific classque file
:: the name of classque passed as paramter %1
:: TODO ask user if they wish to keep classque icons on desktop
:: TODO Take the for loop block move into it's own function, copy/paste easier than delayedexpansion for debug
:: NOTE: the way the inputed time is stored could easily be simplified by
:: 		using a loop to store each position in seperate var's. Since they
::		are referenced so often. The choice was to doit this way to get
::		familiarity and practice with this method of parsing variables.

@ECHO OFF
v:
SETLOCAL ENABLEDELAYEDEXPANSION
::change below to fail for error no class name given
REM (
	REM SET _errMsg1="Create Profile"
	REM SET _errMsg2="Profile data invalid"
	REM SET _errMsg3=F
	REM GOTO _EVENTLOG
REM )
IF [%1]==[] GOTO:_DEBUG


::the four digit class number
SET _class=%1
:: Vars for the end hour, minute and start hour, minute of class 
SET _endHour=0
SET _endMin=0
SET _startHour=0
SET _startMin=0




:: Conditional value to change saved input values, altering code flow 
SET _resetOpt=0

SET "_days1=Mon,Tue,Wed,Thu,Fri"
SET "_days2=Mon,Wed,Fri"
SET "_days3=Mon,Wed"
SET "_days4=Tue,Thu"


ECHO This will set up a simple profile file for each ClassQue folder
ECHO You will be prompted for the following: 
ECHO the days your class meets, seat # if assigned, class start and end time
ECHO If a mistake has been made you will have the chance to confirm and change. 

:_DAYS
CLS
ECHO.
ECHO.
ECHO Select the days for %_class%
ECHO 1: %_days1%
ECHO 2: %_days2% 
ECHO 3: %_days3% 
ECHO 4: %_days4%
ECHO.
set /P _day="Enter a choice 1-4: "
echo --------------------------------------------------------------------
for /L %%I in (1,1,4) do if /I #%_day%==#%%I (
	SET _days=!_days%%I!
	ECHO !_class! meets on !_days! 
	if %_resetOpt% EQU 2 GOTO _CONFIRM
	GOTO _STARTTIME )
IF NOT DEFINED (%_day%) (GOTO _DAYS)


:: Each call to _VERIFY... takes two paramters, single digit in a specific position and 
:: either (e s) for end and start respectively 
:_STARTTIME
ECHO.
ECHO Enter the start time for %_class% in a 12 hour format: hhmm[a or p]
ECHO example 0930a for 9:30 am class, 0400p for 4:00 pm 
ECHO.
set /P _startT="Enter start time: "
echo --------------------------------------------------------------------
:: parses _startT for valid time by checking each digit at each position 0-3
:: and the 4th position for either a or p
:: position 0, 1 is the hh and the 2, 3 position is the mm
:: the verify9 is for longer range of 0-9
for %%J in (0 1) do if /I #%_startT:~0,1%==#%%J (
	IF %%J EQU 1 ( CALL :_VERIFY1 %_startT:~1,1% s) else ( CALL :_VERIFY9 %_startT:~1,1% s)
	CALL :_VERIFY5 %_startT:~2,1% s
	CALL :_VERIFY9 %_startT:~3,1% s
	CALL :_VERIFYAP %_startT:~4,1% s
	ECHO %_class% starts at %_startT:~0,2%:%_startT:~2,2% %_startT:~4,1%m 
	if %_resetOpt% EQU 2 GOTO _CONFIRM
	GOTO _ENDTIME  )
IF NOT DEFINED (%_startT%) (GOTO _STARTTIME)

::should never hit the following pause
PAUSE

:: Each call to _VERIFY... takes two paramters, single digit in a specific position and 
:: either (e s) for end and start respectively 
:_ENDTIME
ECHO.
ECHO Enter the end time for %_class% in a 12 hour format: hhmm[a or p]
ECHO example 1115a for class ending at 11:15 am, 0200p for 2:00 pm 
ECHO.
set /P _endT="Enter end time: "
echo --------------------------------------------------------------------
:: parses _startT for valid time by checking each digit at each position 0-3
:: and the 4th position for either a or p
:: position 0, 1 is the hh and the 2, 3 position is the mm
:: the verify9 is for longer range of 0-9
for %%J in (0 1) do if /I #%_endT:~0,1%==#%%J (
	IF %%J EQU 1 ( CALL :_VERIFY1 %_endT:~1,1% e) else ( CALL :_VERIFY9 %_endT:~1,1% e)
	CALL :_VERIFY5 %_endT:~2,1% e
	CALL :_VERIFY9 %_endT:~3,1% e
	CALL :_VERIFYAP %_endT:~4,1% e
	ECHO %_class% ends at %_endT:~0,2%:%_endT:~2,2% %_endT:~4,1%m
	GOTO _SEAT)
IF NOT DEFINED %_endT% GOTO _ENDTIME

::should never hit the following pause
PAUSE

:: If random assignment is chosen, the seat will NOT be within the first 10 seats
:_SEAT
ECHO.
ECHO Enter your assigned seat number.
ECHO If not assigned a seat # or enter N, a random seat will be used for attendance.
ECHO NOTE: Any number under 250 will be allowed, regardless of ClassQues limit.
ECHO.
set /P _seat="Enter assigned seat number: "
echo --------------------------------------------------------------------

IF /I %_seat%==n SET /a _seat=(%RANDOM%*100/32768)+10
IF %_seat% LEQ 0 GOTO _SEAT
IF %_seat% GEQ 250 GOTO _SEAT
ECHO seat is %_seat%
PAUSE
GOTO _CONFIRM
IF NOT DEFINED %_seat% GOTO _SEAT
PAUSE

:: Takes two paramters: 2nd hour digit (0, 1, 2) and (e, s) 
:: verifies user input results in a valid hour input. 
:: 1st hour digit is already confirmed to = 1 
:_VERIFY1
::ECHO in v1 %1 : %2
::PAUSE
for /L %%K in (0, 1, 2) do if /I #%1==#%%K EXIT /B
::pause
IF %2==s GOTO _STARTTIME
IF %2==e GOTO _ENDTIME

:: verifies user input results in a valid hour or minute input. 
:: Takes two paramters: 2nd hour or minute digit (0-9) and (e, s) 
:: For hours the 1st hour digit is already confirmed to = 0 
:_VERIFY9
::ECHO in v9 %1 : %2
::PAUSE
for /L %%M in (0, 1, 9) do if /I #%1==#%%M EXIT /B
::pause
IF %2==s GOTO _STARTTIME
IF %2==e GOTO _ENDTIME

:: verifies user input in minutes cannot exceed 59 minutes per hour 
:: Takes two paramters: 1st minute digit (0-5) and (e, s)
:_VERIFY5
::ECHO in v5 %1 : %2
::PAUSE
for /L %%N in (0, 1, 5) do if /I #%1==#%%N EXIT /B
::pause
IF %2==s GOTO _STARTTIME
IF %2==e GOTO _ENDTIME

:: verifies that only am or pm was entered
:_VERIFYAP 
::ECHO in vAP %1 : %2
::PAUSE
for %%O in (a p) do if /I %1==%%O EXIT /B
::pause
IF %2==s GOTO _STARTTIME
IF %2==e GOTO _ENDTIME

:: Confirms the entered values and provides option to change any or all
:_CONFIRM
CLS
ECHO.
ECHO.
ECHO Please confirm class details
ECHO For %_class% on %_days% starts at %_startT:~0,2%:%_startT:~2,2% %_startT:~4,1%m ends at %_endT:~0,2%:%_endT:~2,2% %_endT:~4,1%m
ECHO and the assigned seat is %_seat%
ECHO.
ECHO.
set /P _correct="If this is correct enter Y, else enter N to change: "
echo --------------------------------------------------------------------
IF /I %_correct%==Y GOTO _ADJTIME
IF /I %_correct%==N GOTO _CHANGE
IF NOT DEFINED %_correct% (GOTO _CONFIRM)

GOTO:_CONFIRM

::Allows user to select what changes are to be made
:_CHANGE
ECHO.
ECHO.
ECHO Please enter the letter of what you would like to change
ECHO  D: Days of the week
ECHO  B: Beginning time
ECHO  E: End time
ECHO  S: Seat
ECHO  A: ALL
ECHO example b -to change the start time
set /P _change="Please choose one Beginning to change: "
echo --------------------------------------------------------------------
if /I %_change%==a SET _resetOpt=0 & GOTO _DAYS
SET _resetOpt=2
if /I %_change%==b GOTO _STARTTIME
if /I %_change%==e GOTO _ENDTIME
if /I %_change%==d GOTO _DAYS
if /I %_change%==s GOTO _SEAT
IF NOT DEFINED %_change% GOTO _CHANGE

:: Takes two paramters: _startT and _endT
:: the first parameter must be sent with double %%, in this use is equivilent to passing pointer not a value 
:: Strip the leading 0 from the time to make easier to do shift to 24hour format if needed and
:: easier to compare to current time at runtime
:_ADJTIME
ECHO --in ADJTIME

ECHO startTime = %_startT% and endTime = %_endT%
PAUSE

IF %_startT:~0,1%==0 (
	SET _startHour=%_startT:~1,1%
)
IF %_startT:~0,1%==1 (
	SET _startHour=%_startT:~0,2%
)
SET _startMin=%_startT:~2,2%
SET _startAP=%_startT:~4,1%m

if %_endT:~0,1%==0 (
	SET _endHour=%_endT:~1,1%
)
if %_endT:~0,1%==1 (
	SET _endHour=%_endT:~0,2%
)
SET _endMin=%_endT:~2,2%
SET _endAP=%_endT:~4,1%m

ECHO end hour:min = %_endHour%:%_endMin% %_endAP% start hour:min = %_startHour%:%_startMin% %_startAP%
PAUSE
:: fall thru 

:: Creates a profile file to store classque settings
::TODO make the profile creation more robust by checking if exist and reading for existing info
:_WRITE
ECHO ---WRITE
PAUSE
IF EXIST "v:\VDImproved\profile\%_class%.txt" DEL "v:\VDImproved\profile\%_class%.txt"
>>"v:\VDImproved\profile\%_class%.txt" ECHO %_class%
>>"v:\VDImproved\profile\%_class%.txt" ECHO %_days%
>>"v:\VDImproved\profile\%_class%.txt" ECHO %_startAP%
>>"v:\VDImproved\profile\%_class%.txt" ECHO %_startHour%:%_startMin%
>>"v:\VDImproved\profile\%_class%.txt" ECHO %_endAP%
>>"v:\VDImproved\profile\%_class%.txt" ECHO %_endHour%:%_endMin%
>>"v:\VDImproved\profile\%_class%.txt" ECHO %_seat%
CLS
ECHO finished write&PAUSE

GOTO:_CHECKWRITE
:: fall thru 


:: if all saved data matches user input data
:_CHECKWRITE
ECHO ---CHECKKWRITE
FOR /F "delims=;" %%X in (v:\VDImproved\profile\%_class%.txt) DO (
	SET _valid=F
	ECHO valid=F
	PAUSE
	FOR %%Y IN ("%_class%" "%_days%" "%_startAP%" "%_startHour%:%_startMin%" "%_endAP%" "%_endHour%:%_endMin%" "%_seat%") DO (
		ECHO in for's X=%%X, Y=%%Y, valid=!_valid!:
		PAUSE
		IF  "%%X"==%%Y (
			SET _valid=T
			ECHO valid=T
			PAUSE
			)
		
	)
	IF !_valid!==F (
		ECHO MISMATCH in valid=f
		PAUSE
		SET _Msg1="Create Profile"
		SET _Msg2="Profile data mismatch: %%X"
		SET _Msg3=F
		CALL :_EVENTLOG
		)
)
::END FILE READ and compare
IF %_valid%==T (
		ECHO File read valid=T
		pause		
		SET _Msg1="Create Profile:%0"
		SET _Msg2="Profile data validated"
		SET _Msg3=P
		CALL :_EVENTLOG
		ECHO finished validation&PAUSE
		CALL :_RETURN "been saved" "P" 0
		)
		
ECHO After loops and checks 
PAUSE
GOTO _EOF
ECHO DEBUG should not print
PAUSE


:: Expects 3 variables msg1, msg2, msg3 to be set elsewhere
:_EVENTLOG
ECHO ---EVENT LOG
ECHO     Msg1=%_Msg1%, Msg2=%_Msg2%, Msg3=%_Msg3% :
PAUSE
CALL v:\VDImproved\writeEvent.bat %_Msg1% %_Msg2% %_Msg3%
EXIT /B 0

::Expects 3 parameters to indicate success or failure of script
:_RETURN
ECHO ClassQue settings have %1
IF /I %2==P ECHO ClassQue will be run if the current time matches the time frame of the class. 
IF /I %2==F (
	ECHO There is a problem with creating the profile
	ECHO Please check the v:\VDImproved\profile\%_class%.txt file to make any needed changes
	PAUSE
	)
ENDLOCAL & EXIT /B %3


:: TODO remove below
:_DEBUG
	ECHO in debug
	PAUSE
	CLS
set /P _debug="debug?"
IF /I %_debug%==n EXIT /B 1
SET _class=debug
SET "_days=Mon,Tue,Wed,Thu,Fri"
SET _startAP=am
SET _startHour=9
SET _startMin=00
SET _endAP=am
SET _endHour=10
SET _endMin=00
SET _seat=15
ECHO SET debug vars
PAUSE
GOTO _WRITE

:_EOF
ENDLOCAL&EXIT /B 0