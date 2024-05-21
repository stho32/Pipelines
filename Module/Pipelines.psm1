# Root.psm1

# Get the directory of the current module
$moduleDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Get all .ps1 files in the directory and its subdirectories
$scriptFiles = Get-ChildItem -Path $moduleDirectory -Recurse -Filter *.ps1

foreach ($scriptFile in $scriptFiles) {
    try {
        Write-Verbose "Importing script: $($scriptFile.FullName)"
        . $scriptFile.FullName
    } catch {
        Write-Error "Failed to import script: $($scriptFile.FullName). Error: $_"
    }
}

# Check for the ChatGPT_KEY environment variable
$CHATGPTKEY = [System.Environment]::GetEnvironmentVariable('ChatGPT_KEY')
if ($null -eq $CHATGPTKEY) {
    Write-Warning "The environment variable 'ChatGPT_KEY' is not available."
} else {
    Write-Verbose "ChatGPT_KEY found and read into a variable."
}
