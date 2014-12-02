#!/bin/bash

JOBS=2

has_sandbox_plugin() {
    vagrant plugin list | grep vagrant-sandbox > /dev/null
    return $?
}

run_parallel() {
    python scripts/get_hosts.py | xargs -n 1 -P $JOBS -I BOX sh -c "vagrant $* BOX 2>&1 >> log/BOX.log"
}

rm -f log/*

echo "$(date) brining up all VMs"
run_parallel up --no-provision

echo "$(date) provisioning all VMs"
run_parallel provision

echo "$(date) reloading all VMs"
run_parallel reload

if has_sandbox_plugin; then
    echo "$(date) enabling sandbox mode for all VMs"
    run_parallel sandbox on
fi

echo "$(date) initializing the controller node"
vagrant ssh controller -c '/home/vagrant/scripts/initialize.sh'

if has_sandbox_plugin; then
    vagrant sandbox commit controller
fi
