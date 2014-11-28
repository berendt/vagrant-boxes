#!/bin/sh

set -x

for plugin in vagrant-sandbox vagrant-hostmanager; do
(vagrant plugin list | grep $plugin) || vagrant plugin install $plugin
done

vagrant up
vagrant reload
vagrant sandbox on
vagrant ssh controller -c '/home/vagrant/scripts/initialize.sh'
vagrant sandbox commit controller
