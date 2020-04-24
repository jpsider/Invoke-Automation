$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Confirm-PowerState function" {
    $VMdata = @{
        'Name' = "SomeVM"
        'PowerState' = 'PoweredOff'
        'Num CPUs' = '1'
        'MemoryGB' = '2.000'
    }
    $returnData = $VMdata | ConvertTo-Json
    $VMname = $returnData | ConvertFrom-Json
    It "Should return True if the PowerState matches the desired value." {
        Confirm-PowerState -VM $VMname | Should be $true
    }
    It "Should return True if the PowerState matches the desired value." {
        Confirm-PowerState -VM $VMname -PowerState PoweredOff | Should be $true
    }
    #It "Should return False if the PowerState does not match the desired value." {
    #    Confirm-PowerState -VM $VMname -PowerState PoweredOn | Should be $false
    #}
}