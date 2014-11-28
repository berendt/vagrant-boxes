#!/bin/sh

for node in compute001 compute002 network storage controller filer shared; do
    ssh-keyscan $node >> /home/vagrant/.ssh/known_hosts
done
chown vagrant:vagrant /home/vagrant/.ssh/known_hosts

for node in compute001 compute002 network storage controller filer shared; do
    ssh $node "sudo mkdir -p /root/.ssh"
    ssh $node "sudo chmod 700 /root/.ssh"
    ssh $node "sudo cp /home/vagrant/.ssh/* /root/.ssh"
    ssh $node "sudo chown -R root:root /root/.ssh"
done
