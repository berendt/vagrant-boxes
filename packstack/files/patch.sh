#!/bin/sh

# https://kojipkgs.fedoraproject.org/packages/openstack-packstack/
# http://kojipkgs.fedoraproject.org/packages/openstack-puppet-modules/

sudo yum remove -y openstack-packstack openstack-packstack-puppet openstack-puppet-modules

wget https://kojipkgs.fedoraproject.org/packages/openstack-puppet-modules/2014.2.4/1.fc22/noarch/openstack-puppet-modules-2014.2.4-1.fc22.noarch.rpm
wget https://kojipkgs.fedoraproject.org/packages/openstack-packstack/2014.2/0.7.dev1340.gd4df05a.fc22/noarch/openstack-packstack-2014.2-0.7.dev1340.gd4df05a.fc22.noarch.rpm
wget https://kojipkgs.fedoraproject.org/packages/openstack-packstack/2014.2/0.7.dev1340.gd4df05a.fc22/noarch/openstack-packstack-puppet-2014.2-0.7.dev1340.gd4df05a.fc22.noarch.rpm

sudo yum localinstall -y openstack-*.rpm
