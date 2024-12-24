@echo off
setlocal

:: Tentukan nama file PowerShell
set "ps1file=%ProgramData%\UpdateWindows.ps1"

:: Buat file PowerShell dengan isi yang diinginkan
echo Install-Module -Name PSWindowsUpdate -Force > %ps1file%
echo Import-Module PSWindowsUpdate >> %ps1file%
echo Get-WindowsUpdate -Install -AcceptAll -AutoReboot >> %ps1file%
@REM echo Get-WindowsUpdate -Install -AcceptAll >> %ps1file%

:: Jalankan file PowerShell dengan hak administrator
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%ps1file%""' -WindowStyle Maximized -Verb RunAs}"

endlocal