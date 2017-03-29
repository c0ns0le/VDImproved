@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: asks user to enter days and time of class for specific classque file
:: the name of classque passed as paramter %1
:: TODO ask user if they wish to keep classque icons on desktop
v:
::remove next line
ECHO This will set up a simple space delineated profile file for each ClassQue folder
ECHO You will be prompted for: days your class meets, seat # if assigned, class start and end time
ECHO If a mistake has been made you will have the opportunity to confirm and correct details if needed. 
SET _class=%1
SET _resetOpt=0
SET "_daysMsg=Select the days for %_class%"

SET "_days1=Mon Tue Wed Thu Fri"
SET "_days2=Mon Wed Fri"
SET "_days3=Mon Wed"
SET "_days4=Tue Thu"

:_DAYS
::CLS
ECHO.
ECHO.
ECHO %_daysMsg%
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
IF NOT DEFINED %_day% GOTO _DAYS


:_STARTTIME
ECHO.
ECHO Enter the start time for %_class% in a 12 hour format: hhmm[a or p]
ECHO example 0930a for 9:30 am class, 0400p for 4:00 pm 
ECHO.
set /P _start="Enter start time: "
echo --------------------------------------------------------------------
:: parses _start for valid time by checking each digit at each position 0-3
:: and the 4th position for either a or p
:: position 0, 1 is the hh and the 2, 3 position is the mm
:: the verify9 is for longer range of 0-9
for %%J in (0 1) do if /I #%_start:~0,1%==#%%J (
	IF %%J EQU 1 ( CALL :_VERIFY1 %_start:~1,1% s) else ( CALL :_VERIFY9 %_start:~1,1% s)
	CALL :_VERIFY5 %_start:~2,1% s
	CALL :_VERIFY9 %_start:~3,1% s
	CALL :_VERIFYAP %_start:~4,1% s
	ECHO %_class% starts at %_start:~0,2%:%_start:~2,2% %_start:~4,1%m 
	if %_resetOpt% EQU 2 GOTO _CONFIRM
	GOTO _ENDTIME  )
IF NOT DEFINED %_start% GOTO _STARTTIME

::should never hit the following pause
PAUSE

:_ENDTIME
ECHO.
ECHO Enter the end time for %_class% in a 12 hour format: hhmm[a or p]
ECHO example 1115a for class ending at 11:15 am, 0200p for 2:00 pm 
ECHO.
set /P _end="Enter end time: "
echo --------------------------------------------------------------------
:: parses _start for valid time by checking each digit at each position 0-3
:: and the 4th position for either a or p
:: position 0, 1 is the hh and the 2, 3 position is the mm
:: the verify9 is for longer range of 0-9
for %%J in (0 1) do if /I #%_end:~0,1%==#%%J (
	IF %%J EQU 1 ( CALL :_VERIFY1 %_end:~1,1% e) else ( CALL :_VERIFY9 %_end:~1,1% e)
	CALL :_VERIFY5 %_end:~2,1% e
	CALL :_VERIFY9 %_end:~3,1% e
	CALL :_VERIFYAP %_end:~4,1% e
	ECHO %_class% ends at %_end:~0,2%:%_end:~2,2% %_end:~4,1%m
	GOTO _SEAT)
	IF NOT DEFINED %_end% GOTO _ENDTIME

::should never hit the following pause
PAUSE


:_SEAT
ECHO.
ECHO Enter your assigned seat number.
ECHO If not assigned a seat # enter N, a random seat will be entered for attendance.
ECHO NOTE: Any number under 999 will be allowed, regardless of ClassQues limit.
ECHO.
set /P _seat="Enter assigned seat number: "
echo --------------------------------------------------------------------
:: parses _start for valid time by checking each digit at each position 0-3
:: and the 4th position for either a or p
:: position 0, 1 is the hh and the 2, 3 position is the mm
:: the verify9 is for longer range of 0-9
IF /I %_seat%==n SET /a _seat=(%RANDOM%*100/32768)+1
IF %_seat% LEQ 0 GOTO _SEAT
IF %_seat% GEQ 201 GOTO _SEAT
		
ECHO seat is %_seat%
PAUSE
GOTO _CONFIRM
IF NOT DEFINED %_end% GOTO _SEAT





:: verifies user input is valid 12 hour 2 digit input: 01, 02....10,11,12
:_VERIFY1
::ECHO in v1 %1 : %2
::PAUSE
for /L %%K in (0, 1, 2) do if /I #%1==#%%K EXIT /B
::pause
IF %2==s GOTO _STARTTIME
IF %2==e GOTO _ENDTIME

:_VERIFY9
::ECHO in v9 %1 : %2
::PAUSE
for /L %%M in (0, 1, 9) do if /I #%1==#%%M EXIT /B
::pause
IF %2==s GOTO _STARTTIME
IF %2==e GOTO _ENDTIME

:_VERIFY5
::ECHO in v5 %1 : %2
::PAUSE
for /L %%N in (0, 1, 5) do if /I #%1==#%%N EXIT /B
::pause
IF %2==s GOTO _STARTTIME
IF %2==e GOTO _ENDTIME

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
ECHO For %_class% on %_days% starts at %_start:~0,2%:%_start:~2,2% %_start:~4,1%m ends at %_end:~0,2%:%_end:~2,2% %_end:~4,1%m, the assigned seat is %_seat%
ECHO.
ECHO.
set /P _correct="If this is correct enter Y, else enter N to change: "
echo --------------------------------------------------------------------
IF /I %_correct%==Y GOTO _WRITE
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

:: Creates a profile file to store classque settings
::TODO make the profile creation more robust by checking if exist and reading for existing info
::TODO Strip the leading 0 from to make easier to do shift to 24hour format if needed and
::		easier to compare to current time at runtime
				if h1=0 -> _hour=h2
				else _hour=h1h2
:_WRITE
>>"v:\VDImproved\profile_%_class%" ECHO  days:%_days%
>>"v:\VDImproved\profile_%_class%" ECHO  start time:%_start:~0,1% %_start:~1,1% %_start:~2,1% %_start:~3,1% %_start:~4,1%
>>"v:\VDImproved\profile_%_class%" ECHO  end time:%_end:~0,1% %_end:~1,1% %_end:~2,1% %_end:~3,1% %_end:~4,1%
>>"v:\VDImproved\profile_%_class%" ECHO  seat: %_seat%

:_RETURN
ECHO ClassQue settings have been saved
ECHO ClassQue will be run if the current time matches the time frame of the class. 
ENDLOCAL & EXIT /B 0


