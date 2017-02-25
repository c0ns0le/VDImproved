REM REM @ECHO OFF

REM SETLOCAL ENABLEDELAYEDEXPANSION
REM bash c:\Program Files\Git\git-bash.exe
REM commands to automate commits to github
REM from v:\VDImproved 
REM to add all new files to index -> git add . 

REM Commit -> is creating new pointer to staged blob (index), with pointer to prev commit(s) and metadata
REM to commit with modified and removed files, msg -> git commit -a -m 'changes made'

REM to create new branch -> git branch newname
:: Tracking occures when using checkout,  with -b if not exist -> new branch created
REM to switch to new branch -> git checkout newname
:: FETCH does NOT update local branch, only gets them
REM to check server for updates -> git fetch origin
:: PUll is a fetch and merge when used on a tracking branch,which automatic when using clone