#!/bin/sh

cd $HOME/build
cp -Pv $HOME/cross-compiler-armv5l/bin/* $HOME/build/bin/
cp -Pv $HOME/cross-compiler-armv5l/lib/* $HOME/build/lib/
for dir in $(ls -1); do
    tar cvf /vagrant/$dir.tar $dir
done
