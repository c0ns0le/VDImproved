::RESTORES several system and program preferens via the registry. 
c:
REG IMPORT HKEY_CURRENT_USER\Console "V:\VDImproved\backup_restore\Preferences\console.reg" 

::TODO add git automation
:_GIT


:_MS
REG IMPORT HKEY_CURRENT_USER\Software\Microsoft\Office\15.0 "V:\VDImproved\backup_restore\Preferences\office.reg" 
REG IMPORT HKEY_USERS\S-1-5-18\Software\Microsoft\VisualStudio "V:\VDImproved\backup_restore\Preferences\visualstudio.reg"