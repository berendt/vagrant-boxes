#!/bin/sh

export PATH="${PATH}:$HOME/cross-compiler-armv5l/bin"

cd $HOME
mkdir -p $HOME/build
wget http://www.busybox.net/downloads/busybox-1.22.1.tar.bz2
tar xjf busybox-1.22.1.tar.bz2
cd busybox-1.22.1
CC=armv5l-gcc ./configure --prefix=$HOME/build --host=arm
make
make install
