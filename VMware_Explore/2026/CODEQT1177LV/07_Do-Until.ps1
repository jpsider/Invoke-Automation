# Do Until Loop

$NumberOfVms = 5
$vmCount = 0

# Will always run the first time!
Do
{
    $vmName = “test_” + $vmCount
    Write-Output "Creating VM: $vmName"
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost | Out-Null
    
    # Increase the count (Or you will create vm's FOREVER!)
    $vmCount++

} Until ($vmCount -eq $NumberOfVms)

# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false

