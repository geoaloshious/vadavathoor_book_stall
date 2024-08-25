String batchScript='''
@echo off
setlocal enabledelayedexpansion

:: Set parameters
set "AppFolderPath=%~dp0"
set "DownloadUrl=%1"
set "TEMP_DIR=%AppFolderPath%temp_update"
set "ZIP_FILE_PATH=%TEMP_DIR%\\update.zip"
set "EXTRACT_DIR=%TEMP_DIR%\\extracted"
set "EXE_FILE_PATH=%AppFolderPath%vadavathoor_book_stall.exe"


:: Kill existing instance of the application
echo ==============================
echo Step 3: Closing existing application...
echo ==============================
taskkill /F /IM "vadavathoor_book_stall.exe" >nul 2>&1
timeout /t 2 >nul


:: Delete all files except update.bat
for %%F in (*) do (
    if /I not "%%~nxF"=="update.bat" if /I not "%%~nxF"=="%~nx0" del "%%F"
)

:: Delete all folders except folder 'database'
for /d %%D in (*) do (
    if /I not "%%D"=="database" rd /s /q "%%D"
)

:: Create temp directory if it doesn't exist
if not exist "%TEMP_DIR%" (
    mkdir "%TEMP_DIR%"
)

:: Download update
echo ==============================
echo Step 1: Downloading update...
echo ==============================
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%DownloadUrl%' -OutFile '%ZIP_FILE_PATH%'"
if %ERRORLEVEL% NEQ 0 (
    echo Download failed with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo Download completed.

:: Unzip new files
echo ==============================
echo Step 2: Unzipping new files...
echo ==============================
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_FILE_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"
if %ERRORLEVEL% NEQ 0 (
    echo Unzip failed with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo Unzipping completed.


:: Copy files to app directory
echo ==============================
echo Step 4: Copying files to app directory...
echo ==============================
robocopy "%EXTRACT_DIR%" "%AppFolderPath%" /E /IS /IT
if %ERRORLEVEL% GEQ 8 (
    echo Copy failed with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo Copy completed.



:: Cleanup
echo ==============================
echo Step 5: Cleaning up...
echo ==============================
rmdir /S /Q "%TEMP_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo Cleanup failed with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo Cleanup completed.

:: Start the application
echo ==============================
echo Step 6: Starting application...
echo ==============================
start "" "%EXE_FILE_PATH%"
if %ERRORLEVEL% NEQ 0 (
    echo Application failed to start with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo Application started successfully.


echo ==============================
echo Update completed successfully!
echo ==============================
pause
exit /b 0
''';