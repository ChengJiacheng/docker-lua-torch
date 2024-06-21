# FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
# FROM nvidia/cuda:8.0-cudnn5-devel
# FROM nvidia/cuda:11.1.1-cudnn8-devel
# FROM eywalker/nvidia-cuda:8.0-cudnn5-devel

# FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu16.04

FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-devel

# update nvidia public key
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

# install deps
RUN apt-get update && apt-get install -y git sudo

# install torch7
RUN git clone https://github.com/nagadomi/distro.git /root/torch --recursive && \
    cd /root/torch && \
     ./install-deps && \
     TORCH_CUDA_ARCH_LIST="Kepler Maxwell Kepler+Tegra Kepler+Tesla Maxwell+Tegra Pascal Volta 7.5+PTX" ./install.sh -b

# set env, from torch-activate
ENV LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.lua;/root/torch/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua'
ENV LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;/root/torch/install/lib/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so'
ENV PATH=/root/torch/install/bin:$PATH
ENV LD_LIBRARY_PATH=/root/torch/install/lib:$LD_LIBRARY_PATH
ENV DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH
ENV LUA_CPATH='/root/torch/install/lib/?.so;'$LUA_CPATH

WORKDIR /root/

RUN git config --global url."https://".insteadOf git:// 
RUN luarocks install graphicsmagick