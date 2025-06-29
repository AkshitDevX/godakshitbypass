<#
  

    ➤ Script by: GOD AKSHIT
    ➤ Discord: https://discord.gg/hindustan
    ➤ Action: Stealth rename & relocate to %TEMP% with random .TMP names
#>

function Get-RandomTmpName {
    return "~DF" + -join ((48..57) + (65..70) | Get-Random -Count 16 | ForEach-Object {[char]$_}) + ".TMP"
}

$FilesToHandle = @(
    "$env:USERPROFILE\imgui.ini",
    "$env:TEMP\adb.log",
    "C:\Windows\SystemApps\Microsoft.ECApp_8wekyb3d8bbwe\GazeInputInternal.dll",
    "C:\Windows\SystemApps\Microsoft.ECApp_8wekyb3d8bbwe\Gazentdll.dll",
    "C:\Windows\System32\Windows.Mirage.ntdll.dll",
    "C:\Windows\System32\Windows.Mirage.ntdll.dll",  # repeated on request
    "C:\Windows\System32\Windows.Mirage.Internal.dll"  # newly added
)

$TempPath = [System.IO.Path]::GetTempPath()

foreach ($file in $FilesToHandle) {
    if (Test-Path $file) {
        try {
            $randomName = Get-RandomTmpName
            $target = Join-Path $TempPath $randomName

            Copy-Item -Path $file -Destination $target -Force
            Remove-Item -Path $file -Force
            Write-Host "✅ Moved '$file' ➜ '$randomName'| CODERS CORP / CREDIT - GOD AKSHIT" -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Error processing $file - $_| CODERS CORP / CREDIT - GOD AKSHIT" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ File not found: $file | CODERS CORP / CREDIT - GOD AKSHIT" -ForegroundColor Red
    }
}
