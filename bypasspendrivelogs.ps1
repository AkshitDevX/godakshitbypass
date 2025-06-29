# CREDIT: GOD AKSHIT | discord.gg/hindustan
# Deletes USB traces and keeps only current drive (shown in 'This PC')

# -------------------------
# STEP 1: Get Current USB Drive Letters
# -------------------------
$currentUSBs = Get-WmiObject Win32_LogicalDisk -Filter "DriveType = 2" | Select-Object -ExpandProperty DeviceID

# Normalize drive letters (e.g., E:)
$currentUSBs = $currentUSBs -replace ":", ""

# -------------------------
# STEP 2: Remove USBSTOR entries (except current)
# -------------------------
$usbStorPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"
if (Test-Path $usbStorPath) {
    Get-ChildItem $usbStorPath | ForEach-Object {
        $subKey = $_.Name
        $subDevices = Get-ChildItem $_.PSPath
        foreach ($device in $subDevices) {
            $deviceId = $device.PSChildName
            $match = $false
            foreach ($drive in $currentUSBs) {
                if ($deviceId -match $drive) {
                    $match = $true
                }
            }
            if (-not $match) {
                Remove-Item -Path $device.PSPath -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "[+] Removed USB device trace: $deviceId"
            }
        }
    }
}

# -------------------------
# STEP 3: Remove MountPoints2 (stale USB paths)
# -------------------------
$mpPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"
if (Test-Path $mpPath) {
    Get-ChildItem $mpPath | ForEach-Object {
        if ($_ -match "\\##") {
            Remove-Item -Path $_.PsPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "[+] Removed stale MountPoint: $($_.Name)"
        }
    }
}

# -------------------------
# STEP 4: Remove MountedDevices (except current USB)
# -------------------------
$mountedPath = "HKLM:\SYSTEM\MountedDevices"
Get-ItemProperty -Path $mountedPath | ForEach-Object {
    $name = $_.PSChildName
    if ($name -match "DosDevices\\([A-Z]):") {
        $letter = $Matches[1]
        if ($currentUSBs -notcontains $letter) {
            Remove-ItemProperty -Path $mountedPath -Name $name -Force -ErrorAction SilentlyContinue
            Write-Host "[+] Removed stale mounted USB: $name"
        }
    }
}

# -------------------------
# STEP 5: Clear setupapi logs
# -------------------------
$logFiles = @(
    "$env:SystemRoot\INF\setupapi.dev.log",
    "$env:SystemRoot\INF\setupapi.app.log",
    "$env:windir\System32\LogFiles\WMI\RtBackup",
    "$env:windir\setupapi.log"
)

foreach ($log in $logFiles) {
    if (Test-Path $log) {
        Remove-Item $log -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Deleted log: $log"
    }
}

Write-Host "`n[✔] Cleaned USB traces and stale devices from registry. | by GOD AKSHIT - discord.gg/hindustan"
