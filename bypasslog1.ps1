<#
    Script Name : Temp File Renamer & Mover
    Author      : Akshit Paul (Coders Corporation)
    Description : Renames 'optimization_guide_internal.dll' and 'abd.log' to
                  '~DF70B737FA89A042D22.TMP' and moves them to %TEMP% path.
    Purpose     : Stealth relocation of suspicious or operational files.
#>

# Define the original files (assumed to be in current folder)
$sourceFiles = @("optimization_guide_internal.dll", "abd.log")

# Define stealthy temp file name
$newName = "~DF70B737FA89A042D22.TMP"

# Get system temp directory
$tempDir = $env:TEMP

foreach ($file in $sourceFiles) {
    if (Test-Path $file) {
        # Full destination path
        $targetPath = Join-Path -Path $tempDir -ChildPath $newName

        try {
            # Rename and move to TEMP
            Rename-Item -Path $file -NewName $newName -Force
            Move-Item -Path $newName -Destination $targetPath -Force

            Write-Host "[+] '$file' renamed and moved to '$targetPath'| CODER CORPORATION"
        } catch {
            Write-Host "[-] Error handling '$file': $_| CODER CORPORATION"
        }
    } else {
        Write-Host "[-] File not found: $file| CODER CORPORATION"
    }
}

Write-Host "`n[✓] Script completed by Akshit Paul — Coders Corporation discor.gg/hindustan"
