# A standard For Loop

For ($i=0; $i -le 5; $i++) 
{
    $vmName = “test_” + $i    
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost
}
# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false

# Oh no, it created 6 VM's not 5, plus it eas extremely verbose!

For ($i=1; $i -le 5; $i++) 
{
    $vmName = “testAgain_” + $i    
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost | Out-Null
}
# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false

# Let's add some messages!

For ($i=1; $i -le 5; $i++) 
{
    $vmName = “testLast_” + $i
    Write-Output "Creating vm: $vmName"
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost | Out-Null
}

# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false
