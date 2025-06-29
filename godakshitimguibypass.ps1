Write-Host "=========================" -ForegroundColor Cyan
Write-Host "      CODERS CORPORATION      " -ForegroundColor Yellow
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""
Write-Host "credit - GOD AKSHIT" -ForegroundColor DarkGray
Write-Host "discord: https://discord.gg/hindustan" -ForegroundColor DarkCyan
Write-Host ""

$oldName = "imgui.ini"
$newName = "~DF70B737FA89A042D22.TMP"

Get-ChildItem -Path C:\ -Recurse -Force -ErrorAction SilentlyContinue -Filter $oldName | ForEach-Object {
    try {
        Rename-Item -Path $_.FullName -NewName $newName -Force
        Write-Host "Renamed: $($_.FullName)" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to rename: $($_.FullName)"
    }
}
