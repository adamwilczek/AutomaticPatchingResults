$Server2k22 = "KB5032198"
$Server2k19 = "KB5032196"
$Server2k16 = "KB5032197"

ForEach ($server in (Get-Content "c:\scripts\AutomaticPatchingResults\checkservers.txt")) {

$OSNAME = (Get-WmiObject Win32_OperatingSystem -ComputerName $server -ErrorAction SilentlyContinue).caption


if ($OSNAME -contains "Microsoft Windows Server 2022 Standard")
    { $update = $Server2k22
    }
elseif ($OSNAME -contains "Microsoft Windows Server 2019 Standard")
    { $update = $Server2k19
    }
elseif ($OSNAME -contains "Microsoft Windows Server 2016 Standard")
    { $update = $Server2k16
    }

$CheckifExists = Get-HotFix -ComputerName $server | Where-Object {$_.HotFixID -eq $update} | Select InstalledOn -ErrorAction SilentlyContinue
$RebootPending = Test-PendingReboot -ComputerName $server -SkipConfigurationManagerClientCheck | Select-Object -ExpandProperty IsRebootPending -ErrorAction SilentlyContinue 

if (![string]::IsNullOrEmpty($CheckifExists))
    {
        out-file -filepath "\\srvde5007\AgentsInstallationFiles\text1.txt" -InputObject "$server $update $CheckifExists Pending Reboot status $RebootPending " -Append
    }
else
    {
        out-file -filepath "\\srvde5007\AgentsInstallationFiles\text1.txt" -InputObject "Update $update not present for $server Pending Reboot status $RebootPending" -Append
    }

}
