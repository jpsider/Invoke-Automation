# Default behaviors
$ErrorActionPreference

# String variable
    # Stop
    # SilentlyContinue
    # Continue

New-Object foo

# Change the System variable
$ErrorActionPreference = "SilentlyContinue"

New-Object foo
New-Object foo;Write-host "Hello world"

# Reset the variable.
$ErrorActionPreference = "Continue"

# You may not always get what you want!

New-Object foo -ErrorAction SilentlyContinue; Write-Host "Hello World"