FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

MAINTAINER Sakakibara Akiyuki <moritarizumu@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV CUDNN_VERSION 6.0.21
ARG OPENCV_VERSION="3.3.0"
ARG UBUNTU_VERSION="16.04"
ARG PYTHON_VERSION="3.5"

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get -y upgrade \
&&  apt-get install -y --no-install-recommends \
            libcudnn6=$CUDNN_VERSION-1+cuda8.0 \
            libcudnn6-dev=$CUDNN_VERSION-1+cuda8.0
# &&  rm -rf /var/lib/apt/lists/*
### package needed
RUN apt-get install -y git apt-file pkg-config wget unzip \
&&  apt-file update \
&&  apt-file search add-apt-repository \
&&  apt-get install -y software-properties-common \
                       python-software-properties \
                       apt-transport-https \
&&  add-apt-repository ppa:fkrull/deadsnakes \
### python install
&&  apt-get install -y python${PYTHON_VERSION}-dev python-pip python3-pip \
                       python-numpy python3-numpy \
                       python-scipy python3-scipy \
                       python-setuptools python3-setuptools \
                       python-matplotlib python3-matplotlib \
                       libatlas-dev \
&&  pip install --upgrade pip \
&&  pip3 install --upgrade pip
### for build opencv 
RUN apt-get install -y cmake build-essential libgtk2.0-dev\
                       libavcodec-dev libavformat-dev libswscale-dev \
                       libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev \
                       libjasper-dev libdc1394-22-dev libeigen3-dev libtbb-dev \
                       libopenblas-dev liblapack-dev
# cal env
## install opencv with CUDA
WORKDIR /root

RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&&  unzip ${OPENCV_VERSION}.zip \
&&  rm ${OPENCV_VERSION}.zip \
&&  wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
&&  unzip ${OPENCV_VERSION}.zip \
&&  rm ${OPENCV_VERSION}.zip \
&&  mkdir opencv-${OPENCV_VERSION}/cmake_binary \
&&  cd opencv-${OPENCV_VERSION}/cmake_binary \
&&  cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D BUILD_opencv_python2=ON \
      -D BUILD_NEW_PYTHON_SUPPORT=ON \
      -D BUILD_opencv_python3=ON \
      -D WITH_CUDA=ON \
      -D WITH_TBB=ON \
      -D ENABLE_FAST_MATH=1 \
      -D WITH_NVCUVID=ON \
      -D CUDA_FAST_MATH=1 \
      -D WITH_CUBLAS=1 \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
      -D BUILD_EXAMPLES=ON \
      -D CUDA_CUDA_LIBRARY=/usr/local/cuda/lib64/stubs/libcuda.so \
      -D WITH_FFMPEG=ON \
      -D HAVE_opencv_python3=ON \
      -D PYTHON_EXECUTABLE=/usr/bin/python \
      -D PYTHON3_EXECUTABLE=/usr/bin/python3 \
      -D PYTHON_INCLUDE_DIR=/usr/include/python2.7 \
      -D PYTHON3_INCLUDE_DIR=/usr/include/python${PYTHON_VERSION}m \
      -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python2.7 \
      -D PYTHON3_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python${PYTHON_VERSION}m \
      -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7 \
      -D PYTHON3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython${PYTHON_VERSION}m \
      -D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python${PYTHON_VERSION} \
      -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include \
      -D PYTHON3_PACKAGES_PATH=/usr/lib//python3/site-packages \
      -D PY_PIP=/usr/local/lib/python${PYTHON_VERSION}/dist-packages/pip \
      .. \
&&  make -j$(nproc) \
&&  make install \
&&  cp lib/python3/cv2.* /usr/local/lib/python${PYTHON_VERSION}/dist-packages/ \
&&  cd /root \
&&  rm -rf opencv*
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

## install boost
RUN wget -O - 'https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz' | tar zxvf - \
&&  cd boost* \
&&  ./bootstrap.sh --with-libraries=python --with-python=python3 \
&&  ./b2 install -j$(nproc) \
&&  cd .. \
&&  rm -r boost*

