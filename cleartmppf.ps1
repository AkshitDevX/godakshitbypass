# Credit: GOD AKSHIT | discord.gg/hindustan

# Function to delete all contents from a folder
function Clear-Folder($path) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path -Force -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# Delete %TEMP%
Clear-Folder "$env:TEMP"

# Delete C:\Windows\Temp
Clear-Folder "C:\Windows\Temp"

# Delete C:\Windows\Prefetch
Clear-Folder "C:\Windows\Prefetch"

# Delete Recent folder
Clear-Folder "$env:APPDATA\Microsoft\Windows\Recent"

# Empty Recycle Bin
$shell = New-Object -ComObject Shell.Application
$recycleBin = $shell.NameSpace(0xA)
$recycleBin.Items() | ForEach-Object { Remove-Item $_.Path -Force -Recurse -ErrorAction SilentlyContinue }

Write-Host "✅ Cleanup completed successfully.Credit: GOD AKSHIT | discord.gg/hindustan"
