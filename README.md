
# 真真真真Dockerfile
## 真
真真真真真真真�Dockerfile真�
GPU vesion�CPU version真真真真�
you csn pull image or build by yourself.
## 真�
### pull image
builded image is in the dockerhub
真真�[dockerhub](https://hub.docker.com/r/sakakib/)真真真真

```bash
docker pull sakakib/opencv:latest.cpu
```
or
```bash
docker pull sakakib/opencv:latest.gpu
```
### how to build
if you want to build by yourself, you can build following simply.
```bash
docker build -t image_name -f (Dockerfile_gpu or Dockerfile_cpu) .
```
Initial user is hoge. hoge is a sudoer and its UID is 1000. I set NO PASSWORD for sudoer by writing `ALL=(ALL) NOPASSWD:ALL` in `/etc/sudoers`.

This Dockerfile make an user in image. You can change user name, UID and password from default with `--build-arg` flag. Make sure that changing user password makes no sence because all sudoers do not require password. 
```bash
docker build -t image_name -f Dockerfile_gpu --build-arg USER_NAME='your name' --build-arg UID='your UID' .
```
### cerate container
you can create container as following.
```bash
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv /bin/bash
```
this image have fish shell.
```bash
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv /usr/bin/fish
```
If you want to run jupyter notebook immediately, run following command.
```bash
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv:latest.gpu ./run_jupyter.sh
```
When you want to set up jupyter notebook configure, please use this script.
```bash
python3 jupyter-init-setting-python3.py
```

- ```-p 8888:8888```�jupuyter notebook�
- ```-p 52698:52698```�rsub(for sublime text)真真真真�
- ```jupyter-init-setting-python3.py```�jupyter notebook真真真真真真
    - 真真真真
    - 真�ip真真真真真
    - 真真真真真真真
    - ```/workspace/```�jupyter notebook真真真真真真�

### 真真真真真真�
hoge: sudoer


## 真

- 真�
    - ubuntu16.04
- 真真
    - opencv 3.4.1 (python3真)
    - python 3.5.2
    - skitlearn
    - cuda 9.0
    - cudnn7
    - tensorflow latest
    - dlib
    - boost
    - webcolors master
- 真真�
    - fish shell
        - peco (Ctrl + r)
        - ect..
    - powerlinefont
    - jupyter notebook / lab
   

## 真
```python3```真真真�python3真真真真
真真真真python真真真真真
