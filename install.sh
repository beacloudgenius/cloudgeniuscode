brew install awscli jq wget
brew cask install visual-studio-code
ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
code --install-extension ms-vscode-remote.remote-ssh
rm -rf settings.json
curl -O https://s3-us-west-2.amazonaws.com/cloudgeniuscode/settings.json
mv -f settings.json "$HOME/Library/Application Support/Code/User/"