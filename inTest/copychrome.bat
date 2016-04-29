@echo on
copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*" "v:\VDImproved\chrome\data\" 
echo %ERRORLEVEL%
pause
::|| (
START "CAKE" cmd /k v:\VDImproved\write_qlog.bat "chrome_backup" "no backup"
::)
copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\First Run" "v:\VDImproved\chrome\" 
pause

exit /B
:: shutdown -l