@echo off
:: This is a batch file used to create an empty .sys file in the C:\Windows\System32\drivers folder. It is useful for resolving issues where EAC anti-cheat detects an unknown driver that is loaded but does not exist.

:: Check for administrator privileges
:: -----------------------------------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
:: -----------------------------------

echo ============================================
echo Empty .SYS File Creator for System32\drivers
echo ============================================

:: Get file name from user input
:getFilename
set "filename="
set /p "filename=Please enter the file name (without .sys extension): "
if "%filename%"=="" (
    echo Error: File name cannot be empty!
    goto getFilename
)

:: Set full file path
set "filePath=C:\Windows\System32\drivers\%filename%.sys"
echo.
echo You are about to create an empty file: %filePath%
echo.

:: Confirm with user
:confirm
set "choice="
set /p "choice=Do you want to continue? (Y/N): "

if /i "%choice%"=="y" goto createFile
if /i "%choice%"=="n" (
    echo Operation cancelled.
    pause
    exit /b
)
goto confirm

:: Creat file
:createFile
echo.
echo Creating empty file...
:: Check if a file exists
if exist "%filePath%" (
    echo Error: File already exists: %filePath%
    echo Operation aborted to avoid overwriting.
    pause
    exit /b
)
:: Create empty file using copy nul method
copy nul "%filePath%" >nul
if %errorlevel% equ 0 (
    echo Successfully created empty file: %filePath%
) else (
    echo Error: Failed to create file!
    echo Please check permissions and try again.
    echo Script exit.
)

pause