#!/bin/bash

# install packages
sudo apt-get install -y fish wget curl language-pack-ja-base fonts-powerline
curl -Lo ${HOME}/.config/fish/functions/fisher.fish --create-dirs git.io/fisher

# copy files
cp peco_select_history.fish ${HOME}/.config/fish/functions/
co config.fish ${HOME}/.config/fish/
sudo chmod +x fish_config.sh

# install tools
./fish_config.sh
### install peco
wget -O - 'https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_amd64.tar.gz' | tar zxvf - 
sudo mv peco_linux_amd64/peco /usr/local/bin/ 
rm -rf peco_linux_amd64 

# set fish shell as a default
sudo chsh -s /usr/bin/fish 
sudo chsh -s /usr/bin/fish ${USER}
# ENV LC_CTYPE='ja_JP.UTF-8'
