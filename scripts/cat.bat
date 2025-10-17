@echo off
if "%~1"=="" (
    type CON
    exit /b
)

for %%F in (%*) do (
    if exist "%%~F" (
        type "%%~F"
    ) else (
        echo File not found: %%F
    )
	echo.
)

exit /b
