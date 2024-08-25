String appUpdationScript='''
param (
    [Parameter(Mandatory=\$true)]
    [string]\$AppFolderPath,

    [Parameter(Mandatory=\$true)]
    [string]\$DownloadUrl
)

# Function to print status messages
function Print-Status {
    param (
        [string]\$status
    )
    Write-Host \$status -ForegroundColor Green
}

# Run your script
try {
    \$TEMP_DIR = Join-Path \$AppFolderPath "temp_update"
    \$ZIP_FILE_PATH = Join-Path \$TEMP_DIR "update.zip"
    \$EXE_FILE_PATH = Join-Path \$AppFolderPath "vadavathoor_book_stall.exe"

    # Create temp directory if it doesn't exist
    if (-not (Test-Path \$TEMP_DIR)) {
        New-Item -ItemType Directory -Path \$TEMP_DIR | Out-Null
    }

    Print-Status "Downloading update..."
    # Download the zip file
    Invoke-WebRequest -Uri \$DownloadUrl -OutFile \$ZIP_FILE_PATH
    Print-Status "Download completed."

    Print-Status "Unzipping new files..."
    # Unzip new files
    Expand-Archive -Path \$ZIP_FILE_PATH -DestinationPath \$AppFolderPath -Force
    Print-Status "Unzipping completed."

    Print-Status "Cleaning up..."
    # Delete the zip file and temp directory after updating
    Remove-Item -Path \$ZIP_FILE_PATH -Force
    Remove-Item -Path \$TEMP_DIR -Recurse -Force
    Print-Status "Cleanup completed."

    Print-Status "Starting application..."
    # Run the executable file
    \$process = Start-Process -FilePath \$EXE_FILE_PATH -PassThru
    
    # Wait for the process to start (adjust the timeout as needed)
    \$timeout = 10 # seconds
    if (\$process.WaitForInputIdle(\$timeout * 1000)) {
        Print-Status "Application started successfully."
    } else {
        throw "Application failed to start within \$timeout seconds."
    }

    Print-Status "Update completed successfully!"
}
catch {
    Write-Host "Error: \$(\$_.Exception.Message)" -ForegroundColor Red
}
finally {
    # Close the PowerShell window
    exit
}
''';

String appUpdationScriptGUI='''
param (
    [Parameter(Mandatory=\$true)]
    [string]\$AppFolderPath,

    [Parameter(Mandatory=\$true)]
    [string]\$DownloadUrl
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
\$form = New-Object System.Windows.Forms.Form
\$form.Text = 'Application Update'
\$form.Size = New-Object System.Drawing.Size(400,280)
\$form.StartPosition = 'CenterScreen'

# Create labels and checkboxes for each step
\$steps = @(
    "Downloading update",
    "Unzipping new files",
    "Cleaning up",
    "Starting application"
)

\$labels = @()
\$checkboxes = @()
\$y = 20

foreach (\$step in \$steps) {
    \$label = New-Object System.Windows.Forms.Label
    \$label.Location = New-Object System.Drawing.Point(20,\$y)
    \$label.Size = New-Object System.Drawing.Size(300,20)
    \$label.Text = \$step
    \$form.Controls.Add(\$label)
    \$labels += \$label

    \$checkbox = New-Object System.Windows.Forms.CheckBox
    \$checkbox.Location = New-Object System.Drawing.Point(330,\$y)
    \$checkbox.Size = New-Object System.Drawing.Size(20,20)
    \$checkbox.Enabled = \$false
    \$form.Controls.Add(\$checkbox)
    \$checkboxes += \$checkbox

    \$y += 30
}

# Status label
\$statusLabel = New-Object System.Windows.Forms.Label
\$statusLabel.Location = New-Object System.Drawing.Point(20, (\$y + 20))
\$statusLabel.Size = New-Object System.Drawing.Size(360,40)
\$statusLabel.Text = "Updating..."
\$form.Controls.Add(\$statusLabel)

# Function to update checkboxes and status
function Update-Status {
    param(\$stepIndex, \$status)
    if (\$stepIndex -ge 0 -and \$stepIndex -lt \$checkboxes.Count) {
        \$checkboxes[\$stepIndex].Checked = \$true
    }
    \$statusLabel.Text = \$status
    \$form.Refresh()
}

# Show the form
\$form.Show()

# Run your script
try {
    \$TEMP_DIR = Join-Path \$AppFolderPath "temp_update"
    \$ZIP_FILE_PATH = Join-Path \$TEMP_DIR "update.zip"
    \$EXE_FILE_PATH = Join-Path \$AppFolderPath "vadavathoor_book_stall.exe"

    # Create temp directory if it doesn't exist
    if (-not (Test-Path \$TEMP_DIR)) {
        New-Item -ItemType Directory -Path \$TEMP_DIR | Out-Null
    }

    Update-Status -stepIndex -1 -status "Downloading update..."
    # Download the zip file
    Invoke-WebRequest -Uri \$DownloadUrl -OutFile \$ZIP_FILE_PATH
    Update-Status -stepIndex 0 -status "Download completed"

    Update-Status -stepIndex 0 -status "Unzipping new files..."
    # Unzip new files
    Expand-Archive -Path \$ZIP_FILE_PATH -DestinationPath \$AppFolderPath -Force
    Update-Status -stepIndex 1 -status "Unzipping completed"

    Update-Status -stepIndex 1 -status "Cleaning up..."
    # Delete the zip file and temp directory after updating
    Remove-Item -Path \$ZIP_FILE_PATH -Force
    Remove-Item -Path \$TEMP_DIR -Recurse -Force
    Update-Status -stepIndex 2 -status "Cleanup completed"

    Update-Status -stepIndex 2 -status "Starting application..."
    # Run the executable file
    \$process = Start-Process -FilePath \$EXE_FILE_PATH -PassThru
    
    # Wait for the process to start (adjust the timeout as needed)
    \$timeout = 10 # seconds
    if (\$process.WaitForInputIdle(\$timeout * 1000)) {
        Update-Status -stepIndex 3 -status "Application started successfully"
    } else {
        throw "Application failed to start within \$timeout seconds"
    }

    Update-Status -stepIndex 3 -status "Update completed successfully!"

    # Keep the window open for a few seconds
    Start-Sleep -Seconds 5

    # Close the form
    \$form.Close()

    \$pid = Get-Process -Id \$PID
    Stop-Process -Id \$pid -Force
}
catch {
    Update-Status -stepIndex -1 -status "Error: \$(\$_.Exception.Message)"
}
''';