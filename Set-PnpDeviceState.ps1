[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$DeviceName,

    [Parameter(Mandatory = $true)]
    [ValidateSet('enable', 'disable')]
    [string]$Action
)

$devices = @(Get-PnpDevice -FriendlyName $DeviceName -ErrorAction SilentlyContinue)

if ($devices.Count -eq 0) {
    throw "No Plug and Play device was found with the friendly name '$DeviceName'."
}

try {
    if ($Action -eq 'enable') {
        $devices | Enable-PnpDevice -Confirm:$false -ErrorAction Stop
    }
    else {
        $devices | Disable-PnpDevice -Confirm:$false -ErrorAction Stop
    }

    Write-Host "$Action completed for device: $DeviceName"
}
catch {
    throw "Failed to $($Action.ToLowerInvariant()) device '$DeviceName'. Run PowerShell as Administrator. $($_.Exception.Message)"
}