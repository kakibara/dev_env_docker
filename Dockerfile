FROM nvidia/cuda:8.0-devel-ubuntu16.04

MAINTAINER Sakakibara Akiyuki <moritarizumu@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ARG OPENCV_VERSION="3.3.0"
ARG UBUNTU_VERSION="16.04"
RUN apt-get update && apt-get -y upgrade

# cal env
## install opencv with CUDA
WORKDIR /opencv
RUN apt-get install -y wget unzip cmake \
                       build-essential cmake git libgtk2.0-dev pkg-config \
                       libavcodec-dev libavformat-dev libswscale-dev \
                       libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev \
                       libjasper-dev libdc1394-22-dev libeigen3-dev libtbb-dev \
                       python3.5-dev python-dev python-pip python3-pip \
                       python-numpy python-scipy python-matplotlib \
&&  wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&&  unzip ${OPENCV_VERSION}.zip \
&&  rm ${OPENCV_VERSION}.zip \
&&  wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
&&  unzip ${OPENCV_VERSION}.zip \
&&  rm ${OPENCV_VERSION}.zip \
&&  mkdir opencv-${OPENCV_VERSION}/cmake_binary
WORKDIR /opencv/opencv-${OPENCV_VERSION}/cmake_binary
RUN pip install --upgrade pip \
&&  pip3 install --upgrade pip \
&&  pip install numpy \
&&  pip3 install numpy 
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
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
      -D PYTHON3_INCLUDE_DIR=/usr/include/python3.5m \
      -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python2.7 \
      -D PYTHON3_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.5m \
      -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7 \
      -D PYTHON3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.5m \
      -D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
      -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include \
      -D PYTHON3_PACKAGES_PATH=/usr/lib//python3/site-packages \
      -D PY_PIP=/usr/local/lib/python3.5/dist-packages/pip \
      .. \
&&  make -j$(nproc) \
&&  make install \
&&  cp lib/python3/cv2.* /usr/local/lib/python3.5/dist-packages/ \
&&  cd / \
&&  rm -rf /opencv
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

## tensorflow and jupyter notebook lab
RUN pip3 install tensorflow-gpu \
&&  pip3 install jupyter \
&&  pip install jupyterlab \
&&  jupyter serverextension enable --py jupyterlab --sys-prefix

# tools env
### package needed
RUN apt-get install -y git \
                       apt-file \
&&  apt-file update \
&&  apt-file search add-apt-repository \
&&  apt-get install -y software-properties-common \
                       python-software-properties \
                       apt-transport-https
## install powershell
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
&&  curl https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
&&  apt-get update \
&&  apt-get install -y powershell \
&&  powershell

## install fish shell and arounds
### install powerline fonts
RUN apt-get -y install language-pack-ja-base language-pack-ja ibus-mozc \
&&  git clone https://github.com/powerline/fonts.git --depth=1 \
&&  cd fonts  \
&&  ./install.sh  \
&&  cd .. \
&&  rm -rf fonts \
&&  fc-cache -vf ~/.local/share/fonts/
ENV LC_ALL='ja_JP.UTF-8'

### install fish
RUN add-apt-repository ppa:fish-shell/release-2 \
&&  apt-get update \
&&  apt-get install -y fish \
## install fisherman
&& curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher 
# ADD fish.sh /
# RUN chmod a+x fish.sh \
# &&  sh fish.sh
## set fish shell settings
WORKDIR /root
