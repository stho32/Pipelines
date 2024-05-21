$moduleName = "Pipelines"
if (Get-Module -Name $moduleName) {
    Remove-Module -Name $moduleName -Force
}

Import-Module ".\Module\Pipelines.psm1" -Force

Get-Command -Module $moduleName

#Invoke-ChatGPT -Prompt "Hello you!"
#$cmdlet = Invoke-ChatGPT -Prompt "Please write me a powershell function that will find all .ps1 files in a folder and save them as utf-8 with BOM"
