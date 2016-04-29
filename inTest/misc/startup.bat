pushd .
v:
if exist startup\ (
   cd \startup
   for %%i in (startup*.bat) do ( 
      pushd .
      call %%i
      popd
   )
)
pop
