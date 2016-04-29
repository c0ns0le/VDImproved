@ECHO OFF


pushd .
v:
if not exist \VDImproved\start mkdir v:\VDImproved\start\
cd \VDImproved\start

   for %%i in (login*.bat) do ( 
     pushd .
     call %%i 
     popd
   ) 
)
pop


CALL v:\VDImproved\write_qlog.bat "VDImproved" "startup successful" "P"

::EOF
