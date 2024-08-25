@echo off
setlocal

:: Set parameters
set "AppFolderPath=%~dp0"
set "DownloadUrl=%1"
set "TEMP_DIR=%AppFolderPath%temp_update"
set "ZIP_FILE_PATH=%TEMP_DIR%\update.zip"
set "EXE_FILE_PATH=%AppFolderPath%vadavathoor_book_stall.exe"

:: Create temp directory if it doesn't exist
if not exist "%TEMP_DIR%" (
    mkdir "%TEMP_DIR%"
)

echo Downloading update...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%DownloadUrl%' -OutFile '%ZIP_FILE_PATH%'"
if %ERRORLEVEL% NEQ 0 (
    echo Download failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)
echo Download completed.

echo Unzipping new files...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_FILE_PATH%' -DestinationPath '%AppFolderPath%' -Force"
if %ERRORLEVEL% NEQ 0 (
    echo Unzip failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)
echo Unzipping completed.

echo Cleaning up...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -Path '%ZIP_FILE_PATH%' -Force; Remove-Item -Path '%TEMP_DIR%' -Recurse -Force"
if %ERRORLEVEL% NEQ 0 (
    echo Cleanup failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)
echo Cleanup completed.

echo Starting application...
start "" "%EXE_FILE_PATH%"
if %ERRORLEVEL% NEQ 0 (
    echo Application failed to start with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)
echo Application started successfully.

echo Update completed successfully!
pause
exit /b 0
