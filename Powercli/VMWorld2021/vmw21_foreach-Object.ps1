# Standard Foreach-Object (Note, the '{' has to be on the same line as the Foreach-Object)

1..5 | Foreach-Object {
    $Number = $_
    $vmName = “test_” + $Number
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost
}

# Let's add some messages and quiet it down.

6..10 | Foreach-Object {
    $Number = $_
    $vmName = “test_” + $Number
    Write-Output "Creating VM: $vmName"
    New-VM -Name $vmName -VM “base” -Datastore "NVMe_203" -LinkedClone -ReferenceSnapShot “base” -VMHost $vmhost | Out-Null
}

# Cleanup

Get-VM | Where-Object {$_.Name -like '*test*'} | Remove-VM -DeletePermanently -Confirm:$false
