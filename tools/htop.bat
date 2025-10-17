echo off && cls
set "HTOP=https://github.com/gsass1/NTop/releases/download/v0.3.21/NTop.exe"
echo Downloading "NTOP" (Thx for @gsass1), htop analogue...
echo Download URL: "%HTOP%"
echo.
echo.
powershell -Command "Invoke-WebRequest '%HTOP%' -OutFile 'htop.exe'"
timeout /t 1 > nul