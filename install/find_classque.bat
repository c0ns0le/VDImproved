:: finds names of classque files and creates new bat script for each

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

v:
cd \classque
CLS

::the DIR command with flags will only print directories, no headers
::for each line, each dir name is used to dynamically create a classque login file and preference file
:: based on the 4 digit class number 
for /F %%p in ('DIR /A:D /B /ON') do (
::	SET /a _count+=1
	::DEBUG ECHO _count !_count! : percent p is %%p :
	COPY v:\VDImproved\install\template.bat v:\VDImproved\start\
	REN v:\VDImproved\start\template.bat login-CQ%%p.bat
	CALL v:\VDImproved\install\define_daytime_classque.bat %%p
 )

REM :_NOTFOUND
REM :: already in previ script CALL v:\VDImproved\writeEvent.bat "%0" "No clasque files found" "F"
REM EXIT /B 2

:_EOF
ENDLOCAL&EXIT /B 0
