@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

v:
cd classque
DIR /B /ON >> "v:\VDImproved\install\list_classque.txt"
IF not exist ("v:\VDImproved\install\list_classque") (
ECHO No classque files found
PAUSE
GOTO:_NOTFOUND
)

set "_dir=DIR /A:D /B /ON" "

for /F "delims=*" %%p in ('!_dir! ^| findstr "chrome.exe" ') do (

)
GOTO:_EXIST

::need to read from new file the names of classque files and store as vars
::to be used to create new script files for each based on templates

:_NOTFOUND
CALL v:\VDImproved\writeEvent.bat "%0" "No clasque files found" "F"
EXIT /B 1

:_EOF
ENDLOCAL