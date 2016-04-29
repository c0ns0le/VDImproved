@echo off
v:
if not exist "v:\VDImproved\ITSAMOTHERFUCKINGTEST.txt" GOTO NEW
GOTO WRITE

:NEW 
echo> v:\VDImproved\chrome\ITSAMOTHERFUCKINGTEST.txt
GOTO WRITE

exit -b

:WRITE
DATE /T >> v:\VDImproved\chrome\ITSAMOTHERFUCKINGTEST.txt
TIME /T >> v:\VDImproved\chrome\ITSAMOTHERFUCKINGTEST.txt
GOTO EXIT1

:EXIT1
exit -b
:: start "EXIT 1 Mother Fucker" cmd.exe
:: start "WROTE A NEW ONE Mother Fucker" cmd.exe