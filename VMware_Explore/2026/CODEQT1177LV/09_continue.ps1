# Using Break

$numbers = 1..25
foreach ($num in $numbers) {
    if ($num -like “*3*”)
    {
        # Skips this number
        continue
    }
    else 
    {
        # Print the number to the screen
        Write-Output “Number: $num“
    }
}