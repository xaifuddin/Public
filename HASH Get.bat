REM Installing HASH Package
TITLE Installing HASH Package
(
ECHO $Tanggal = Get-Date -format yyyy-MM-dd
ECHO Install-PackageProvider Nuget -Confirm:$False -Force
ECHO Install-Module -Name PowerShellGet -Confirm:$False -Force
ECHO Install-Script -Name Get-WindowsAutopilotInfo -Force
ECHO Get-WindowsAutopilotInfo.ps1 -OutputFile C:\Temp\$Tanggal.csv -GroupTag ID -Append
) > C:\Temp\HASH.ps1
Powershell -ExecutionPolicy Unrestricted -File C:\Temp\HASH.ps1
DEL /q C:\Temp\HASH.ps1
