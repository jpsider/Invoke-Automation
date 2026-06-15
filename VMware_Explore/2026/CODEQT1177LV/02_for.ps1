# A standard For Loop

$vmhost = Get-VMHost | Select -First 1

For ($i=0; $i -le 5; $i++) 
{
    $vmName = “test_” + $i    
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost
}
# Oh no, it created 6 VM's not 5, plus its extremely verbose!
(Get-VM | Where-Object {$_.Name -like '*test*'} | Measure-Object).count

# Let's clean that up

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false

# Give it another shot! notice we change $i=1

For ($i=1; $i -le 5; $i++) 
{
    $vmName = “testAgain_” + $i    
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost | Out-Null
}
(Get-VM | Where-Object {$_.Name -like '*test*'} | Measure-Object).count

# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false

# Let's add some log messages!

For ($i=1; $i -le 5; $i++) 
{
    $vmName = “testLast_” + $i
    Write-Output "Creating vm: $vmName"
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost | Out-Null
}

# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false
