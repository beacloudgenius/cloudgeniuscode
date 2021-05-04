brew install awscli@1 jq wget
echo -e "\n" >> ~/.bashrc
echo -e "\n" >> ~/.zshrc
echo 'export PATH="/usr/local/opt/awscli@1/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="/usr/local/opt/awscli@1/bin:$PATH"' >> ~/.bashrc
brew install --cask visual-studio-code
ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension eamodio.gitlens
code --install-extension CrazyFluff.bettermaterialthemedarkerhighcontrast
code --install-extension vangware.dark-plus-material
code --install-extension PKief.material-icon-theme

cd ~/Library/Fonts && {
    rm -rf MesloLGS*.ttf
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Regular.ttf"
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Italic.ttf"
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold.ttf"
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold Italic.ttf"
    cd -; }

rm -rf settings.json
curl -O https://s3-us-west-2.amazonaws.com/cloudgeniuscode/settings.json
mv -f settings.json "$HOME/Library/Application Support/Code/User/"

rm -rf $HOME/miniconda ~/miniconda.sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
rm -rf ~/miniconda.sh
source $HOME/miniconda/bin/activate
conda init zsh
conda config --set auto_activate_base false
conda update -n base -c defaults conda -y
conda update --all -y
