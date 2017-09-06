#!/usr/bin/fish

fisher install z omf/theme-agnoster omf/peco

# setting of PECO
wget https://github.com/peco/peco/releases/download/v0.5.1/peco_linux_amd64.tar.gz
tar -zxvf peco_linux_amd64.tar.gz
mv peco_linux_amd64/peco /usr/local/bin/
rm -r peco-linux-amd64/
rm peco_linux_amd64.tar.gz
