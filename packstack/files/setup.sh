#!/bin/sh

source /home/vagrant/openrc

glance image-create --name "CirrOS" --disk-format qcow2 --container-format bare --is-public True --copy http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img
glance image-create --name "Fedora 20" --disk-format qcow2 --container-format bare --is-public True --copy http://cloud.fedoraproject.org/fedora-20.x86_64.qcow2
glance image-create --name "Ubuntu 14.04" --disk-format qcow2 --container-format bare --is-public True --copy https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
glance image-create --name "CentOS 7" --disk-format qcow2 --container-format bare --is-public True --copy http://cloud.centos.org/centos/7/devel/CentOS-7-x86_64-GenericCloud.qcow2
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova keypair-add --pub_key /home/vagrant/.ssh/id_rsa.pub default
neutron net-create internal001
neutron subnet-create --name internal001 internal001 192.168.200.0/24
neutron router-create internal001
neutron router-interface-add internal001 internal001
