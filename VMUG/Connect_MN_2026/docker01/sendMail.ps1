# vCenter Info
$vcuser = "administrator"
$vcpass = "VMware1!"
$vcenter = "192.168.2.220"

# Mail Info
$username = "1ba94cf337ecbc"
$pass = '6abf4561456fe0' 
$smtpServer = "smtp.mailtrap.io"
$Port = "587"

# Just an FYI, never save passwords in plain text in scripts, this is just for a demo. :-D

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip $false -Scope AllUsers -Confirm:$false

$ValidConnection = "False"
do {

    try{
        # Connect to vCenter
        Connect-VIServer -Server $vcenter -User $vcuser -Password $vcpass
        $ValidConnection = "True"
    } 
    Catch {
        Write-Output "Unable to connect to vCenter"
        $ValidConnection = "False"
        Start-Sleep -Seconds 15
    }
}
while ($ValidConnection -eq "False")


$SendReport = "True"
$Count = 1
do {
    try {
        # Generate the HTML report using ReportCardPS
        $TemplateReportPath = (Get-ReportCardTemplateSet | Where-Object {$_.Fullname -like '*vCenter*'}).Fullname
        $ReportHTML = New-ReportCard -Title 'For VMware {code} Connect' -JsonFilePath $TemplateReportPath

        # Create a Subject with Count property
        $Subject = "Hey, VMware Code Connect! Email number: $Count"

        # Create a Credential Object
        [securestring]$secStringPassword = ConvertTo-SecureString $pass -AsPlainText -Force
        [pscredential]$credOject = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)
        # Send the Mail Message
        Send-MailMessage -To 'whocares@mail.com' -From 'my@container.com'  -Subject "$Subject" -Body "$ReportHTML" -Credential $credOject -SmtpServer "$smtpServer" -Port "$Port"
        
    } 
    Catch {
        Write-Output "Something went wrong sending the report, Oh No!"
    }
    # Wait for 5 Seconds
    ConvertTo-AsciiArt -Text "5 . . . "
    Start-Sleep -Seconds 1
    ConvertTo-AsciiArt -Text "4 . . . "
    Start-Sleep -Seconds 1
    ConvertTo-AsciiArt -Text "3 . . . "
    Start-Sleep -Seconds 1
    ConvertTo-AsciiArt -Text "2 . . . "
    Start-Sleep -Seconds 1
    ConvertTo-AsciiArt -Text "1 . . . "
    Start-Sleep -Seconds 1
    
    $Count++

} while ($SendReport -eq "True")