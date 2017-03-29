@ECHO ON
::This file copied to v:/startup which is created by classque else created by Install_VDImproved
pushd .
v:
echo one
pause 
if exist v:\VDImproved\start\ (
   cd v:\VDImproved\start\
   echo 2
   pause
   for %%i in (login*.bat) do ( 
	  echo 3
	  pause   
      pushd .
      call %%i
      popd
	  echo %i
	  pause
   )
)
echo 4
pause
pop