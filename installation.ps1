Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -name AWSPowerShell.NetCore -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Import-Module AWSPowerShell.NetCore
Get-AWSPowerShellVersion
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco feature enable -n allowGlobalConfirmation
choco install vscode -Force
setx path "%path%;'C:\Program Files\Microsoft VS Code\bin'"
$env:Path += ";'C:\Program Files\Microsoft VS Code\bin'"

#VSCODE EXTENSIONS
& 'C:\Program Files\Microsoft VS Code\bin\code' --install-extension ms-vscode-remote.remote-ssh
& 'C:\Program Files\Microsoft VS Code\bin\code' --install-extension eamodio.gitlens
& 'C:\Program Files\Microsoft VS Code\bin\code' --install-extension CrazyFluff.bettermaterialthemedarkerhighcontrast
& 'C:\Program Files\Microsoft VS Code\bin\code' --install-extension vangware.dark-plus-material
& 'C:\Program Files\Microsoft VS Code\bin\code' --install-extension PKief.material-icon-theme

#FONTS
if (Test-Path "~/fonts") {Remove-Item -Force -Recurse ~/fonts}
mkdir ~/fonts
wget -o "~/fonts/MesloLGS NF Regular.ttf"       "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Regular.ttf"
wget -o "~/fonts/MesloLGS NF Italic.ttf"        "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Italic.ttf"
wget -o "~/fonts/MesloLGS NF Bold.ttf"          "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold.ttf"
wget -o "~/fonts/MesloLGS NF Bold Italic.ttf"   "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold Italic.ttf"
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
dir ~/fonts/*.ttf | %{ $fonts.CopyHere($_.fullname) }

#SETTINGS
if (Test-Path "~/AppData/Roaming/Code/User") {pwd} else {mkdir "~/AppData/Roaming/Code/User"}
wget -o ~/AppData/Roaming/Code/User/settings.json https://s3-us-west-2.amazonaws.com/cloudgeniuscode/settings.json

choco install winscp -Force
choco install git -Force
choco install miniconda3 -Force
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

Remove-Item C:\Users\*\Desktop\"Visual Studio Code".lnk -Force
Remove-Item C:\Users\*\Desktop\WinSCP.lnk -Force
