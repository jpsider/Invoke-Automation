function Confirm-vCenter {
    <#
    .DESCRIPTION
    	Validates an active connection to a vCenter
    .EXAMPLE
        Confirm-vCenter
    .NOTES
        Returns a boolean
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", '')]
    [OutputType([boolean])]
    param (
        #No Parameters, This is required for the CodeAnalysis supression.
    )

    if ($global:DefaultVIServer){
        $true
    } else {
        $false
    }
}