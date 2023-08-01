Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force
Install-Module -name AWSPowerShell.NetCore -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Import-Module AWSPowerShell.NetCore
Get-AWSPowerShellVersion
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco feature enable -n allowGlobalConfirmation
choco uninstall vscode -Force
choco install vscode -Force
Remove-Item C:\Users\*\Desktop\"Visual Studio Code".lnk -Force
setx path "%path%;'C:\Program Files\Microsoft VS Code\bin'"
$env:Path += ";'C:\Program Files\Microsoft VS Code\bin'"

# VSCODE EXTENSIONS
& 'C:\Program Files\Microsoft VS Code\bin\code' --install-extension ms-vscode-remote.remote-ssh
echo "remote ssh extension installed"

# FONTS
if (Test-Path "~/fonts") {Remove-Item -Force -Recurse ~/fonts}
mkdir ~/fonts
wget -o "~/fonts/MesloLGS NF Regular.ttf"       "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Regular.ttf"
wget -o "~/fonts/MesloLGS NF Italic.ttf"        "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Italic.ttf"
wget -o "~/fonts/MesloLGS NF Bold.ttf"          "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold.ttf"
wget -o "~/fonts/MesloLGS NF Bold Italic.ttf"   "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold Italic.ttf"
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
dir ~/fonts/*.ttf | %{ $fonts.CopyHere($_.fullname) }

# SETTINGS
if (Test-Path "~/AppData/Roaming/Code/User") {pwd} else {mkdir "~/AppData/Roaming/Code/User"}
wget -o ~/AppData/Roaming/Code/User/settings.json https://s3-us-west-2.amazonaws.com/cloudgeniuscode/settings.json

choco install git -Force --no-progress
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
# choco install winscp -Force
# Remove-Item C:\Users\*\Desktop\WinSCP.lnk -Force

choco install miniconda3 -Force --no-progress --params="'/AddToPath:1 /InstallationType:AllUsers /RegisterPython:1'"

# source $HOME/miniconda3/bin/activate

powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\tools\miniconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\tools\miniconda3' "

conda init powershell
conda config --set auto_activate_base false
conda update -n base -c defaults conda -y
conda update --all -y
