
:: @echo off


V:
if not exist v:\VDImproved\chrome\data\ mkdir v:\VDImproved\chrome\data\ & echo success
echo %0
pause
cmd /k v:\VDImproved\LogOut-WriteTest.bat
cd v:\inTest\
cmd /k runtest.bat
cmd /k copychrome.bat
pause


:: http://stackoverflow.com/questions/377407/detecting-how-a-batch-file-was-executed