@echo off
:: This is a batch file used to calculate the MD5 value of all files in a specific folder.

echo ====================
echo MD5 Calculation Tool
echo ====================

:: Get folder path from user input
:getfolderpath
set "folderpath="
set /p "folderpath=Please enter the folder path (with quotes): "

:: Remove double quotes
set "folderpath=%folderpath:"=%"

:: Check if the path is valid.
if "%folderpath%"=="" (
  echo No input provided.
  echo Script exit.
  pause
  exit /b 1
)
if not exist "%folderpath%" (
  echo Folder "%folderpath%" not found.
  echo Script exit.
  pause
  exit /b 1
)

:: Set output file path
set "output=%folderpath%\MD5 Result.txt"

:: Clear or create the output file
echo.
echo The MD5 values of the files within the folder [%folderpath%] are as follows: > "%output%" 

:: Traverse all files in the folder
for /r "%folderpath%" %%f in (*) do (
    echo Calculating: %%f
    for /f "tokens=* delims=" %%a in ('certutil -hashfile "%%f" MD5 ^| findstr /r "^[0-9a-fA-F]" ^| findstr /v "CertUtil"') do (
            echo %%a %%f >> "%output%"
            echo %%a %%f
    )
)

echo.
echo Calculation complete. The MD5 values of all files have been saved to: %output%

pause