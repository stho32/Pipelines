$moduleName = "Pipelines"
if (Get-Module -Name $moduleName) {
    Remove-Module -Name $moduleName -Force
}

Import-Module ".\Module\Pipelines.psm1" -Force

$totalConversation = ""

while ($true) {
    $yourText = Read-Host -Prompt "You"

    $response = Invoke-ChatGPT -Prompt ($totalConversation + $yourText)

    Write-Host $response

    ConvertTo-OpenAISpeech -Text $response

    $totalConversation += [System.Environment]::NewLine;
    $totalConversation += $yourText
    $totalConversation += [System.Environment]::NewLine;
    $totalConversation += $response
}