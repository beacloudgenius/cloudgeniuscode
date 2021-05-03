Remove-Item -Force -Recurse ~/fonts
mkdir ~/fonts
wget -o "~/fonts/MesloLGS NF Regular.ttf"       "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Regular.ttf"
wget -o "~/fonts/MesloLGS NF Italic.ttf"        "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Italic.ttf"
wget -o "~/fonts/MesloLGS NF Bold.ttf"          "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold.ttf"
wget -o "~/fonts/MesloLGS NF Bold Italic.ttf"   "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold Italic.ttf"

$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
dir fonts/*.ttf | %{ $fonts.CopyHere($_.fullname) }
