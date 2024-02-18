brew install awscli@1 jq wget python
brew link python@3.11

if [[ `uname -m` == 'arm64' ]]
then
  echo Apple Silicon detected - Homebrew preferred prefix /opt/homebrew for Apple Silicon
  grep -qxF '  export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"' ~/.zshrc  || (echo -e "\n" >> ~/.zshrc && echo 'export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"' >> ~/.zshrc)
  grep -qxF '  export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"' ~/.bashrc || (echo -e "\n" >> ~/.bashrc && echo 'export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"' >> ~/.bashrc)
else
  echo Intel CPU detected - Homebrew preferred prefix /usr/local for macOS Intel
  grep -qxF '  export PATH="/usr/local/opt/awscli@1/bin:$PATH"' ~/.zshrc  || (echo -e "\n" >> ~/.zshrc && echo 'export PATH="/usr/local/opt/awscli@1/bin:$PATH"' >> ~/.zshrc)
  grep -qxF '  export PATH="/usr/local/opt/awscli@1/bin:$PATH"' ~/.bashrc || (echo -e "\n" >> ~/.bashrc && echo 'export PATH="/usr/local/opt/awscli@1/bin:$PATH"' >> ~/.bashrc)
fi

brew install --cask visual-studio-code

if [[ `uname -m` == 'arm64' ]]
then
  echo Apple Silicon detected - Homebrew preferred prefix /opt/homebrew for Apple Silicon
  ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /opt/homebrew/bin/code
else
  echo Intel CPU detected - Homebrew preferred prefix /usr/local for macOS Intel
  ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
fi

code --install-extension ms-vscode-remote.remote-ssh
# code --install-extension eamodio.gitlens
code --install-extension CrazyFluff.bettermaterialthemedarkerhighcontrast
code --install-extension hiteshchoudharycode.chai-theme
code --install-extension vangware.dark-plus-material
code --install-extension PKief.material-icon-theme
code --install-extension aaron-bond.better-comments
# code --install-extension coenraads.bracket-pair-colorizer-2
code --install-extension oderwat.indent-rainbow
code --install-extension christian-kohler.path-intellisense
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension vscode-icons-team.vscode-icons

cd ~/Library/Fonts && {
    rm -rf MesloLGS*.ttf
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Regular.ttf"
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Italic.ttf"
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold.ttf"
    wget "https://cloudgeniuscode.s3-us-west-2.amazonaws.com/MesloLGS NF Bold Italic.ttf"
    cd -; }

cd "$HOME/Library/Application Support/Code/User/" && {
	touch settings.json
    mv settings.json ~/Previous.VSCODE.settings.json
	echo preserved your previous settings for VSCODE in ~/Previous.VSCODE.settings.json
    curl -O https://s3-us-west-2.amazonaws.com/cloudgeniuscode/settings.json
    cd -; }

if [[ `uname -m` == 'arm64' ]]
then
  echo Apple Silicon detected - Homebrew preferred prefix /opt/homebrew for Apple Silicon
  brew install miniforge
  conda init zsh
  conda config --set auto_activate_base false
  conda update -n base -c conda-forge conda -y
  conda update --all -y
else
  echo Intel CPU detected - Homebrew preferred prefix /usr/local for macOS Intel
  rm -rf $HOME/miniconda ~/miniconda.sh
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
  bash ~/miniconda.sh -b -p $HOME/miniconda
  rm -rf ~/miniconda.sh
  source $HOME/miniconda/bin/activate
  conda init zsh
  conda config --set auto_activate_base false
  conda update -n base -c defaults conda -y
  conda update --all -y
fi
