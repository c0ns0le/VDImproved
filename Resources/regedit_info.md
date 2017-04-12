Modifying registry keys is a way to backup and restore certain prefences and settings
or as a way to share settings. 


[About .reg files. The below is copied directly from the MS support page](https://support.microsoft.com/en-us/help/310516/how-to-add,-modify,-or-delete-registry-subkeys-and-values-by-using-a-.reg-file) 



#####Table of Contents

- [Deleting Keys](#dkey)
- [Renaming Keys](#rkey)
- [Implementing Changes](#impkey)

<div id='dkey'/>
#####Deleting Keys

To delete a registry key with a .reg file, put a hyphen (-) in front of the RegistryPath in the .reg file. For example, to delete the Test subkey from the following registry key:
HKEY_LOCAL_MACHINE\Software
put a hyphen in front of the following registry key in the .reg file:
HKEY_LOCAL_MACHINE\Software\Test
The following example has a .reg file that can perform this task.
[-HKEY_LOCAL_MACHINE\Software\Test]
To delete a registry value with a .reg file, put a hyphen (-) after the equals sign following the DataItemName in the .reg file. For example, to delete the TestValue registry value from the following registry key:
HKEY_LOCAL_MACHINE\Software\Test
put a hyphen after the "TestValue"= in the .reg file. The following example has a .reg file that can perform this task.
HKEY_LOCAL_MACHINE\Software\Test
"TestValue"=-
To create the .reg file, use Regedit.exe to export the registry key that you want to delete, and then use Notepad to edit the .reg file and insert the hyphen. 


<div id='rkey'/>
#####Renaming Keys
Renaming Registry Keys and Values

To rename a key or value, delete the key or value, and then create a new key or value with the new name.


<div id='impkey'/>
#####Implementing Registry Changes

The commands being used. It is important to note that the import merges changes. 
REG EXPORT KeyName FileName 
	HKEY_CURRENT_USER\Console


REG IMPORT FileName
