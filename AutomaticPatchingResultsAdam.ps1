$Server2k22 = "KB5033118"
$Server2k19 = "KB5033371"
$Server2k16 = "KB5033373"

ForEach ($server in (Get-Content "c:\scripts\AutomaticPatchingResultsAdam\checkservers.txt")) {

$OSNAME = (Get-CimInstance Win32_OperatingSystem -ComputerName $server -ErrorAction SilentlyContinue).caption


if ($OSNAME -contains "Microsoft Windows Server 2022 Standard")
    { $update = $Server2k22
    }
elseif ($OSNAME -contains "Microsoft Windows Server 2019 Standard")
    { $update = $Server2k19
    }
elseif ($OSNAME -contains "Microsoft Windows Server 2016 Standard")
    { $update = $Server2k16
    }

$CheckifExists = Get-HotFix -ComputerName $server | Where-Object {$_.HotFixID -eq $update} | Select-Object InstalledOn -ErrorAction SilentlyContinue
$RebootPending = Test-PendingReboot -ComputerName $server -SkipConfigurationManagerClientCheck | Select-Object -ExpandProperty IsRebootPending -ErrorAction SilentlyContinue 

if (![string]::IsNullOrEmpty($CheckifExists))
    {
        out-file -filepath "C:\scripts\AutomaticPatchingResultsAdam\results.txt" -InputObject "$server $update $CheckifExists Pending Reboot status $RebootPending " -Append
    }
else
    {
        out-file -filepath "C:\scripts\AutomaticPatchingResultsAdam\results.txt" -InputObject "Update $update not present for $server Pending Reboot status $RebootPending" -Append
    }

}
