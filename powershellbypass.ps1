<#
  Credit: GOD AKSHIT | discord.gg/hindustan
  Function: 
    - Backup PowerShell Execution Logs
    - Clear logs (Event ID 4104, 4100, 403)
    - Random .tmp file created in %TEMP%
    - Deletes the temp file permanently
    - Clears ExecutionPolicy traces from Registry (if present)
#>

# Step 1: Generate random temp file name
$randomName = "pslog_" + -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_}) + ".tmp"
$tmpPath = Join-Path $env:TEMP $randomName

# Step 2: Export PowerShell logs
try {
    $logs = Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -ErrorAction SilentlyContinue |
            Where-Object { $_.Id -eq 4104 -or $_.Id -eq 4100 -or $_.Id -eq 403 }

    if ($logs) {
        $logs | Out-File -FilePath $tmpPath -Encoding utf8 -Force
        Write-Host "✅ Logs backed up to: $tmpPath" -ForegroundColor Yellow
    }

    # Step 3: Clear the logs
    wevtutil cl "Microsoft-Windows-PowerShell/Operational"
    Write-Host "🧹 PowerShell execution logs cleared." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to access or clear logs: $_" -ForegroundColor Red
}

# Step 4: Delete the temp file permanently
try {
    Remove-Item -Path $tmpPath -Force -ErrorAction SilentlyContinue
    Write-Host "🗑️ Temp file deleted from: $tmpPath" -ForegroundColor Cyan
} catch {
    Write-Host "⚠️ Could not delete temp file: $_"
}

# Step 5: Clear ExecutionPolicy traces from Registry
try {
    Remove-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "ExecutionPolicy" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "ExecutionPolicy" -ErrorAction SilentlyContinue
    Write-Host "✅ Registry traces of ExecutionPolicy cleared." -ForegroundColor DarkGreen
} catch {
    Write-Host "❌ Failed to clear registry traces: $_"
}
