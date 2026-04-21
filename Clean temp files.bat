@echo off
:: This is a batch file used to clean temporary files in User folder and Windows folder.

:: Check for administrator privileges
:: -----------------------------------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
:: -----------------------------------

echo ==============================
echo Windows Temp File Clean Tool
echo ==============================
echo.
echo Cleaning Temporary Files...

:: Clean temp files in User folder
del /s /f /q "%TEMP%\*.*" >nul 2>&1
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1

:: Clean temp files in Windows folder
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
md "C:\Windows\Temp" >nul 2>&1

echo.
echo Cleanup Completed!

pause