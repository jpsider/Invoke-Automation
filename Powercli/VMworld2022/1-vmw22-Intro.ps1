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

# Reporting from cmdlets is different than system errors.
# Reset the variable.
$ErrorActionPreference = "Continue"

# Example: Divide by Zero
1/0

# Reset the variable.
$ErrorActionPreference = "SilentlyContinue"

# Example: Divide by Zero
1/0

$ErrorActionPreference = "Continue"

# Be sure to set the value you want!