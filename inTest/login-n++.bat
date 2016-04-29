@ECHO off
CALL v:\VDImproved\write_qlog.bat "login-chrome" "START"
:: Restore chrome and adds success or failure to log file

:: Checks c:\....APPDATA\Local for existing file structure and creates if needed
:: Copies backup chrome data from previous sessions

:: IMPORTANT you must logout using the logout shortcut icon on the desktop, or updated profile info will
:: 	not be saved


v:
if not exist "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" mkdir "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\"


copy /Y "V:\VDImproved\backup_restore\chrome\data\*" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" &&(
GOTO _PASS
)||(
GOTO _FAIL1
)

:_PASS
copy /Y "V:\VDImproved\backup_restore\chrome\FIRST RUN" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\" &&(
pause & GOTO _FIN
)||(
pause & GOTO _FAIL2
)

:_FAIL1
CALL v:\VDImproved\write_qlog.bat "login chrome" "failed to copy default folder" "F"
GOTO _EOF

:_FAIL2
CALL v:\VDImproved\write_qlog.bat "login chrome" "failed to copy file FIRSTRUN" "F"
GOTO _EOF

:_FIN
CALL v:\VDImproved\write_qlog.bat "login-chrome" "chrome sucessfully restored" "T"

:_EOF
::EOF