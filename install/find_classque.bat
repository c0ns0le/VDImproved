:: names of classque files and store as vars
::to be used to create new script files for each based on template
@ECHO ON
SETLOCAL ENABLEDELAYEDEXPANSION

v:
cd v:\classque
SET _count=
::the DIR command with flags will only print directories, no headers
::for each line, each dir name is stored in a variable
::variable names are dynamically created based on number of found dierctories
for /F %%p in ('DIR /A:D /B /ON') do (
	SET /a _count+=1
	::DEBUG ECHO _count !_count! : percent p is %%p :
	COPY v:\VDImproved\install\template.bat v:\VDImproved\start\
	REN v:\VDImproved\start\template.bat login-%%p.bat
	SET _dir!_count!=%%p
	pause
 )
IF NOT _count GOTO:_NOTFOUND
::the count is not being expanded so only one, the _dir var is created 
 echo out of firzt for loop
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


:_NOTFOUND
CALL v:\VDImproved\writeEvent.bat "%0" "No clasque files found" "F"
EXIT /B 2

:_EOF
ENDLOCAL