## install dlib
ARG DLIB_VERSION="v19.6"
RUN wget https://github.com/davisking/dlib/archive/${DLIB_VERSION}.zip \
&&  unzip ${DLIB_VERSION}.zip \
&&  rm ${DLIB_VERSION}.zip \
&&  cd dlib* \
&&  python3 setup.py install \
&&  cd .. \
&&  rm -r dlib*

## tensorflow and jupyter notebook lab
WORKDIR /root
RUN pip3 install tensorflow-gpu \
&&  pip3 install jupyter \
&&  pip install jupyterlab \
&&  jupyter serverextension enable --py jupyterlab --sys-prefix \
&&  python3 -m IPython kernelspec install-self \
# skit learn
&&  pip3 install scikit-learn
# webcolors
ARG WEBCOLORS_VERSION="master"
RUN wget https://github.com/ubernostrum/webcolors/archive/${WEBCOLORS_VERSION}.zip \
&&  unzip ${WEBCOLORS_VERSION}.zip \
&&  rm ${WEBCOLORS_VERSION}.zip \
&&  cd webcolors* \
&&  python3 setup.py install \
&&  cd .. \
&&  rm -rf webcolors* 

# ## install powershell
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
# &&  curl https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
# &&  apt-get update \
# &&  apt-get install -y powershell \
# &&  powershell

# tools env
## make sudo user
RUN apt-get install -y sudo \
&&  echo 'hoge ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
&&  useradd -G sudo -p `perl -e "print(crypt('hoge', 'zZ'));"` hoge \
&&  mkdir /home/hoge \
&&  chown hoge:hoge /home/hoge

USER hoge
WORKDIR /home/hoge

# install fish shell and arounds
## install powerline fonts
ARG POWERLINEFONT_VERSION="master"
RUN wget https://github.com/powerline/fonts/archive/${POWERLINEFONT_VERSION}.zip \
&&  unzip ${POWERLINEFONT_VERSION}.zip \
&&  rm ${POWERLINEFONT_VERSION}.zip \
&&  cd fonts*  \
&&  ./install.sh  \
&&  cd .. \
&&  rm -rf fonts* \
&&  fc-cache -vf ~/.local/share/fonts/
ENV LC_ALL='ja_JP.UTF-8'

### install fish
RUN mkdir ~/.config \
&&  mkdir ~/.config/fish
ADD config.fish /home/hoge/.config/fish/
ADD fish_config.sh /home/hoge/
RUN sudo chmod +x fish_config.sh \
&&  sudo add-apt-repository ppa:fish-shell/release-2 \
&&  sudo apt-get update \
&&  sudo apt-get install -y fish \
&&  sudo apt-get -y install language-pack-ja-base \
#### install fisherman
&&  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher \
&&  sudo chmod +x fish_config.sh \
&&  ./fish_config.sh \
&&  rm fish_config.sh \
#### install peco
&&  wget -O - 'https://github.com/peco/peco/releases/download/v0.5.1/peco_linux_amd64.tar.gz' | tar zxvf - \
&&  sudo mv peco_linux_amd64/peco /usr/local/bin/ \
&&  rm -rf peco_linux_amd64 \
#### set fish shell as a default
&&  sudo chsh -s /usr/bin/fish \
&&  sudo chsh -s /usr/bin/fish hoge

# install editor
RUN sudo apt-get install -y vim \
## install rsub for sublime text via ssh
&&  sudo wget -O /usr/local/bin/rsub https://raw.github.com/aurora/rmate/master/rmate \
&&  sudo chmod +x /usr/local/bin/rsub \
## set jupyter notebook
&&  jupyter notebook --generate-config
ADD jupyter-init-setting-python3.py /home/hoge/
## set matplotlib backend
RUN mkdir ~/.config/matplotlib \
&&  echo 'backend : Qt4Agg' >> $HOME/.config/matplotlib/matplotlibrc

# install ssh
RUN sudo apt-get -y install openssh-server
