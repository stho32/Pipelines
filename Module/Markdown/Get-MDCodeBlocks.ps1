function Get-MDCodeBlocks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$MarkdownContent,

        [Parameter(Mandatory = $false)]
        [switch]$BiggestOnly
    )

    process {
        # Define a regular expression pattern to match code blocks
        $pattern = '(?ms)```(.*?)```'

        # Use the regex to find all matches
        $matchingThings = [regex]::Matches($MarkdownContent, $pattern)

        if ($BiggestOnly) {
            # Find the biggest code block
            $biggestMatch = $null
            $maxSize = 0
            foreach ($match in $matchingThings) {
                $codeBlock = $match.Groups[1].Value
                if ($codeBlock.Length -gt $maxSize) {
                    $maxSize = $codeBlock.Length
                    $biggestMatch = $codeBlock
                }
            }
            if ($biggestMatch) {
                Write-Output $biggestMatch
            }
        } else {
            # Extract the code blocks and write them to the pipeline
            foreach ($match in $matchingThings) {
                $codeBlock = $match.Groups[1].Value
                Write-Output $codeBlock
            }
        }
    }
}
