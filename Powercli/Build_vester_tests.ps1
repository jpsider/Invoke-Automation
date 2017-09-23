$TestData = Get-AdvancedSetting -Entity 192.168.10.220 
foreach($setting in $TestData) {
    $name = $setting.name
    $value = $setting.value
    $valueType = $value.getType().name
    $Testdescription = $setting.description

    if ($Testdescription -eq ""){
        $Testdescription = $name
    }

    if($name -match ".") {
        $DesiredValueName = $name -replace ("\.","")
    } else {
        $DesiredValueName = $name
    }

    $logfile = "C:\temp\vester_builder\VC-$DesiredValueName.Vester.ps1"
    write-host "The Setting is $name"
    write-host "Example value is $value"
    write-host "The ValueType is $valueType"
    write-host "The description is $Testdescription"
    write-host "The Desired Value Name is $desiredValueName"
    write-host "The new File name will be $logfile"

    "# Test file for the Vester module - https://github.com/WahlNetwork/Vester" | out-file -FilePath $logfile -Append
    "# Called via Invoke-Pester VesterTemplate.Tests.ps1" | out-file -FilePath $logfile -Append
    "" | out-file -FilePath $logfile -Append
    "# Test title, e.g. 'DNS Servers'" | out-file -FilePath $logfile -Append
    "ZZZTitle = '$name'" | out-file -FilePath $logfile -Append
    "" | out-file -FilePath $logfile -Append
    "# Test description: How New-VesterConfig explains this value to the user" | out-file -FilePath $logfile -Append
    "ZZZDescription = '$Testdescription'" | out-file -FilePath $logfile -Append
    "" | out-file -FilePath $logfile -Append
    "# The config entry stating the desired values" | out-file -FilePath $logfile -Append
    "ZZZDesired = ZZZcfg.vcenter.$desiredValueName" | out-file -FilePath $logfile -Append
    "" | out-file -FilePath $logfile -Append
    "# The test value's data type, to help with conversion: bool/string/int" | out-file -FilePath $logfile -Append
    "ZZZType = '$valueType'" | out-file -FilePath $logfile -Append
    "" | out-file -FilePath $logfile -Append
    "# The command(s) to pull the actual value for comparison" | out-file -FilePath $logfile -Append
    "# ZZZObject will scope to the folder this test is in (Cluster, Host, etc.)" | out-file -FilePath $logfile -Append
    "[ScriptBlock]ZZZActual = {" | out-file -FilePath $logfile -Append
    "    (Get-AdvancedSetting -Entity ZZZObject -Name $name).Value" | out-file -FilePath $logfile -Append
    "}" | out-file -FilePath $logfile -Append
    "" | out-file -FilePath $logfile -Append
    "# The command(s) to match the environment to the config" | out-file -FilePath $logfile -Append
    "# Use ZZZObject to help filter, and $Desired to set the correct value" | out-file -FilePath $logfile -Append
    "[ScriptBlock]ZZZFix = {" | out-file -FilePath $logfile -Append
    "    Get-AdvancedSetting -Entity ZZZObject -Name $name |" | out-file -FilePath $logfile -Append
    "        Set-AdvancedSetting -value ZZZDesired -Confirm:ZZZfalse -ErrorAction Stop" | out-file -FilePath $logfile -Append
    "}" | out-file -FilePath $logfile -Append

    # Replace Value with $
    $replaceValue = '$'
    (Get-Content $logfile) -replace "ZZZ","$replaceValue" | Set-Content $logfile
}