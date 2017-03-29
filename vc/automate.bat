REM REM @ECHO OFF

REM SETLOCAL ENABLEDELAYEDEXPANSION
REM bash c:\Program Files\Git\git-bash.exe
REM commands to automate commits to github
REM from v:\VDImproved 
REM to add all new files to index -> "git add ." NOTE: the period must be included, it indicates all files 
BASICS 
	(ALL Local, until a push)
	Git has three main states that your files can reside in: committed, modified, and staged. 
		Committed means that the data is safely stored in your local database. 
		Modified/untracked means that you have changed the file or created a new one( new files are marked as untracked) but have not
			committed it to your database yet. Use the git status command to view the status of a file. 
		Staged means that you have marked a modified file in its current version to go into your next commit snapshot. 
			After the commit all files are marked as unmodified until any changes are made
	
	The basic Git workflow goes something like this:
		modify (or create new) files in your working tree.
		stage the files, adding snapshots of them to your staging area.
		commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.
		
	push <remote> <branch>	
	
COMMANDS

REM git add => a multi-use command used to stage new, modified or merge resolved files. 
:: Any changes to a file made after the "add" command will NOT be included in a commit, unless git add is run again

REM Commit => is creating new pointer to staged blob (index), with pointer to prev commit(s) and metadata

REM git commit -a -m 'changes made' => to commit with modified and removed files, msg, etc

REM git branch newname => to create new branch  
:: Tracking occures when using checkout,  with -b if not exist -> new branch created

REM git status => to see which files have not been merged, not been staged and those that are untracked either due to new work
REM					or to merge conmflict, etc 
REM git checkout newname => to switch to new branch

:: FETCH does NOT update local branch, only gets them
REM git fetch origin => to check server for updates not found locally, NO files wil be modified at this step, a manual merge must be performed
REM git PUll => is a fetch and merge when used on a tracking branch,which automatic when using clone
:: this is to pull down the changes located "upstream" and merge them with the local files. 


REM git push <remote> <branch> => remote is default set to origin and branch default is set to master, althought often changed as needed
:: or to specify a branch to push to the remote using default names
REM git push origin master:<specific branch name>


8Z653h3h^