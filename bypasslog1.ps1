function Get-RandomTmpName {
    return "~DF" + -join ((48..57) + (65..70) | Get-Random -Count 16 | ForEach-Object {[char]$_}) + ".TMP"
}

$files = @(
    "$env:USERPROFILE\imgui.ini",
    "$env:TEMP\adb.log",
    "C:\Windows\System32\Windows.Mirage.Internal.dll",
    "C:\Windows\System32\Windows.Mirage.ntdll.dll"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        try {
            $tmpName = Get-RandomTmpName
            $destination = Join-Path $env:TEMP $tmpName
            Copy-Item $file $destination -Force
            Remove-Item $file -Force
            Write-Host "Moved: $file → $tmpName | by god akshit | discord.gg/hindustan" -ForegroundColor Green
        } catch {
            Write-Host "Error moving $file | by god akshit | discord.gg/hindustan" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Not Found: $file | by god akshit | discord.gg/hindustan" -ForegroundColor Red
    }
}

