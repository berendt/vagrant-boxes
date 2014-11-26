#!/bin/sh

set -x

vagrant up
vagrant reconfig
vagrant sandbox on
vagrant ssh controller -c '/home/vagrant/initialize.sh'
