function ConvertTo-OpenAISpeech {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string]$Text
    )

    begin {
        # Initialize a list to collect sentences
        $collectedText = @()
        $apiUrl = "https://api.openai.com/v1/audio/speech"
        $outputFolder = "c:\Projekte\TempAudio"
    }

    process {
        # Collect all text input
        $collectedText += $Text
    }

    end {
        # Combine all collected text into a single string
        $completeText = $collectedText -join " "

        $voices = "alloy", "echo", "fable", "onyx", "nova", "shimmer"
        $voice = $voices | Get-Random

        # Prepare the request body
        $body = @{
            model = "tts-1"
            input = $completeText
            voice = $voice
        } | ConvertTo-Json

        # Prepare headers
        $headers = @{
            "Authorization" = "Bearer $CHATGPTKEY"
            "Content-Type"  = "application/json"
        }

        try {
            # Create output folder if it doesn't exist
            if (-not (Test-Path $outputFolder)) {
                New-Item -ItemType Directory -Path $outputFolder | Out-Null
            }

            # Generate a unique filename in the output folder
            $audioFile = Join-Path $outputFolder ([Guid]::NewGuid().ToString() + ".mp3")

            # Make the HTTP POST request (directly to the output file)
            $response = Invoke-RestMethod -Uri $apiUrl -Method POST -Body $body -Headers $headers -OutFile $audioFile

            Write-Host $response
            Write-Output "Audio file created: $audioFile"

            # Optionally, play the audio file
            Start-Process "wmplayer.exe" $audioFile 
        }
        catch {
            Write-Error "Failed to generate speech: $_"
        }
    }
}
