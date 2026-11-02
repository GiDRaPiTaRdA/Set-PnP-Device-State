<#PSScriptInfo

.VERSION 1.0.0

.GUID ef188bee-aa11-4937-8c0d-0b76c35cd63a

.AUTHOR Sha256Encrypted

.TAGS PnP DeviceManagement Windows Hardware Enable Disable

#>

<#
.SYNOPSIS
Enables or disables Windows Plug and Play devices by friendly name.

.DESCRIPTION
Manages Windows Plug and Play (PnP) devices using their friendly names.

Allows users to enable or disable matching devices through the
DeviceName and Action parameters.

Requires administrator privileges to modify device states.

.PARAMETER DeviceName
Specifies the friendly name of the Plug and Play device to manage.

Multiple devices matching the specified name may be affected.

.PARAMETER Action
Specifies the operation to perform.

Accepted values:
- enable  : Enables the matching device.
- disable : Disables the matching device.

.EXAMPLE
.\Set-PnpDeviceState.ps1 -DeviceName "NVIDIA GeForce RTX 3060" -Action disable

Disables the specified NVIDIA graphics adapter.

.EXAMPLE
.\Set-PnpDeviceState.ps1 -DeviceName "NVIDIA GeForce RTX 3060" -Action enable

Enables the specified NVIDIA graphics adapter.

.EXAMPLE
.\Set-PnpDeviceState.ps1 -DeviceName "Realtek PCIe GbE Family Controller" -Action disable

Disables the specified network adapter.

.NOTES
Requires Windows and the PnpDevice PowerShell module.
Run PowerShell as Administrator.

Disabling critical hardware may interrupt display output,
network connectivity, or other system functionality.
#>

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