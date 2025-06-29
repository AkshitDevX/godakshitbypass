# Credit: GOD AKSHIT | discord.gg/hindustan

# Generate 50 random .TMP files in %temp%
1..50 | ForEach-Object {
    $tmpName = "~" + ([System.Guid]::NewGuid().ToString("N").Substring(0,16).ToUpper()) + ".TMP"
    $tmpPath = Join-Path $env:TEMP $tmpName
    New-Item -Path $tmpPath -ItemType File -Force | Out-Null
}

# Generate 50 random .pf files in Prefetch (requires admin)
$prefetchPath = "C:\Windows\Prefetch"
if (Test-Path $prefetchPath) {
    1..50 | ForEach-Object {
        $pfName = ([System.Guid]::NewGuid().ToString("N").Substring(0,12).ToUpper()) + ".pf"
        $pfPath = Join-Path $prefetchPath $pfName
        New-Item -Path $pfPath -ItemType File -Force | Out-Null
    }
} else {
    Write-Host "Prefetch folder not found."
}
