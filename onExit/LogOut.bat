@ECHO on
:: First checks if chrome.exe is running, if true kills proc
:: copies def chrome data from session into backup location to 
:: retrieved at next startup

::copy /Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*" "V:\VDImproved\backup_restore\chrome\data\" 
CALL v:\VDImproved\write_qlog.bat "logout chrome" "copydir" "P" 
GOTO:EOF


v:
::TASKLIST /FI "IMAGENAME eq chrome.exe" && GOTO:_DIE || GOTO:_BACKUP


:_DIE 
::pause
::TASKKILL /IM chrome.exe /T /F && GOTO:_BACKUP
::pause
::GOTO:_START
 


::GOTO:_BACKUP
::echo "in b up"
::pause
:: checks if backup location exists, if not creates directory
::IF NOT EXIST "V:\VDImproved\backup_restore\chrome\data\" mkdir "V:\VDImproved\backup_restore\chrome\data\" &&(
::CALL v:\VDImproved\write_qlog.bat "logout" "exists" "P" 
::GOTO:_COPYDIR
::)||(
::GOTO:_FAIL0
::)


:_COPYDIR
::pause
copy /Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*" "V:\VDImproved\backup_restore\chrome\data\" 
::&&(
CALL v:\VDImproved\write_qlog.bat "logout chrome" "copydir" "P" 
GOTO:_FIN
::GOTO:_COPYFIRSTRUN
::)||(
::GOTO _FAIL2
::)


:_COPYFIRSTRUN
::pause
::IF EXIST "V:\VDImproved\backup_restore\chrome\FIRST RUN" && GOTO:_FIN
::copy /Y "V:\VDImproved\backup_restore\chrome\FIRST RUN" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\" &&(
::CALL v:\VDImproved\write_qlog.bat "logout chrome" "copied first" "P" 
::GOTO:_FIN
::)||(
::GOTO:_FAIL2
::)


:_FAIL0
pause
CALL v:\VDImproved\write_qlog.bat "logout chrome" "mkdir default folder" "F"
pause
GOTO:EOF


:_FAIL1
pause
CALL v:\VDImproved\write_qlog.bat "logout chrome" "Copy default folder" "F"
pause
GOTO:EOF


:_FAIL2 
pause
CALL v:\VDImproved\write_qlog.bat "logout chrome" "Copy file FIRSTRUN" "F"
pause
GOTO:EOF


:_FIN 
pause
CALL v:\VDImproved\write_qlog.bat "logout chrome" "Backup sucessfull"  "P"
pause

::EOF







