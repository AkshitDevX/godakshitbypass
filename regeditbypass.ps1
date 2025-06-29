# TOOL: DLL Trace Remover | AUTHOR: GOD AKSHIT | discord.gg/hindustan

# Function to safely delete registry keys containing target strings
function Remove-RegKeysContaining {
    param($root, $search)
    Get-ChildItem -Path "Registry::$root" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_ -and $_.Name -match $search) {
            try {
                Remove-Item -Path $_.PsPath -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "[+] Deleted Key: $($_.PsPath)"
            } catch {}
        }
    }
}

# Step 1: Remove "Recent File" traces (DLL, APK, EXE)
$recentPaths = @(
    "$env:APPDATA\Microsoft\Windows\Recent",
    "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Recent",
    "$env:TEMP",
    "$env:USERPROFILE\Downloads"
)

$patterns = '*.dll','*.apk','*.exe'

foreach ($path in $recentPaths) {
    foreach ($pat in $patterns) {
        Get-ChildItem -Path $path -Filter $pat -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    }
}

# Step 2: Remove traces from registry
$regPaths = @(
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU",
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU",
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\FirstFolder",
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs",
    "HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR",
    "HKCU\Software\Microsoft\Windows\CurrentVersion\UFH\SHC"
)

foreach ($reg in $regPaths) {
    Remove-RegKeysContaining -root $reg -search "dll|apk|exe|Internal|ntdll|HD-Player"
}

# Step 3: Remove known loaded DLLs from HKLM Image File Execution Options (for HD-Player)
$exeHooks = @(
    "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\HD-Player.exe",
    "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Bluestacks.exe"
)

foreach ($hook in $exeHooks) {
    if (Test-Path "Registry::$hook") {
        Remove-Item -Path "Registry::$hook" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Removed Image Execution Hook: $hook"
    }
}

# Step 4: Clean MountPoints2 USB traces
try {
    Remove-Item -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "[+] Removed MountPoints2 (USB traces)"
} catch {}

# Step 5: Remove any lingering Internal.dll or ntdll.dll trace from full registry
Remove-RegKeysContaining -root "HKLM" -search "Internal.dll|ntdll.dll"
Remove-RegKeysContaining -root "HKCU" -search "Internal.dll|ntdll.dll"

Write-Host "`n[✔] All DLL & HD-Player traces removed | BY GOD AKSHIT - discord.gg/hindustan"
