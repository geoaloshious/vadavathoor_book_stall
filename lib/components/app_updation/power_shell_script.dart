String appUpdationScript='''
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
\$statusLabel.Location = New-Object System.Drawing.Point(20, \$y + 20)
\$statusLabel.Size = New-Object System.Drawing.Size(360, 40)
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
    \$APP_FOLDER_PATH = \$env:appFolderPath
    \$DOWNLOAD_URL = \$env:downloadUrl
    \$TEMP_DIR = Join-Path \$APP_FOLDER_PATH "temp_update"
    \$ZIP_FILE_PATH = Join-Path \$TEMP_DIR "update.zip"
    \$EXE_FILE_PATH = Join-Path \$APP_FOLDER_PATH "vadavathoor_book_stall.exe"

    # Create temp directory if it doesn't exist
    if (-not (Test-Path \$TEMP_DIR)) {
        New-Item -ItemType Directory -Path \$TEMP_DIR | Out-Null
    }

    Update-Status -stepIndex -1 -status "Downloading update..."
    # Download the zip file
    Invoke-WebRequest -Uri \$DOWNLOAD_URL -OutFile \$ZIP_FILE_PATH
    Update-Status -stepIndex 0 -status "Download completed"

    Update-Status -stepIndex 0 -status "Unzipping new files..."
    # Unzip new files
    Expand-Archive -Path \$ZIP_FILE_PATH -DestinationPath \$APP_FOLDER_PATH -Force
    Update-Status -stepIndex 1 -status "Unzipping completed"

    Update-Status -stepIndex 1 -status "Cleaning up..."
    # Delete the zip file and temp directory after updating
    Remove-Item -Path \$ZIP_FILE_PATH -Force
    Remove-Item -Path \$TEMP_DIR -Recurse -Force
    Update-Status -stepIndex 2 -status "Cleanup completed"

    Update-Status -stepIndex 2 -status "Starting application..."
    Start-Process -FilePath \$EXE_FILE_PATH
    Update-Status -stepIndex 3 -status "Application started"

    Update-Status -stepIndex 3 -status "Update completed successfully!"

    # Keep the window open for a few seconds
    Start-Sleep -Seconds 2

    # Close the form
    \$form.Close()
}
catch {
    Update-Status -stepIndex -1 -status "Error: \$(\$_.Exception.Message)"
}
''';