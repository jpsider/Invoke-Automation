# Standard Foreach

$NumberList = 1..5
Foreach($Number in $NumberList)
{
    $vmName = “test_” + $Number
    Write-Output "Creating VM: $vmName"
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost | Out-Null
}

# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false
