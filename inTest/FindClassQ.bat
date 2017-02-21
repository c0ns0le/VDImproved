#http://stackoverflow.com/questions/1515965/how-to-input-a-string-from-user-into-environment-variable-from-batch-file
#http://stackoverflow.com/questions/14834625/reading-text-file-in-batch-script
#http://stackoverflow.com/questions/4788863/how-to-send-series-of-commands-to-a-command-window-process?noredirect=1&lq=1
#http://stackoverflow.com/questions/15557801/batch-dialogue-to-choose-directory-to-run-batch?noredirect=1&lq=1


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
