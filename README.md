
# Docker for machine learing
## overview
Thete are GPU vesion and CPU version.
You can pull image or build by yourself.
## hou to use
### pull image
builded image is in the dockerhub
[dockerhub](https://hub.docker.com/r/sakakib/)

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
You can use bash or fish shell.
When you want to set up jupyter notebook configure, please use this script.
Note that this container start at `/workspace`.
- bash
```bash
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv bash
```
- fish shell.
```bash
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv fish
```
- jupyter script
```bash
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv:latest.gpu ./run_jupyter.sh
```
Please note that you shouldn't mount host directory on `/workspace` when you want to use jupyter script. Just do as following.
```bash
nvidia-docker run --rm -it -v ${hoge}:/workspace/docs -p 8888:8888 sakakib/opencv:latest.gpu ./run_jupyter.sh
```
This is a discription about settings.
- ```-p 8888:8888``` jupuyter notebook
- ```-p 52698:52698``` rsub(for sublime text)
- ```jupyter-init-setting-python3.py``` make following settings
    - set password of jupyter notebook
    - set jupyter notebook's home directory as /workspace
    - allow access from all ip

### tools
- jupyter setting script
```bash
python3 jupyter-init-setting-python3.py
```
default user is hoge(sudoer)

## packages

- base
    - ubuntu16.04
- packages
    - opencv 3.4.1 (python3¿¿)
    - python 3.5.2
    - skitlearn
    - cuda 9.0
    - cudnn7
    - tensorflow latest
    - dlib
    - boost
    - webcolors master
- shell
    - fish shell
        - peco (Ctrl + r)
        - ect..
    - powerlinefont
    - jupyter notebook / lab
   

