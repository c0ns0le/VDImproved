@echo on

::START "3443" cmd.exe
::v:
::cd \classque\3443-1
:: TIMEOUT /T 600 /NOBREAK

:: FOR %%F IN (Tue Thu) DO IF
::echo "%DATE:~0,3%" & pause 


echo %TIME% %/T% & pause 

echo %time:~0,2% & pause



pause
exit /b

:: shutdown -l — logoff
:: shutdown -t xx