@ECHO OFF
:: starts Xming to be used with SSH. SSH must be configured for use with x11 tunneling
:: adds success or failure to log file

C:
cd \Program Files (x86)\Xming\
START "" Xming.exe :0 -clipboard -multiwindow && (
GOTO:_PASS
)||(
GOTO:_FAIL
)

:_PASS
CALL v:\VDImproved\writeEvent.bat "login-Xming" "Xming started!" "P"
GOTO:_EOF

:_FAIL
CALL v:\VDImproved\writeEvent.bat "login-Xming" "failed to start" "F"


:_EOF
::EOF