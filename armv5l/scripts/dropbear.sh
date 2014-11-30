#!/bin/sh

export PATH="${PATH}:$HOME/cross-compiler-armv5l/bin"

cd $HOME
wget https://matt.ucc.asn.au/dropbear/releases/dropbear-2014.66.tar.bz2
tar xjf dropbear-2014.66.tar.bz2
cd dropbear-2014.66
CC=armv5l-gcc ./configure --prefix=$HOME/build --with-zlib=$HOME/build --host=arm
make
make scp
make install
cp scp $HOME/build/bin
