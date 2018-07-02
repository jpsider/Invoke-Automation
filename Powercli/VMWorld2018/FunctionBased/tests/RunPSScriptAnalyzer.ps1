# Need to import all the files first of course.

Set-Location "C:\OPEN_PROJECTS\Invoke-Automation\Powercli\VMWorld2018\FunctionBased\"

$foundError = $false

$Directories = ("private", "public")
foreach ($Directory in $Directories)
{
    $Results = Invoke-ScriptAnalyzer -Path .\$Directory -IncludeDefaultRules
    if ($null -eq $Results) {
        Write-Output "No Code issues found in directory: $Directory"
    } else {
        $foundError = $true
        Write-Output "Error found in Directory: $Directory"
        Write-Output $Results
    }
}
if ($foundError -eq $true)
{
    # An error was found in the Unit tests.
    Write-Error "An error has been found with PSScriptAnalyzer. Please review them before commiting the code."
} 
else
{
    Write-Output "Nothing found with PSScriptAnalyzer! Hooray!"
}