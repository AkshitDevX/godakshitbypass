# 🔥 Memory String Wiper for Process Hacker - Created by Akshit Paul (Coders Corporation / devXakshit)
# 🛡️ Stealth edition - removes all traces of imgui, keyauth, internal.dll etc from memory string viewers
# ❌ Runs only ONCE to prevent repetition & detection

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class MemTools {
    [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(int access, bool inherit, int pid);
    [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
    [DllImport("kernel32.dll")] public static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr baseAddress, byte[] buffer, int size, out int bytesRead);
    [DllImport("kernel32.dll")] public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr baseAddress, byte[] buffer, int size, out int bytesWritten);
    [DllImport("kernel32.dll")] public static extern bool VirtualProtectEx(IntPtr hProcess, IntPtr lpAddress, int dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@

$PROCESS_ALL_ACCESS = 0x1F0FFF
$PAGE_EXECUTE_READWRITE = 0x40
$target = "ProcessHacker"

$p = Get-Process -Name $target -ErrorAction SilentlyContinue
if (!$p) {
    Write-Host "[-] Process Hacker not running"
    return
}

$hProc = [MemTools]::OpenProcess($PROCESS_ALL_ACCESS, $false, $p.Id)
if ($hProc -eq [IntPtr]::Zero) {
    Write-Host "[-] Cannot access target process. Run as administrator."
    return
}

# 🎯 Strings to wipe - update as needed
$targets = @(
    "imgui",
    "keyauth",
    "internal.dll",
    "sinternal.dll",
    "matrix\\s internal.dll",
    "dll\\s sinternal\\s sexe\\s mirage",
    "s6e8ac8fa2d76"
)

$step = 0x10000
$maxScan = 0x7fffffff
$cleaned = 0

foreach ($str in $targets) {
    $sig = [System.Text.Encoding]::ASCII.GetBytes($str)
    $junk = New-Object byte[] $sig.Length
    (New-Object Random).NextBytes($junk)

    for ($addr = 0x10000; $addr -lt $maxScan; $addr += $step) {
        try {
            $buffer = New-Object byte[] $step
            [int]$bytesRead = 0
            $ptr = [IntPtr]$addr

            if (-not [MemTools]::ReadProcessMemory($hProc, $ptr, $buffer, $step, [ref]$bytesRead)) { continue }

            for ($i = 0; $i -le ($bytesRead - $sig.Length); $i++) {
                $match = $true
                for ($j = 0; $j -lt $sig.Length; $j++) {
                    if ($buffer[$i + $j] -ne $sig[$j]) {
                        $match = $false
                        break
                    }
                }

                if ($match) {
                    $realAddr = $addr + $i
                    [uint32]$oldProt = 0
                    [int]$written = 0

                    [MemTools]::VirtualProtectEx($hProc, [IntPtr]$realAddr, $sig.Length, $PAGE_EXECUTE_READWRITE, [ref]$oldProt) | Out-Null
                    [MemTools]::WriteProcessMemory($hProc, [IntPtr]$realAddr, $junk, $sig.Length, [ref]$written) | Out-Null

                    Write-Host "[✓] Wiped '$str' at 0x{0:X}" -f $realAddr
                    $cleaned++
                }
            }
        } catch {}
    }
}

[MemTools]::CloseHandle($hProc)

if ($cleaned -eq 0) {
    Write-Host "[-] No strings found."
} else {
    Write-Host "`n🧼 Done: $cleaned strings wiped."
}

Write-Host "`n🔒 Created by Akshit Paul // Coders Corporation // devXakshit  - discord.gg/hindustan🔥"
pause
