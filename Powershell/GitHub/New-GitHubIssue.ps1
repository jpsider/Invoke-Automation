function New-GithubIssue {
    <#
	.DESCRIPTION
		Creates a GitHub issue via a REST API
    .PARAMETER Title
        A Title is Required
    .PARAMETER Description
        A Description for the issue is required.
    .PARAMETER Label
        An Issue Label is required, and must already exist!
    .PARAMETER Owner
        An Owner/Org is required.
    .PARAMETER Repository
        A Repository Name is required.
    .PARAMETER Headers
        A Repository Name is required.
    .EXAMPLE
        $UserToken = "8675309"
        $Headers = @{Authorization = 'token ' + $UserToken}
        New-GithubIssue -Title "My New Issue" -Description "Sliced Bread" -Label "Automation" -owner "jpsider" -Repository "Invoke-Automation" -Headers ""
	.NOTES
        It will create the issue in GitHub. It requires Headers that include an API token.
    .LINK
        http://invoke-automation.blog
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([String])]
    [OutputType([boolean])]
    param(
        [Parameter(Mandatory=$true)][string]$Title,
        [Parameter(Mandatory=$true)][string]$Description,
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][string]$Owner,
        [Parameter(Mandatory=$true)][string]$Repository,
        [Parameter(Mandatory=$true)]$Headers
    )

    begin {
        $Body = @{
                title  = "$Title"
                body   = "$Description"
                labels = @("$label")
            } | ConvertTo-Json
        }
    process {
        if ($pscmdlet.ShouldProcess("Creating issue $Title in GitHub Repo: $Repository."))
        {
            try {
                $NewIssue = Invoke-RestMethod -Method Post -Uri "https://api.github.com/repos/$owner/$repository/issues" -Body $Body -Headers $Headers -ContentType "application/json"
                $NewIssue.html_url
            }
            Catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Throw "New-GitHubIssue: $ErrorMessage $FailedItem"
            }
        } else {
            # -WhatIf was used.
            Return $false
        }
    }
}