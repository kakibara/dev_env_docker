
# 画像処理のためのDockerfile
## 概要
画像処理のためのツールを詰めたDockerfile
GPUを使うことを前提としている。
you csn pull image or build by yourself.
## 使い方
### pull image
builded image is in the dockerhub
イメージは[dockerhub](https://hub.docker.com/r/sakakib/)に登録している。

```
docker pull sakakib/opencv:latest
```
### how to build
if you want to build by yourself, you can build following simply.
```bash
docker build -t image_name .
```
Initial user is hoge. hoge is a sudoer and its UID is 1000. I set NO PASSWORD for sudoer by writing `ALL=(ALL) NOPASSWD:ALL` in `/etc/sudoers`.

This Dockerfile make an user in image. You can change user name, UID and password from default with `--build-arg` flag. Make sure that changing user password makes no sence because all sudoers do not require password. 
```bash
docker build -t image_name --build-arg USER_NAME='your name' --build-arg UID='your UID' .
```
### cerate container
you can create container as following.
```
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv /bin/bash
```
this image have fish shell.
```
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv /usr/bin/fish
```
if you want to configure upyter notebook, run following script.
```
python3 jupyter-init-setting-python3.py
```

- ```-p 8888:8888```はjupuyter notebook用
- ```-p 52698:52698```でrsub(for sublime text)を使用可能にする。
- ```jupyter-init-setting-python3.py```はjupyter notebookに以下の設定を行います。
    - パスワードの設定
    - 全てのipからの接続を許可する
    - ブラウザを自動で開かなくする
    - ```$HOME/```をjupyter notebookのホームディレクトリとする

### デフォルトユーザーについて
hoge: sudoer


## 中身

- ベース
    - ubuntu16.04
- 計算環境
    - opencv 3.3.0 (python3のみ)
    - python 3.5.2
    - skitlearn
    - cuda 8.0
    - cudnn6
    - tensorflow 1.3
    - dlib
    - boost
    - webcolors master
- 開発ツール
    - fish shell
        - peco (Ctrl + r)
        - ect..
    - powerlinefont
    - jupyter notebook / lab
   

## 注意
```python3```と書かなければpython3は起動しません。
摘便デフォルトのpythonを変更してください。
jupyterはデフォルトで全てのIPからの接続を許可しています。
jupyter notebookの初期パスワードを設定していますが、適当に変更して使ってください。
