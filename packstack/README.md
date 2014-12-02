# Packstack

This is a Vagrant environment providing a Packstack installation. Packstack itself is available at <https://github.com/stackforge/packstack>.

## Requirements

To run this Vagrant environment you have to install the following Vagrant plugins:

- vagrant-sandbox (`vagrant plugin install vagrant-sandbox`)

## Initialization

First run the `bootstraph.sh` script to prepare all required nodes.

Afterwards run the following commands on the controller node (`vagrant ssh controller`) to deploy OpenStack.

    $ packstack --answer-file answers/shared.answers
    $ packstack --answer-file answers/controller.answers
    $ packstack --answer-file answers/storage.answers
    $ packstack --answer-file answers/network.answers
    $ packstack --answer-file answers/compute.answers

If you want to run the deployment in a single step use `packstack --answer-file answers/packstack.answers`.
