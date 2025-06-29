# Define target locations
$locations = @(
    "$env:USERPROFILE\Desktop",
    "$env:WINDIR\System32",
    "$env:WINDIR\SysWOW64",
    "$env:USERPROFILE\Downloads",
    ${env:ProgramFiles},
    "C:\"
)

# Loop through each location
foreach ($location in $locations) {
    # Ensure directory exists
    if (-not (Test-Path $location)) {
        Write-Host "❌ Path not found: $location" -ForegroundColor Yellow
        continue
    }

    # Create 10 files in each location
    for ($i = 1; $i -le 10; $i++) {
        $file = Join-Path $location "panelfilescam2025_$i.txt"
        "This is file number $i created by PowerShell." | Out-File -Encoding UTF8 $file -Force
    }

    Write-Host "✅ Created 10 files in: $location" -ForegroundColor Green
}
