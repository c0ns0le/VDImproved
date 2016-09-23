About
=

[TL;DR skip to the instructions](#instr)

#####Table of Contents

- [Why](#why)
- [Instructions](#instr)
- [ClassQue Setup](#cque)

<div id='why'/>
#####Why?

In school, UTSA, certain classes require we use the VDI (virtual desktop infastructure) 
which was implemented in the new CS building. 

While there are many, many benefits of a setup such as this, there can be drawbacks. 
The VDI is implememted in such a way that upon every logon from the user the VM treats 
this as the first time that user has logged in. 

Every time, certain programs run, they go through a first run. The specifics differ from program to program
and from no user impact to a decent cumulative waste of time and the annoyance of doing something repetitively.
As with most other programmers, I abhor this and attemp to automate or bypass all together.


<div id='instr'/>
#####Instructions

It is important to retain the directory structure for file dependancies.
UTSA will only keep changes made to a network drive with a 3 letter 3 number ID, mounted as the V drive. 

-Extract all files to  V:\
-Execute the V:\VDImproved/startup.bat or restart and the automation will now run at startup

<div id='cque'/>
#####ClassQue Setup


