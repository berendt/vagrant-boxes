#!/bin/sh

# http://docs.ceph.com/docs/master/start/quick-start-preflight/
# http://docs.ceph.com/docs/master/start/quick-ceph-deploy/
# http://docs.ceph.com/docs/master/start/quick-rbd/

release=giant

wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
echo deb http://ceph.com/debian-$release/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
sudo apt-get update
sudo apt-get install --yes ceph-deploy
sudo apt-get install --yes sshpass
ssh-keygen -t rsa -N '' -f $HOME/.ssh/id_rsa

for node in node001 node002 node003 node004; do
    ssh-keyscan $node >> $HOME/.ssh/known_hosts
    sshpass -p 'vagrant' ssh-copy-id -i $HOME/.ssh/id_rsa vagrant@$node
    ssh $node "wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -"
    ssh $node "echo deb http://ceph.com/debian-$release/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list"
    ssh $node "sudo apt-get update"
    ssh $node "sudo apt-get install --yes ceph ceph-mds ceph-common ceph-fs-common gdisk"
done

mkdir cluster001
cd cluster001

ceph-deploy new node001

echo "osd pool default size = 2" >> ceph.conf
echo "public network = 10.0.20.0/24" >> ceph.conf

ceph-deploy install --release $release node001 node002 node003 node004
ceph-deploy mon create-initial

ssh node001 'sudo mkdir -p /srv/osd0'
ssh node002 'sudo mkdir -p /srv/osd1'
ssh node003 'sudo mkdir -p /srv/osd2'

ssh node001 'sudo mkfs.xfs /dev/sdb'
ssh node002 'sudo mkfs.xfs /dev/sdb'
ssh node003 'sudo mkfs.xfs /dev/sdb'

ssh node001 'sudo echo "/dev/sdb /srv/osd0 xfs defaults 1 2" | sudo tee /etc/fstab'
ssh node002 'sudo echo "/dev/sdb /srv/osd1 xfs defaults 1 2" | sudo tee /etc/fstab'
ssh node003 'sudo echo "/dev/sdb /srv/osd2 xfs defaults 1 2" | sudo tee /etc/fstab'

ssh node001 'sudo mount /srv/osd0'
ssh node002 'sudo mount /srv/osd1'
ssh node003 'sudo mount /srv/osd2'

ceph-deploy osd prepare node001:/srv/osd0
ceph-deploy osd prepare node002:/srv/osd1
ceph-deploy osd prepare node003:/srv/osd2

ceph-deploy osd activate node001:/srv/osd0
ceph-deploy osd activate node002:/srv/osd1
ceph-deploy osd activate node003:/srv/osd2

ceph-deploy admin node002 node002 node003 node004

ceph-deploy mds create node001 node002 node003
ceph-deploy mon create node002 node003
