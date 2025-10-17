@echo off
if "%~1"=="" (
    echo Error: file not specified
    echo Usage: touch filename
    exit /b 1
)

if exist "%~1" (
    copy /b "%~1"+,, "%~1" >nul
) else (
    type nul > "%~1"
)

exit /b 0
