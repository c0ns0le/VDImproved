@ECHO off
:: Restore chrome and adds success or failure to log file

:: Checks c:\....APPDATA\Local for existing file structure and creates if needed
:: Copies backup chrome data from previous sessions

:: IMPORTANT you must logout using the logout shortcut icon on the desktop, or updated profile info will
:: 	not be saved


::Checks for existing chrome dirs in appdata, creates if needed
v:
if not exist "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" mkdir "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\"

::copies from VDImproved backup location to chrome default location
copy /Y "V:\VDImproved\backup_restore\chrome\data\*" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" &&(
GOTO _PASS
)||(
GOTO _FAIL1
)


::Copies the FIRST RUN file, eliminating popups
:_PASS
copy /Y "V:\VDImproved\backup_restore\chrome\FIRST RUN" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\" &&(
GOTO _SETDEFAULT 
)||(
GOTO _FAIL2
)


::Sets chrome as default browser, launches browser
:_SETDEFAULT
START "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "-silent -nosplash -setDefaultBrowser"
GOTO _FIN


::event logging
:_FAIL1
CALL v:\VDImproved\writeEvent.bat "login chrome" "failed to copy default folder" "F"
GOTO _EOF

:_FAIL2
CALL v:\VDImproved\writeEvent.bat "login chrome" "failed to copy file FIRSTRUN" "F"
GOTO _EOF



:_FIN
CALL v:\VDImproved\writeEvent.bat "login-chrome" "chrome sucessfully restored" "P"


:_EOF
::EOF