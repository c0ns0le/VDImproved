@ECHO ON
::for error checks after taskkill && CALL v:\VDImproved\write_qlog.bat "DIE JAVA" "java DEAD" "P"  
::&& is succes then
::& EXEC 1 then 2

v:

SET _AN=0
SET _AW=0
:_REPEAT
(TASKLIST /FI "IMAGENAME eq java.exe") && (
	SET /A "_AN+=1"	
	ECHO %_AN% & pause
	TIMEOUT /T 45
	GOTO:_JAVAP
) || GOTO:_PETE


:_PETE
TASKLIST /FI "IMAGENAME eq javaw.exe" && (
	SET /A "_AW+=1"
	ECHO %_AW% & pause	
	TIMEOUT /T 45
	GOTO:_JAVAW
) || GOTO:_REPEAT

:_JAVAP
TASKKILL /IM java.exe /T /F 
GOTO:_EOF
 

:_JAVAW
TASKKILL /IM javaw.exe /T /F 
echo "kill javaw" & pause
GOTO:_EOF

:_EOF
ECHO EOF & pause
EXIT
::EOF


::"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -silent -nosplash -setDefaultBrowser