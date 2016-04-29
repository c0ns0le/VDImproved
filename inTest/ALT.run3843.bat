
:: %date% sets variable
set /A h=%time:~0,2%
set day=0%day:~1,1%
if day==MON || day==WED(
if h GEQ 15 (
v:
cd \classque\3843
start /B java -jar classque-3843.jar
)) else ( /I %ERRORLEVEL% NEQ 0 (
    EXIT /B %ERRORLEVEL%
)
EXIT /B %ERRORLEVEL%