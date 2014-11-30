#!/bin/sh

export PATH="${PATH}:$HOME/cross-compiler-armv5l/bin"

cd $HOME
mkdir -p $HOME/build
wget http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.35.tar.gz
tar xzf lighttpd-1.4.35.tar.gz
cd lighttpd-1.4.35
CC=armv5l-gcc ./configure --prefix=$HOME/build --without-zlib --without-bzip2 --without-pcre --host=arm
make
make install
