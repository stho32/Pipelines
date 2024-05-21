function Invoke-ChatGPT {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string]$Prompt,

        [string]$SystemPrompt,
        [string]$Model = "gpt-4o",
        [int]$MaxTokens = 4000,
        [float]$Temperature = 0.7
    )

    [string]$BaseUri = "https://api.openai.com/v1/chat/completions"

    $body = @{
        model       = $Model
        messages    = @(
            @{
                role    = "system"
                content = $SystemPrompt
            },
            @{
                role    = "user"
                content = $Prompt
            }
        )
        max_tokens  = $MaxTokens
        temperature = $Temperature
    } | ConvertTo-Json -Depth 5

    $headers = @{
        "Authorization" = "Bearer $CHATGPTKEY"
        "Content-Type"  = "application/json"
    }

    $response = Invoke-RestMethod -Uri $BaseUri -Method POST -Body $body -Headers $headers
    return $response.choices[0].message.content
}
