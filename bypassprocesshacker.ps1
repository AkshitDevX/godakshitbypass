# ===========================
# CREDIT: GOD AKSHIT - discord.gg/hindustan
# TOOL: Global DLL Memory Hook Renamer to .TMP
# ===========================

# Target DLLs known to interact with memory/processes
$targetDlls = @(
    "ToolStatus.dll",
    "SbieSupport.dll",
    "OnlineChecks.dll",
    "ExtendedTools.dll"
)

# Get %TEMP% directory
$tempDir = $env:TEMP

# Function to generate a random .TMP filename
function Get-RandomTmpName {
    return "~DF" + ([System.Guid]::NewGuid().ToString("N").Substring(0, 16)).ToUpper() + ".TMP"
}

# Recursively search C:\ for matching DLLs
foreach ($dllName in $targetDlls) {
    try {
        $foundFiles = Get-ChildItem -Path "C:\" -Filter $dllName -Recurse -ErrorAction SilentlyContinue -Force
        foreach ($file in $foundFiles) {
            $randomTmp = Get-RandomTmpName
            $tmpPath = Join-Path $tempDir $randomTmp

            try {
                Rename-Item -Path $file.FullName -NewName $randomTmp -Force
                Move-Item -Path (Join-Path $file.DirectoryName $randomTmp) -Destination $tmpPath -Force
                Write-Host "[+] Renamed & Moved: $($file.FullName) -> $tmpPath"
            } catch {
                Write-Host "[-] Rename/Move Failed: $($file.FullName) - $_"
            }
        }
    } catch {
        Write-Host "[-] Error scanning for $dllName - $_"
    }
}

Write-Host "`nCREDIT: Script by GOD AKSHIT | discord.gg/hindustan"
