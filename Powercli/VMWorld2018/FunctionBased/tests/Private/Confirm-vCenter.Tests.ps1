Describe "Confirm-vCenter function" {
    It "Should return True if there is a vCenter connection." {
        $data = @{
            'Name' = "Some-vCenter"
            'Port' = '443'
            'User' = 'CORP.LOCAL\Administrator'
        }
        $returnData = $data | ConvertTo-Json
        $global:DefaultVIServer = $returnData | ConvertFrom-Json
        Confirm-vCenter | Should be $true
    }
    It "Should return false if there is no vCenter connection." {
        $global:DefaultVIServer = $null
        Confirm-vCenter | Should be $false
    }
}