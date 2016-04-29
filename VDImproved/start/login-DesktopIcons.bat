@ECHO OFF
:: copies shortcuts from file to desktop, add/del shortcuts to folder below to add to desktop on statup
:: adds success or failure to log file
cd v:
cd \VDImproved\shortcuts
copy *Shortcut.lnk "%USERPROFILE%\Desktop" && (
GOTO:_PASS
) || (
GOTO:_FAIL
)

:_PASS
CALL v:\VDImproved\writeEvent.bat "login-DesktopIcons" "icons copied to desktop successfully" "P"
GOTO:_EOF

:_FAIL
CALL v:\VDImproved\writeEvent.bat "login-DesktopIcons" "failed to copy icons to desktop" "F"

:_EOF
::EOF
