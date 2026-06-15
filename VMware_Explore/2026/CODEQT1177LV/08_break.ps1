# Using Break

$numbers = 1..50
foreach ($num in $numbers) {
    if ($num –gt 5)
    {
        # Break out of the loop
        Write-Output “Breaking the loop”
        Break
    }
    else 
    {
        # Print the number to the screen
        Write-Output “Number: $num“
    }
}