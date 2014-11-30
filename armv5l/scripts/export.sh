#!/bin/sh

cd $HOME/build
cp -Pv $HOME/cross-compiler-armv5l/bin/* $HOME/build/bin/
cp -Pv $HOME/cross-compiler-armv5l/lib/* $HOME/build/lib/
tar cvzf /vagrant/filetree.tar.gz *
