# PowerShell Script to Process JSON and Generate CSV Files

# Function to sanitize file names
function Sanitize-FileName {
    param (
        [string]$FileName
    )
    # Replace invalid characters and limit the file name length
    $FileName -replace '[<>:"/\\|?*]', '_'
}

# Get the directory of the current script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Path to the input JSON file in the same directory as the script
$jsonFilePath = Join-Path $scriptDirectory "input.json"

# Load the JSON content
$jsonContent = Get-Content -Raw -Path $jsonFilePath | ConvertFrom-Json

# Loop through each track in the JSON content
foreach ($track in $jsonContent) {
    $trackName = $track.trackName
    $uid = $track.uid
    $fileName = "20241103T180000_${uid}_Xw==_Timeslot_1.csv"

    # Sanitize the file name
    #$fileName = Sanitize-FileName -FileName $fileName

    Write-Host "Processing track: $fileName"

    # Prepare the CSV content
    $csvLines = @()
    $csvLines += "SteamId,Username,Time" # Header line
    foreach ($time in $track.times) {
        $csvLines += "$($time.steamID),$($time.userName),$($time.bestTime)"
    }

    # Write the CSV content to the file
    $csvFilePath = Join-Path $scriptDirectory $fileName
    $csvLines | Out-File -LiteralPath $csvFilePath -Encoding utf8
}

Write-Host "CSV files have been generated successfully."
