C:
cd C:\Users\ahd227\AppData\Roaming\
if exist /SSH/default.ssh2(
del /F /Q default.ssh2
)
xcopy v:\startup\default.ssh2 "C:\Users\ahd227\AppData\Roaming\SSH\" /c /Y
xcopy v:\startup\global.dat "C:\Users\ahd227\AppData\Roaming\SSH\" /c /Y
if exist hostkeys\ (
del /F /Q hostkeys
)
xcopy v:\startup\HostKeys "C:\Users\ahd227\AppData\Roaming\SSH\" /c /Y
start default.ssh2

