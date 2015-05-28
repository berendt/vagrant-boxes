#!/bin/sh

set -x

/vagrant/scripts/prepare_controller.sh
/vagrant/scripts/controller_mariadb.sh
/vagrant/scripts/controller_rabbitmq.sh
/vagrant/scripts/controller_keystone.sh
/vagrant/scripts/controller_neutron.sh
for node in $(sed -n '/## vagrant-hostmanager-start/{:a;n;/## vagrant-hostmanager-end/b;p;ba}' /etc/hosts | awk '{ print $2 }' | grep network); do
    ssh root@$node '/vagrant/scripts/network.sh'
done
