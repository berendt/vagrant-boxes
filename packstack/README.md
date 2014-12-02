# Packstack

This is a Vagrant environment providing a Packstack installation on top of CentOS. Packstack itself is available at <https://github.com/stackforge/packstack>.

## Requirements

The used provisioner is Ansible. To be able to start this Vagrant environment install Ansible on the Vagrant host.

    $ sudo yum install -y ansible

Additionally you can install the `vagrant-sandbox` plugin to 

    $ vagrant plugin install vagrant-sandbox

## Initialization

Copy the sample configuration file `config.yaml.sample` to `config.yaml` and ajust the file accordingly.

First run the `bootstrap.sh` script to prepare all required nodes.

    $ ./scripts/bootstraph.sh

Afterwards run the following command on the controller node (`vagrant ssh controller`) to deploy OpenStack with Packstack.

    $ packstack --answer-file packstack.answers
