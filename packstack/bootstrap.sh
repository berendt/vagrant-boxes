#!/bin/bash

set -x

JOBS=2

run_parallel() {
    python get_hosts.py | xargs -n 1 -P $JOBS -I BOX sh -c "vagrant $* BOX 2>&1 >> log/BOX.log"
}

echo "$(date) brining up all VMs"
run_parallel up --no-provision

echo "$(date) provisioning all VMs"
run_parallel provision

echo "$(date) reloading all VMs"
run_parallel reload

echo "$(date) enabling sandbox mode for all VMs"
run_parallel sandbox on

echo "$(date) initializing the controller node"
vagrant ssh controller -c '/home/vagrant/scripts/initialize.sh'
vagrant sandbox commit controller
