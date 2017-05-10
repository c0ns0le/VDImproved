@ECHO OFF
:: opens the log file for viewing after VDImporved is finished


Setlocal EnableDelayedExpansion
v:
SET _args="login-fin" "VDImproved finished" "P"

echo %_args%

CMD /C v:\VDImproved\writeEvent.bat&pause "login-fin" "VDImproved finished" "P" 

ENDLOCAL&EXIT /B 0
