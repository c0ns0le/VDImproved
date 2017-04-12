:: finds names of classque files and creates new bat script for each

@ECHO ON
SETLOCAL ENABLEDELAYEDEXPANSION

v:
cd v:\classque


::the DIR command with flags will only print directories, no headers
::for each line, each dir name is used to dynamically create a classque login file and preference file
for /F %%p in ('DIR /A:D /B /ON') do (
::	SET /a _count+=1
	::DEBUG ECHO _count !_count! : percent p is %%p :
	COPY v:\VDImproved\install\template.bat v:\VDImproved\start\
	REN v:\VDImproved\start\template.bat login-CQ%%p.bat
	CALL v:\VDImproved\install\define_daytime_classque.bat %%p
	for 
	pause
 )



:_NOTFOUND
:: already in previ script CALL v:\VDImproved\writeEvent.bat "%0" "No clasque files found" "F"
EXIT /B 2

:_EOF
ENDLOCAL
GOTO :EOF


::BELOW NOT NEEDED!!!!
::the count is not being expanded so only one, the _dir var is created 
 echo out of first for loop
 echo dir is %_dir% or !_dir! or %%_dir%%: _dir0 is %_dir0%: 
 ECHO _dir1 is %_dir1%: dir2 is %_dir2%:
  SET _numClassQue=!_count!
  PAUSE
echo found %_numClassQue% of classque dierctories
 pause
 for /L %%f in (1,1, %_numClassQue%) do ( 
	echo list of classque
	
	echo  %%f is !_dir%%f!
	pause
)
 echo out of second for loop
 echo dir is %_dir% or !_dir! or %%_dir%%: _dir0 is %_dir0%: _dir1 is %_dir1%: dir2 is %_dir2%:
  SET _numClassQue=!_count!
  PAUSE
GOTO:_EXIST

