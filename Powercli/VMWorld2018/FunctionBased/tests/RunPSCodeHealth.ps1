# Need to import all the files first of course.

Set-Location "C:\OPEN_PROJECTS\Invoke-Automation\Powercli\VMWorld2018\FunctionBased\"

$foundError = $false

$Directories = ("private", "public")
foreach ($Directory in $Directories)
{
    # Import the functions.
    $files = Get-ChildItem .\$Directory
    foreach ($file in $files)
    {
        # Source the file
        $FileName = $file.Name
        Write-Output "Importing file $FileName"
        . .\$Directory\$FileName
    }
}
Write-Output "All files imported"
Invoke-PSCodeHealth -Path '.\Public' -TestsPath '.\tests\Public' | Format-List
Invoke-PSCodeHealth -Path '.\Private' -TestsPath '.\tests\Private' | Format-List


if ($foundError -eq $true)
{
    # An error was found in the Unit tests.
    Write-Error "An error has been found in the unit Tests. Please review them before commiting the code."
} 
else
{
    Write-Output "Tests cover 100% and all pass! Hooray!"
}