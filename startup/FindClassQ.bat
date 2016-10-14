#search for classQ folder on Z
#on true cd into folder
#if search all files for java file ext true
  #write java file name to EV CQNAME
#endif
#LABEL CQNAME
#if CQNAME true
  #prompt user to enter 1 for MWF, 2 MW, 3 TuTh 
  # if input eq then 1 set ev CQDAY - MWF
       #call label CQTIME
  #if eq 2 set ev CQDAY - MW
        #call label CQTIME
  #if eq 3 set ev CQDAY - TuTh
        #call label CQTIME
  #change existing scripts to look for EV's
#endif

#LABEL CQTIME
#prompt user to enter: 1 = 8-9a, 2 = 9-10... 12 = 8-9p
        #set ev CQTIME to corresponding
        #return
