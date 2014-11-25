#!/bin/sh

set -x

vagrant up
vagrant reconfig
vagrant sandbox on
vagrant ssh controller -c '/home/vagrant/initialize.sh'
vagrant ssh controller -c '/home/vagrant/patch.sh'
vagrant ssh controller -c 'packstack --answer-file /home/vagrant/packstack.answers'
