@ECHO OFF
:: opens the log file for viewing after VDImporved is finished


Setlocal EnableDelayedExpansion
v:
set _args="login-fin" "VDImproved finished" "P"

echo %_args%

CMD /C "v:\VDImproved\writeEvent.bat&pause""login-fin" "VDImproved finished" "P" 

::%_args%


:_EOF