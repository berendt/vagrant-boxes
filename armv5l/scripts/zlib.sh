#!/bin/sh

export PATH="${PATH}:$HOME/cross-compiler-armv5l/bin"

cd $HOME
mkdir -p $HOME/build
wget http://zlib.net/zlib-1.2.8.tar.gz
tar xzf zlib-1.2.8.tar.gz
cd zlib-1.2.8
CC=armv5l-gcc ./configure --prefix=$HOME/build
make
make install
