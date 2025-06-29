<#


    ➤ Script by: Akshit Paul (devXakshit)
    ➤ Special Thanks: devXakshit Forensics & Reversing Lab
    ➤ Discord: https://discord.gg/hindustan
#>

$TempPath = [System.IO.Path]::GetTempPath()
$SourceFile = Join-Path $TempPath "adb.log"
$TargetFile = Join-Path $TempPath "~DF70B737FA89A042D22.TMP"

if (Test-Path $SourceFile) {
    Rename-Item -Path $SourceFile -NewName "~DF70B737FA89A042D22.TMP" -Force
    Write-Host "Renamed adb.log to ~DF70B737FA89A042D22.TMP | CREDIT - GOD AKSHIT / CODERS CORPORATION"
} else {
    Write-Host "adb.log not found in TEMP directory. | CODERS CORPORATION"
}
