function Convert-Ps1ToUtf8BOM {
    param (
        [string]$FolderPath
    )

    # Check if the folder exists
    if (-Not (Test-Path -Path $FolderPath)) {
        Write-Error "The specified folder does not exist."
        return
    }

    # Get all .ps1 files in the folder
    $ps1Files = Get-ChildItem -Path $FolderPath -Filter "*.ps1" -Recurse

    foreach ($file in $ps1Files) {
        Write-Output "Processing file: $($file.FullName)"

        # Read the content of the file
        $content = Get-Content -Path $file.FullName -Raw

        # Convert the content to UTF-8 with BOM
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
    }

    Write-Output "Conversion complete."
}