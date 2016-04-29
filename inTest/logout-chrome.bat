@ECHO off
copy /Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Defaulty\*" "v:\VDImproved\chrome\data\" ||(
GOTO _FAIL
)
GOTO _FIN

:_FIN
copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\First Run" "v:\VDImproved\chrome\" ||(
GOTO _FAIL
)
::shutdown -l

:_FAIL
CALL v:\VDImproved\write_qlog.bat "logout-chrome" "failed to backup"
pause

::copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\First Run" "v:\VDImproved\chrome\"
::pause

::C:\Users\ahd227\AppData\Local\Google\Chrome\User Data