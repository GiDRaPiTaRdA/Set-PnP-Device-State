# Set-PnpDeviceState

A lightweight PowerShell utility for enabling or disabling Windows Plug and Play (PnP) devices using their friendly names.

## Features

- Enable Windows devices by friendly name
- Disable Windows devices by friendly name
- Works with many PnP devices, including network adapters, graphics cards, audio devices, and USB peripherals
- Reports an error when no matching device is found
- No third-party dependencies

## Requirements

- Windows 10/11 or Windows Server
- Windows PowerShell 5.1 or a compatible PowerShell 7+ environment
- Windows `PnpDevice` module
- **Administrator privileges** to enable or disable devices

## Installation

Once published to PowerShell Gallery, install with:

```powershell
Install-Script -Name Set-PnpDeviceState -Scope CurrentUser
```

## Usage

Open PowerShell **as Administrator** before enabling or disabling devices.

### List available devices

```powershell
Get-PnpDevice | Select-Object Status, FriendlyName
```

### Disable a device

```powershell
Set-PnpDeviceState.ps1 -DeviceName "NVIDIA GeForce RTX 3060" -Action disable
```

### Enable a device

```powershell
Set-PnpDeviceState.ps1 -DeviceName "NVIDIA GeForce RTX 3060" -Action enable
```

### Disable a network adapter

```powershell
Set-PnpDeviceState.ps1 -DeviceName "Realtek PCIe GbE Family Controller" -Action disable
```

### Find devices by partial name

```powershell
Get-PnpDevice | Where-Object {
    $_.FriendlyName -like "*NVIDIA*"
}
```

The script passes `-DeviceName` to `Get-PnpDevice -FriendlyName`. Wildcard patterns may match multiple devices.

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `DeviceName` | Yes | Friendly name of the target PnP device |
| `Action` | Yes | `enable` or `disable` |

## Example output

```text
disable completed for device: NVIDIA GeForce RTX 3060
```

## Important notes

- Running the script requires administrator privileges.
- Multiple devices may match the supplied friendly name; **all matches will be affected**.
- Disabling a graphics adapter may interrupt display output.
- Disabling a network adapter may disconnect the computer from the network.
- Disabling some system devices may cause instability or require a restart.
- The script does not prompt for confirmation before changing device state.

Only modify devices you understand and are authorized to manage.

## Troubleshooting

### Access denied

Open PowerShell using **Run as Administrator** and try again.

### Device not found

Check its friendly name:

```powershell
Get-PnpDevice | Format-Table Status, FriendlyName -AutoSize
```

### Find a specific device

```powershell
Get-PnpDevice | Where-Object {
    $_.FriendlyName -like "*Realtek*"
}
```

### Device remains disabled

Try enabling it again:

```powershell
Set-PnpDeviceState.ps1 -DeviceName "Device Name" -Action enable
```

If PowerShell cannot restore the device, use Windows Device Manager or restart the computer if appropriate.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
