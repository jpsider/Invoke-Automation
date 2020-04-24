$vm = Get-VM "DC0_H0_VM0"
if($vm -eq $null) {Write-Host "No VM found"} else {Write-Host "Oh, Hey The VM exists!"}

# Invoke-ScriptAnalyzer -Path .\demo01.ps1