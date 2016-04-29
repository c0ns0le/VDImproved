@ECHO on

:: runs at login to restore chrome

:: Checks c:\....APPDATA\Local for existing file structure and creates if needed
:: Copies backup chrome data from previous sessions

:: IMPORTANT you must logout using the logout shortcut icon on the desktop, or updated profile info will
::   not be saved


v:
if not exist "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" mkdir "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\"

copy /Y V:\VDImproved\chrome\data\* "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\" ||(
GOTO _FAIL
)



copy /Y "V:\VDImproved\chrome\FIRST RUN" "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\" ||(
GOTO _FAIL
)
GOTO _PASS

:_FAIL
CALL v:\VDImproved\write_qlog.bat "login-chrome" "failed to restore chrome"


:_PASS
CALL v:\VDImproved\write_qlog.bat "login-chrome" "Restore chrome sucess!!!!!!!!!"
Folders Properties