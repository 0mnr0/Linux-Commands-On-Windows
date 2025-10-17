@echo off
chcp 1251 > nul

title Linuxify


rem Ask for admin bc we need to copy files into System32 folder
setlocal enableextensions
pushd "%~dp0"
set PATH=%cd%;%PATH%
if defined PROCESSOR_ARCHITEW6432 start "" %SystemRoot%\sysnative\cmd.exe /c "%~nx0" %* & goto :EOF
net session >nul 2>&1 || (
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
	echo UAC.ShellExecute "%~nx0", "%*", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
	cscript //NOLOGO "%temp%\GetAdmin.vbs"
	del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
	exit
)

rem Setup Colors
for /f "delims=" %%A in ('echo prompt $E^| cmd') do set "ESC=%%A"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "END=%ESC%[0m"

set "System32=%SystemRoot%\System32"
set "ClearCommand=%SystemRoot%\System32\clear.bat"
set "CatCommand=%SystemRoot%\System32\cat.bat"
set "TouchCommand=%SystemRoot%\System32\touch.bat"
set "HTOPCommand=%SystemRoot%\System32\htop.exe"
set "NANOCommand=%SystemRoot%\System32\nano.exe"


:m1
cls
set choice=""
set IsAllInstalled=false
if exist "%ClearCommand%" if exist "%CatCommand%" if exist "%TouchCommand%" if exist "%HTOPCommand%" if exist "%NANOCommand%" (
	set IsAllInstalled=true
)
echo  Action list:
echo.
echo.
if "%IsAllInstalled%" == "true" (
	echo   [0]  Remove All Vanilla Commands
) else (
	echo   [0]  Install All Vanilla Commands
)
echo.

if exist "%ClearCommand%" (
	echo  %GREEN% [1] clear %END%- Remove command
) else (
	echo  %RED% [1] clear %END%- Install the command
)
if exist "%CatCommand%" (
	echo  %GREEN% [2] cat %END%  - Remove command
) else (
	echo  %RED% [2] cat %END%  - Install the command
)
if exist "%TouchCommand%" (
	echo  %GREEN% [3] touch %END%- Remove command
) else (
	echo  %RED% [3] touch %END%- Install the command
)
if exist "%HTOPCommand%" (
	echo  %GREEN% [4] htop %END% - Remove command
) else (
	echo  %RED% [4] htop %END% - Download And Install command
)
if exist "%NANOCommand%" (
	echo  %GREEN% [5] nano %END% - Remove command
) else (
	echo  %RED% [5] nano %END% - Install the command
)
echo   exit - To exit :)



echo.
Set /p choice="  Execute Command: "
if not defined choice goto m1
cls
if "%choice%"=="0" (goto setupall)
if "%choice%"=="1" (goto setclearcommand)
if "%choice%"=="2" (goto setcatcommand)
if "%choice%"=="3" (goto setuptouch)
if "%choice%"=="4" (goto setuphtop)
if "%choice%"=="5" (goto setupnano)
if "%choice%"=="exit" (exit)
if "%choice%"=="e" (exit)
echo.
echo Invalid Choice
echo.
pause
goto m1

:setupall
	if "%IsAllInstalled%" == "true" (
		del /q "%ClearCommand%"
		del /q "%CatCommand%"
		del /q "%TouchCommand%"
		echo All tools was removed!
	) else (
		xcopy "scripts" "%System32%" /E /I /Y
		echo.
		echo All tools was installed!
	)
	echo.
	pause
	goto m1

:setupnano
	rem I am sorry that i've just put an .exe file in a repo, but I have not yet made 7Zip support to decompress zip files without additional programs, as I strive for compatibility.
	rem You can check hashes here if you dont trust me: https://github.com/okibcn/nano-for-windows/releases/download/v7.2-22.1/nano-for-windows_win32_v7.2-22.1.zip
	
	if not exist "tools/nano.exe" (
		echo nano.exe is not found, did you delete it? Let me download the file again, ok?
		timeout /t 5
		echo.
		set "nanourl=https://github.com/0mnr0/Linux-Commands-On-Windows/raw/refs/heads/main/tools/nano.exe"
		powershell -Command "Invoke-WebRequest '%nanourl%' -OutFile 'nano.exe'"
		copy nano.exe tools
		del /q nano.exe
		timeout /t 1 > nul
		cls
	)
	
	if exist "%NANOCommand%" (
		del /q "%NANOCommand%"
		echo Nano command was removed!
	) else (
		copy "tools\nano.exe" "%System32%" /Y
		echo.
		echo Nano was installed!
	)
	echo.
	pause
	goto m1

:setuphtop
	if exist "%HTOPCommand%" (
		del /q %HTOPCommand%
		echo.
		echo htop was removed
	) else (
		call tools/htop.bat
		copy htop.exe %System32%
		del /q htop.exe
		echo.
		echo htop command should be now installed
	)
	echo.
	pause
	goto m1


:setclearcommand
if exist %ClearCommand% (
	del /q "%ClearCommand%"
	echo Program "clear" was removed from "%ClearCommand%"
	echo.
	pause
	goto m1
) else (
	xcopy /q "scripts\clear.bat" "%System32%"
	
	echo.
	echo Program "clear" was created in "%ClearCommand%"
	echo You can use clear command in any console now!
	echo.
	pause
	goto m1
)	



:setcatcommand
if exist %CatCommand% (
	del /q "%CatCommand%"
	echo Program "cat" was removed from "%CatCommand%"
	echo.
	pause
	goto m1
) else (
	xcopy /q "scripts\cat.bat" "%System32%"

	echo.
	echo Program "cat" was created in "%CatCommand%"
	echo You can use "cat file.txt" command in any console now!
	echo.
	pause
	goto m1
)

:setuptouch
if exist %TouchCommand% (
	del /q "%TouchCommand%"
	echo Program "cat" was removed from "%TouchCommand%"
	echo.
	pause
	goto m1
) else (
	xcopy /q "scripts\touch.bat" "%System32%" > nul

	echo.
	echo Program "touch" was created in "%TouchCommand%"
	echo You can use "touch file.txt" command in any console now!
	echo.
	pause
	goto m1
)