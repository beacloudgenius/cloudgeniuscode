Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -name AWSPowerShell.NetCore -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Import-Module AWSPowerShell.NetCore
Get-AWSPowerShellVersion
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco feature enable -n allowGlobalConfirmation
choco install vscode -Force
setx path "%path%;'C:\Program Files\Microsoft VS Code\bin'"
choco install winscp -Force
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
