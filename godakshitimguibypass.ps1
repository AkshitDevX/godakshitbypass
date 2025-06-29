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
