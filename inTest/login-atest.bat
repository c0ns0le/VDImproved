v:
@echo off
FOR /F "TOKENS=3" %%D IN ('REG QUERY ^"HKEY_CURRENT_USER\Control Panel\International^" /v sTime ^| find ^"REG_SZ^"') DO (
        SET _time_sep=%%D)
echo %_time_sep%
exit -b
start "TESTING Mother Fucker" cmd.exe