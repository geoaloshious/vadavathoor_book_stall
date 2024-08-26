String batchScript='''
@echo off
setlocal enabledelayedexpansion

:: Set parameters
set "AppFolderPath=%~dp0"
set "AppFolderPath=%AppFolderPath:~0,-1%"
set "DownloadUrl=%1"
set "TEMP_DIR=%AppFolderPath%\\temp_update"
set "ZIP_FILE_PATH=%TEMP_DIR%\\update.zip"
set "EXTRACT_DIR=%TEMP_DIR%\\extracted"
set "EXE_FILE_PATH=%AppFolderPath%\\vadavathoor_book_stall.exe"

echo ==============================
<nul set /p "=Step 1: Closing application... "
timeout /t 5 /nobreak >nul
echo [DONE]


echo ==============================
<nul set /p "=Step 2: Deleting existing files... "

:: Delete all files except update.bat
for %%F in (*) do (
    if /I not "%%~nxF"=="update.bat" if /I not "%%~nxF"=="%~nx0" del "%%F"
)

:: Delete all folders except folder 'database'
for /d %%D in (*) do (
    if /I not "%%D"=="database" rd /s /q "%%D"
)

echo [DONE]


echo ==============================
<nul set /p "=Step 3: Downloading update... "

:: Create temp directory if it doesn't exist
if not exist "%TEMP_DIR%" (
    mkdir "%TEMP_DIR%"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%DownloadUrl%' -OutFile '%ZIP_FILE_PATH%'"
if %ERRORLEVEL% NEQ 0 (
    echo Download failed with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)

echo [DONE]


echo ==============================
<nul set /p "=Step 4: Unzipping new files... "
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_FILE_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"
if %ERRORLEVEL% NEQ 0 (
    echo Unzip failed with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo [DONE]


echo ==============================
<nul set /p "=Step 5: Copying files to app directory... "
robocopy "%EXTRACT_DIR%" "%AppFolderPath%" /E /IS /IT
if %ERRORLEVEL% GEQ 8 (
    echo Copy failed with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo [DONE]


echo ==============================
<nul set /p "=Step 6: Cleaning up...: "%TEMP_DIR%" "
if not exist "%TEMP_DIR%" (
    echo Warning: Temp directory not found: "%TEMP_DIR%"
    goto :cleanup_done
)


timeout /t 5 /nobreak >nul
rmdir /S /Q "%TEMP_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo Cleanup failed with error code %ERRORLEVEL%.
    echo Path attempted: "%TEMP_DIR%"
    echo Current directory:
    cd
    echo Directory contents:
    dir
    pause
    exit /b %ERRORLEVEL%
)
echo [DONE]

echo ==============================
<nul set /p "=Step 7: Starting application... "

start "" "%EXE_FILE_PATH%"
if %ERRORLEVEL% NEQ 0 (
    echo Application failed to start with error code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)
echo [DONE]


echo ==============================
echo Update completed successfully!
echo ==============================
echo The window will close in 5 seconds...
:: timeout /t 5 >nul
:: exit
''';