<#
  

    ➤ Script by: GOD AKSHIT
    ➤ Discord Server: https://discord.gg/hindustan
    ➤ Operation: Stealth rename & move .dll files to %TEMP%
#>

# === Define original DLL paths ===
$DllsToHandle = @(
    @{ Path = "C:\Windows\System32\Windows.Mirage.Internal.dll"; NewName = "~DF70B737FA89A042D23.TMP" },
    @{ Path = "C:\Windows\System32\Windows.Mirage.ntdll.dll";   NewName = "~DF70B737FA89A042D24.TMP" }
)

# === Get temp path ===
$TempPath = [System.IO.Path]::GetTempPath()

# === Process each DLL ===
foreach ($dll in $DllsToHandle) {
    $Source = $dll.Path
    $Target = Join-Path $TempPath $dll.NewName

    if (Test-Path $Source) {
        Copy-Item -Path $Source -Destination $Target -Force
        Remove-Item -Path $Source -Force
        Write-Host "✅ $($dll.NewName) moved to %TEMP%" -ForegroundColor Green
    } else {
        Write-Host "❌ Not found: $Source" -ForegroundColor Red
    }
}
