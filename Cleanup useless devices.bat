@echo off
:: This is a batch file used to clean up useless devices in Device Manager.

:: Check for administrator privileges
:: -----------------------------------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
:: -----------------------------------

echo ============================
echo Windows Devices Cleanup Tool
echo ============================
echo.
echo Cleaning Useless Devices...

:: Call pnpclean.dll to clean up useless devices
Rundll32.exe C:\windows\system32\pnpclean.dll,RunDLL_PnpClean /Devices /Maxclean

echo.
echo Cleanup Completed!

pause