function ConvertTo-TTSSpeech {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string]$Text,

        [Parameter(Mandatory=$false)]
        [string]$Language = "en-US"
    )

    begin {
        # Initialize a list to collect sentences
        $collectedText = @()
    }

    process {
        # Collect all text input
        $collectedText += $Text
    }

    end {
        Add-Type -AssemblyName System.Speech
        $synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer

        # Get possible voices that match the specified language
        $voices = $synthesizer.GetInstalledVoices() | Where-Object { $_.VoiceInfo.Culture.Name -eq $Language }

        if ($voices.Count -gt 0) {
            # Select a random voice
            $randomVoice = Get-Random -InputObject $voices
            $synthesizer.SelectVoice($randomVoice.VoiceInfo.Name)
        } else {
            Write-Error "No voices available for the specified language '$Language'."
            return
        }

        # Combine all collected text into a single string and split into sentences
        $completeText = $collectedText -join " "
        $sentences = [regex]::Split($completeText, '(?<=[.!?])\s+')

        # Speak and output each sentence
        foreach ($sentence in $sentences) {
            if ([bool]$sentence) {
                Write-Output $sentence
                try {
                    $synthesizer.Speak($sentence)
                }
                catch {
                    Write-Error "Error in speaking text: $_"
                }
            }
        }
    }
}
