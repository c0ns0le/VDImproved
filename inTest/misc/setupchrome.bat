mkdir V:\startup
mkdir V:\chromesave
mkdir V:\chromesave\Data
V:
cd \
if not exist startup.bat (
   wget http://classque.cs.utsa.edu/classes/setup/startup.bat -O startup.bat
)
copy "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*" v:\chromesave\Data\
copy "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Preferences" v:\chromesave\Data\
copy "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Cookies" v:\chromesave\Data\
copy "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Current Session" v:\chromesave\Data\
copy "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Current Tabs" v:\chromesave\Data\
copy "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Web Data" v:\chromesave\Data\
copy "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Shortcuts" v:\chromesave\Data\
cd ..
cd startup
   wget http://classque.cs.utsa.edu/classes/setup/startuprestorechrome.bat -O startuprestorechrome.bat
