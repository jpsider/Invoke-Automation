# Added -VM to specify the parameter type
$vm = Get-VM -VM "SomeName"
# Updated the order of the 'if' check
if($null -eq $vm)
{
    # Switched to Write-Ouput
    Write-Output "No VM found"
}
else
{
    # Switched to Write-Ouput
    Write-Output "Oh, Hey The VM exists!"
}

# Invoke-ScriptAnalyzer -Path .\demo01_fixed.ps1
