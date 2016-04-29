::backups important chrome data to be restored on startup
@echo off

C:\Users\ahd227\AppData\Local\Microsoft\Office\15.0
V:
if not exist "v:\VDImproved\backup_restore\chrome\data\" mkdir "v:\VDImproved\backup_restore\chrome\data\"
if tasklist /FI "IMAGENAME eq chrome.exe" GOTO _DIECHROME 
GOTO _CPCHROME


:_DIECHROME 
pause
taskkill /FI "IMAGENAME eq chrome.exe" /T /F 
GOTO _CPCHROME


:_CPCHROME
copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*" "v:\VDImproved\backup_restore\chrome\data\"
copy -Y "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\First Run" "v:\VDImproved\backup_restore\chrome\"
pause
GOTO _MS


:_MS
if not exist "v:\VDImproved\backup_restore\\Microsoft\Office\15.0\" mkdir "v:\VDImproved\backup_restore\\Microsoft\Office\15.0\"
copy -Y "C:\Users\%USERNAME%\AppData\Local\Microsoft\Office\15.0\*" "v:\VDImproved\backup_restore\Microsoft\Office\15.0\"
GOTO _FIN


:_FIN
pause
shutdown -l


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

:_EOF

::EOF