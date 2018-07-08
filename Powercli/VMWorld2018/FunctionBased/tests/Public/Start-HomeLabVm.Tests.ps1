$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.tests\.', '.'
. "$here\$sut"

Describe "Start-HomeLabVm function" {
    function Confirm-vCenter {}
    function Confirm-PowerState {}
    function Start-VM {}
    function Get-VM {}
    It "Should return True if the vm is powered on successfully." {
        Mock -CommandName 'Confirm-vCenter' -MockWith {
            $true
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Mock -CommandName 'Get-VM' -MockWith {
            $data = @{
                'Name' = "SomeVM"
                'PowerState' = 'PoweredOff'
                'Num CPUs' = '1'
                'MemoryGB' = '2.000'

            }
            $returnData = $data | ConvertTo-Json
            $returnData | ConvertFrom-Json
        }
        Mock -CommandName 'Confirm-PowerState' -MockWith {
            $false
        }
        Mock -CommandName 'Start-VM' -MockWith {
            $true
        }
        Start-HomeLabVm -VM "SomeVM" | Should be $true
        Assert-MockCalled -CommandName 'Get-VM' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Confirm-PowerState' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Confirm-vCenter' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Start-VM' -Times 1 -Exactly
    }
    It "Should return True if the vm is already Powered on." {
        Mock -CommandName 'Confirm-vCenter' -MockWith {
            $true
        }
        Mock -CommandName 'Write-Warning' -MockWith {}
        Mock -CommandName 'Get-VM' -MockWith {
            $data = @{
                'Name' = "SomeVM"
                'PowerState' = 'PoweredOn'
                'Num CPUs' = '1'
                'MemoryGB' = '2.000'

            }
            $returnData = $data | ConvertTo-Json
            $returnData | ConvertFrom-Json
        }
        Mock -CommandName 'Confirm-PowerState' -MockWith {
            $true
        }
        Start-HomeLabVm -VM "SomeVM" | Should be $true
        Assert-MockCalled -CommandName 'Get-VM' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Write-Warning' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Confirm-PowerState' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Confirm-vCenter' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Start-VM' -Times 1 -Exactly
    }
    It "Should Throw if the VM cannot be powered on." {
        Mock -CommandName 'Confirm-vCenter' -MockWith {
            $true
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Mock -CommandName 'Get-VM' -MockWith {
            $data = @{
                'Name' = "SomeVM"
                'PowerState' = 'PoweredOff'
                'Num CPUs' = '1'
                'MemoryGB' = '2.000'

            }
            $returnData = $data | ConvertTo-Json
            $returnData | ConvertFrom-Json
        }
        Mock -CommandName 'Confirm-PowerState' -MockWith {
            $false
        }
        Mock -CommandName 'Start-VM' -MockWith {
            $false
        }
        {Start-HomeLabVm -VM "SomeVM"} | Should -Throw
        Assert-MockCalled -CommandName 'Get-VM' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-PowerState' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-vCenter' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Start-VM' -Times 2 -Exactly
    }
    It "Should Throw if the VM cannot be found." {
        Mock -CommandName 'Confirm-vCenter' -MockWith {
            $true
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Mock -CommandName 'Get-VM' -MockWith {
            $null
        }
        {Start-HomeLabVm -VM "SomeVM"} | Should -Throw
        Assert-MockCalled -CommandName 'Get-VM' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-PowerState' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-vCenter' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Start-VM' -Times 2 -Exactly
    }
    It "Should Throw if there is no vCenter connection." {
        Mock -CommandName 'Confirm-vCenter' -MockWith {
            $false
        }
        {Start-HomeLabVm -VM "SomeVM"} | Should -Throw
        Assert-MockCalled -CommandName 'Get-VM' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-PowerState' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-vCenter' -Times 5 -Exactly
        Assert-MockCalled -CommandName 'Start-VM' -Times 2 -Exactly
    }
    It "Should false if '-WhatIf' was used." {
        Start-HomeLabVm -VM "SomeVM" -WhatIf | Should be $false
        Assert-MockCalled -CommandName 'Get-VM' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-PowerState' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Confirm-vCenter' -Times 5 -Exactly
        Assert-MockCalled -CommandName 'Start-VM' -Times 2 -Exactly
    }
}