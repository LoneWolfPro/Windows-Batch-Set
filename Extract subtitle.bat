@echo off

:: Check ffmpeg availability
ffmpeg -version >nul 2>&1
if errorlevel 1 (
  echo Error: ffmpeg not found in PATH.
  echo Please install ffmpeg and add it to your PATH, then run this script again.
  pause
  exit /b 1
)

echo ========================
echo Subtitle Extraction Tool
echo ========================

:: Get file path from user input
set /p "filepath=Please enter the video file path (with quotes): "

:: Remove double quotes
set "filepath=%filepath:"=%"

:: Check if the path is valid.
if "%filepath%"=="" (
  echo No input provided.
  echo Script exit.
  pause
  exit /b 1
)
if not exist "%filepath%" (
  echo File "%filepath%" not found.
  echo Script exit.
  pause
  exit /b 1
)

echo.
echo Listing subtitle streams for "%filepath%":
echo ----------------------------------------
ffmpeg -hide_banner -i "%filepath%" 2>&1 | findstr /i "Stream.*Subtitle" || echo No subtitle streams found.
echo ----------------------------------------
echo.

:: Ask which subtitle stream index to extract
echo Note: subtitle stream index here is the subtitle-stream number (0,1,2...) relative to subtitle streams.
set /p "sindex=Enter subtitle stream index to extract (e.g. 0): "

:: Basic numeric validation: ensure sindex contains only digits
for /f "delims=0123456789" %%A in ("%sindex%") do (
  echo Invalid index. Please enter a non-negative integer.
  echo Script exit.
  pause
  exit /b 1
)

:: Ask desired output format
:askfmt
set /p "fmt=Choose output format (ass or srt): "
if /i "%fmt%"=="ass" (
  set "outext=ass"
  set "codec=copy"
) else if /i "%fmt%"=="srt" (
  set "outext=srt"
  set "codec=srt"
) else (
  echo Invalid format. Please type ass or srt.
  goto askfmt
)

:: Set output file path
set "outfile=%filepath%_sub%sindex%.%outext%"

:: Run ffmpeg to extract/convert subtitle
echo.
echo Extracting subtitle stream %sindex% to "%outfile%" ...
echo.
if /i "%codec%"=="copy" (
  ffmpeg -y -hide_banner -loglevel info -i "%filepath%" -map 0:s:%sindex% -c:s copy "%outfile%"
) else (
  ffmpeg -y -hide_banner -loglevel info -i "%filepath%" -map 0:s:%sindex% -c:s %codec% "%outfile%"
)

if errorlevel 1 (
  echo Extraction failed.
  pause
  exit /b 1
)

echo.
echo Extraction finished: "%outfile%"

pause