if
mkdir V:\chrom
mkdir V:\chrome\data
:: copy from chrome files to backup location
copy "\%APPDATA%\Local\Google\Chrome\User data\Default\*" v:\chrome\data\
copy "\%APPDATA%\Local\Google\Chrome\User data\Default\Preferences" v:\chrome\data\
copy "\%APPDATA%\Local\Google\Chrome\User data\Default\Cookies" v:\chrome\data\
copy "\%APPDATA%\Local\Google\Chrome\User data\Default\Current Session" v:\chrome\data\
copy "\%APPDATA%\Local\Google\Chrome\User data\Default\Current Tabs" v:\chrome\data\
copy "\%APPDATA%\Local\Google\Chrome\User data\Default\Web Data" v:\chrome\data\
copy "\%APPDATA%\Local\Google\Chrome\User data\Default\Shortcuts" v:\chrome\data\

robocopy "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default" "v:\startup\chrome" *.*
