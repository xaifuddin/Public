::===============================================================================================================
@echo off
cls
setLocal EnableExtensions EnableDelayedExpansion
set "installfolder=%~dp0"
set "installfolder=%installfolder:~0,-1%"
set "installername=%~n0.bat"
::===============================================================================================================
:: CHECK ADMIN RIGHTS
fltmc >nul 2>&1
if "%errorlevel%" NEQ "0" (goto:UACPrompt) else (goto:gotAdmin)
::===============================================================================================================
:UACPrompt
echo:
echo   Requesting Administrative Privileges...
echo   Press YES in UAC Prompt to Continue
echo:
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
echo args = "ELEV " >> "%temp%\GetAdmin.vbs"
echo For Each strArg in WScript.Arguments >> "%temp%\GetAdmin.vbs"
echo args = args ^& strArg ^& " "  >> "%temp%\GetAdmin.vbs"
echo Next >> "%temp%\GetAdmin.vbs"
echo UAC.ShellExecute "%installername%", args, "%installfolder%", "runas", 1 >> "%temp%\GetAdmin.vbs"
cmd /u /c type "%temp%\GetAdmin.vbs">"%temp%\GetAdminUnicode.vbs"
cscript //nologo "%temp%\GetAdminUnicode.vbs"
del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
del /f /q "%temp%\GetAdminUnicode.vbs" >nul 2>&1
exit /B
::===============================================================================================================
:gotAdmin
if "%1" NEQ "ELEV" shift /1
if exist "%temp%\GetAdmin.vbs" del /f /q "%temp%\GetAdmin.vbs"
if exist "%temp%\GetAdminUnicode.vbs" del /f /q "%temp%\GetAdminUnicode.vbs"
::===============================================================================================================

Taskmgr.exe
exit

cls
cd /D "%installfolder%"
for /F "tokens=*" %%a in (package.info) do (
	SET /a countx=!countx! + 1
	set var!countx!=%%a
)
if %countx% LSS 5 ((echo:)&&(echo Download incomplete - Package unusable - Redo download)&&(echo:)&&(pause)&&(exit))
set "instversion=%var2%"
set "instlang=%var3%"
set "instarch1=%var4%"
if "%instarch1%" EQU "x86" set "instarch2=32"
if "%instarch1%" EQU "x64" set "instarch2=64"
set "instupdlocid=%var5%"
dir /B "%installfolder%\Office\Data\%instversion%\i%instarch2%*.*" >"%TEMP%\OfficeSetup.txt" 
for /F "tokens=* delims=" %%A in (%TEMP%\OfficeSetup.txt) DO (set "instlcidcab=%%A")
set "instlcid=%instlcidcab:~3,4%"
::=============================================================================================================== 
echo Stopping services "ClickToRunSvc" and "Windows Search"... 
sc query "WSearch" | find /i "STOPPED" 1>nul || net stop "WSearch" /y >nul 2>&1 
sc query "WSearch" | find /i "STOPPED" 1>nul || sc stop "WSearch" >nul 2>&1 
sc query "ClickToRunSvc" | find /i "STOPPED" 1>nul || net stop "ClickToRunSvc" /y >nul 2>&1 
sc query "ClickToRunSvc" | find /i "STOPPED" 1>nul || sc stop "ClickToRunSvc" >nul 2>&1 
::=============================================================================================================== 
:InstallerDelete 
rd /S /Q "%CommonProgramFiles%\Microsoft Shared\ClickToRun" >nul 2>&1 
if exist "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" goto:InstallerDelete >nul 2>&1 
md "%CommonProgramFiles%\Microsoft Shared\ClickToRun" >nul 2>&1 
echo Copying new ClickToRun installer files... 
expand "%installfolder%\Office\Data\%instversion%\i%instarch2%0.cab" -F:* "%CommonProgramFiles%\Microsoft Shared\ClickToRun" >nul 2>&1 
expand "%installfolder%\Office\Data\%instversion%\%instlcidcab%" -F:* "%CommonProgramFiles%\Microsoft Shared\ClickToRun" >nul 2>&1 
::=============================================================================================================== 
:: Set Group Policy value "UpdateBranch" in registry for "Current" 
reg add HKLM\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate /v UpdateBranch /d Current /f >nul 2>&1 
::=============================================================================================================== 
start "" /MIN setup.exe /configure configure%instarch2%.xml 
exit 
::=============================================================================================================== 
