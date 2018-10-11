
# Docker for machine learing
## note
Dockerfile_cpu is too old and not unmaintened
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

If you want to add some python packages, please edit ```python-requirements.txt```.
Please note that following packages are already installed before installing packages written in ```python-requirements.txt```.

- numpy
- scipy
- opencv
- ipython
- jupyter notebook
- jupyter lab

### cerate container
You can use bash or fish shell.
When you want to set up jupyter notebook configure, please use this script.
- bash
```bash
nvidia-docker run --rm -it -v $(pwd):/workspace/ -p 8888:8888 sakakib/opencv bash
```
- fish shell.
```bash
nvidia-docker run --rm -it -v (pwd):/workspace/ -p 8888:8888 sakakib/opencv fish
```
- run jupyter lab directory
```bash
nvidia-docker run --rm -it -p 8888:8888 sakakib/opencv:latest.gpu run_jupyter.sh
```

### original script
following original scripts are installed in ```/opt/script/bin```.

- ```run_jupyter.sh```
- ```jupyter-init-setting-python3.py```

```jupyter-init-setting-python3.py``` make following settings

- set password of jupyter notebook
- set jupyter notebook's home directory as /workspace
- allow access from all ip

default user is hoge(sudoer)


## packages

- base
    - ubuntu16.04
- packages
    - python 3.5.2
    - cuda 9.0
    - cudnn7
    - dlib
    - boost
- shell
    - fish shell
        - peco (Ctrl + r)
        - ect..
    - powerlinefont
- others
    - jupyter notebook / lab
    - follow pythonreqirement.txt 

