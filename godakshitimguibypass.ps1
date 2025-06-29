# Credit: GOD AKSHIT | discord.gg/hindustan

Get-ChildItem -Path C:\ -Filter "imgui.ini" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $randomName = "~" + ([System.Guid]::NewGuid().ToString("N").Substring(0, 16).ToUpper()) + ".TMP"
        $destination = Join-Path $env:TEMP $randomName
        Move-Item -Path $_.FullName -Destination $destination -Force
        Write-Host "Moved $($_.FullName) to $destination |Credit: GOD AKSHIT | discord.gg/hindustan"
    } catch {
        Write-Host "Failed to move $($_.FullName): $_ |Credit: GOD AKSHIT | discord.gg/hindustan"
    }
}
