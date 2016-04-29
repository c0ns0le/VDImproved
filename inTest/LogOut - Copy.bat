
:: @echo off


V:
if not exist v:\VDImproved\chrome\data\ mkdir v:\VDImproved\chrome\data\
echo %PATH%
pause
LogOut-WriteTest.bat

tasklist /FI "IMAGENAME eq chrome.exe" | findstr "chrome.exe" >nul
echo %%ERRORLEVEL%%
pause
DO if %ERRORLEVEL% == 1 goto FIN else goto DIE



:DIE
pause
taskkill /FI "IMAGENAME eq chrome.exe" /T /F & GOTO FIN
pause



:FIN
pause
copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*" "v:\VDImproved\chrome\data\"
copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\First Run" "v:\VDImproved\chrome\"
pause
exit /B
:: shutdown -l


::EOF

::echo off
::SETLOCAL EnableExtensions
::set EXE=YourProgram.exe
::FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% goto FOUND
::echo Not running
::pause
::goto FIN

::FOUND
::echo Running
::pause
:FIN

:: http://stackoverflow.com/questions/377407/detecting-how-a-batch-file-was-executed